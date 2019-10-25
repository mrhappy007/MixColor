//
//  CustomCameraViewController.swift
//  Pha-Mau
//
//  Created by Hieu Nghia on 5/29/19.
//  Copyright © 2019 Hieu Nghia. All rights reserved.
//

import AVFoundation
import UIKit

protocol CustomCameraDelegate: class {
    func choosedColor(colorHexResult: String)
}

class CustomCameraViewController: UIViewController {
    @IBOutlet weak var previewView: UIView!
    @IBOutlet weak var previewColorView: UIView!
    @IBOutlet weak var confirmColorButton: UIButton!
    weak var customCameraDelegate: CustomCameraDelegate?

    var currentHexColor = ""

    let previewLayer = CALayer()
    let circleAroundColorPickUpPoint = CAShapeLayer()

    let captureSession = AVCaptureSession()
    var videoPreviewLayer: AVCaptureVideoPreviewLayer?

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupUI()
        createVideoPreview()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    func setupUI() {
        previewLayer.bounds = previewView.frame
        previewLayer.position = previewView.center
        previewLayer.contentsGravity = CALayerContentsGravity.resizeAspectFill
        previewLayer.setAffineTransform(CGAffineTransform(rotationAngle: CGFloat(.pi / 2.0)))
        previewView.layer.insertSublayer(previewLayer, at: 0)

        circleAroundColorPickUpPoint.frame =
            CGRect(x: previewView.frame.width / 2 - 20, y: previewView.frame.height / 2 - 20, width: 40, height: 40)
        circleAroundColorPickUpPoint.path = UIBezierPath(ovalIn: CGRect(x: 0, y: 0, width: 40, height: 40)).cgPath
        circleAroundColorPickUpPoint.lineWidth = 5
        circleAroundColorPickUpPoint.strokeColor = UIColor.gray.cgColor
        circleAroundColorPickUpPoint.fillColor = UIColor.clear.cgColor
        previewView.layer.insertSublayer(circleAroundColorPickUpPoint, at: 1)

        let colorPickUpPoint = CAShapeLayer()
        colorPickUpPoint.frame = CGRect(x: previewView.frame.width / 2 - 4, y: previewView.frame.height / 2 - 4, width: 8, height: 8)
        colorPickUpPoint.path = UIBezierPath(ovalIn: CGRect(x: 0, y: 0, width: 8, height: 8)).cgPath
        colorPickUpPoint.fillColor = UIColor(white: 0.7, alpha: 0.5).cgColor
        self.view.layer.insertSublayer(colorPickUpPoint, at: 1)
    }

    func createVideoPreview() {
        captureSession.sessionPreset = AVCaptureSession.Preset.hd1280x720
        guard let mainCamera = AVCaptureDevice.default(for: .video) else {
            return
        }
        mainCamera.isFocusModeSupported(.continuousAutoFocus)

        do {
            let captureDeviceInput = try AVCaptureDeviceInput(device: mainCamera)
            let videoOutput = AVCaptureVideoDataOutput()
            videoOutput.videoSettings = [kCVPixelBufferPixelFormatTypeKey as AnyHashable: NSNumber(value: kCMPixelFormat_32BGRA)] as? [String: Any]
            videoOutput.alwaysDiscardsLateVideoFrames = true
            videoOutput.setSampleBufferDelegate(self, queue: DispatchQueue(label: "camera.pick.up"))

            captureSession.canAddOutput(videoOutput) ? captureSession.addOutput(videoOutput) : nil
            captureSession.addInput(captureDeviceInput)
        } catch {
            print(error)
            return
        }

        captureSession.startRunning()
    }

    @IBAction func choosedColor(_ sender: UIButton) {
        customCameraDelegate?.choosedColor(colorHexResult: currentHexColor)
        dismiss(animated: true, completion: nil)
    }
}

extension CustomCameraViewController: AVCaptureVideoDataOutputSampleBufferDelegate {
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        guard let imageBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else {
            return
        }
        CVPixelBufferLockBaseAddress(imageBuffer, CVPixelBufferLockFlags(rawValue: CVOptionFlags(0)))
        guard let baseAddr = CVPixelBufferGetBaseAddressOfPlane(imageBuffer, 0) else {
            return
        }
        let width = CVPixelBufferGetWidthOfPlane(imageBuffer, 0)
        let height = CVPixelBufferGetHeightOfPlane(imageBuffer, 0)
        let bytesPerRow = CVPixelBufferGetBytesPerRowOfPlane(imageBuffer, 0)
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let bimapInfo: CGBitmapInfo = [.byteOrder32Little, CGBitmapInfo(rawValue: CGImageAlphaInfo.premultipliedFirst.rawValue)]

        guard let content = CGContext(data: baseAddr, width: width, height: height, bitsPerComponent: 8,
                                      bytesPerRow: bytesPerRow, space: colorSpace, bitmapInfo: bimapInfo.rawValue) else {
            return
        }

        guard let cgImage = content.makeImage() else {
            return
        }

        DispatchQueue.main.async {
            self.previewLayer.contents = cgImage
            let color = self.previewLayer.pickColor(at: CGPoint(x: self.previewView.frame.width / 2,
                                                                y: self.previewView.frame.height / 2))
            self.previewColorView.backgroundColor = color
            self.currentHexColor = color?.hex ?? ""
            self.circleAroundColorPickUpPoint.strokeColor = color?.cgColor
        }
    }
}

extension CALayer {
    func pickColor(at position: CGPoint) -> UIColor? {
        var pixel = [UInt8](repeatElement(0, count: 4))
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let bitmapInfo = CGImageAlphaInfo.premultipliedLast.rawValue
        guard let context = CGContext(data: &pixel, width: 1, height: 1, bitsPerComponent: 8, bytesPerRow: 4,
                                      space: colorSpace, bitmapInfo: bitmapInfo) else {
                                        return nil
        }
        context.translateBy(x: -position.x, y: -position.y)
        render(in: context)

        return UIColor(red: CGFloat(pixel[0]) / 255.0,
                       green: CGFloat(pixel[1]) / 255.0,
                       blue: CGFloat(pixel[2]) / 255.0,
                       alpha: CGFloat(pixel[3]) / 255.0)
    }
}

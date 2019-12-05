//
//  MixColorAPI.swift
//  Pha-Mau
//
//  Created by Hieu Nghia on 12/5/19.
//  Copyright © 2019 Hieu Nghia. All rights reserved.
//

import Foundation
import UIKit

enum NetworkError: Error {
    case domainError
    case decodingError
}

class MixColorAPI {

    static let share = MixColorAPI()

    private let key = "R56bvF8KD7y"
    private let type = "remix"
    private let url = "https://trycolors.com/handler.php"

    private func inputParamString(_ colorList: [ColorModel]) -> String {
        var dic = [String: Int]()
        for color in colorList {
            dic[String(color.hexCode)] = 0
        }
        guard let jsonData = try? JSONEncoder().encode(dic) else {
            return ""
        }
        guard let jsonString = String(data: jsonData, encoding: .utf8) else {
            return ""
        }
        return jsonString
    }

    private func outputParamString(_ mainColor: ColorModel) -> String {
        return mainColor.hexCode
    }

    private func data(_ mainColor: ColorModel, _ colorList: [ColorModel]) -> Data {
        let dataString = "key=" + key + "&type=" + type + "&input=" + inputParamString(colorList) + "&output=" + outputParamString(mainColor)
        guard let data = dataString.data(using: String.Encoding.utf8) else {
            return Data()
        }
        return data
    }

    private func getAPI(mainColor: ColorModel, colorList: [ColorModel], completion: @escaping (Result<[Int], NetworkError>) -> Void) {
        guard let url = URL(string: url) else {
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = data(mainColor, colorList)

        URLSession.shared.dataTask(with: request) { data, _, error in

            guard let data = data, error == nil else {
                if let error = error as NSError?, error.domain == NSURLErrorDomain {
                        completion(.failure(.domainError))
                }
                return
            }

            do {
                guard let jsonResponse = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] else {
                        return
                }
                guard let consistData = jsonResponse["consist"],
                    let outputDic = consistData as? [String: Int]  else {
                    return
                }
                completion(.success(Array(outputDic.values)))
            } catch {
                completion(.failure(.decodingError))
            }

        }.resume()
    }

//    func mix(mainColor: ColorModel, colorList: [ColorModel]) {
//        self.mainColor = mainColor
//        self.colorList = colorList
//
//        getAPI(mainColor: mainColor, colorList: colorList) { result in
//            switch result {
//            case .success(let dic):
//                break
//            case .failure:
//                break
//            }
//        }
//    }
}

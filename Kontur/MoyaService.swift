//
//  MoyaService.swift
//  Kontur
//
//  Created by Вадим Дзюба on 16.11.2024.
//

import Moya
import Foundation

enum SpaceXAPI {
    case rockets
    case launchesByRocket(id: String)
}

extension SpaceXAPI: TargetType {
    var baseURL: URL {
        return URL(string: "https://api.spacexdata.com/v4")!
    }
    
    var path: String {
        switch self {
            case .rockets:
                return "/rockets"
            case .launchesByRocket:
                return "/launches/query"
        }
    }
    
    var method: Moya.Method {
        switch self {
            case .launchesByRocket:
                return .post
            default:
                return .get
        }
    }
    
    var task: Task {
        switch self {
            case .launchesByRocket(let id):
                let requestBody: [String: Any] = [
                    "query": ["rocket": id],
                    "options": [:]
                ]
                return .requestParameters(parameters: requestBody, encoding: JSONEncoding.default)
            default:
                return .requestPlain
        }
    }
    
    var headers: [String: String]? {
        return ["Content-Type": "application/json"]
    }
    
    var sampleData: Data {
        return Data()
    }
}

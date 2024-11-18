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
}

extension SpaceXAPI: TargetType {
    var baseURL: URL {
        return URL(string: "https://api.spacexdata.com/v4")!
    }

    var path: String {
        switch self {
        case .rockets:
            return "/rockets"
        }
    }

    var method: Moya.Method {
        return .get
    }

    var task: Task {
        return .requestPlain
    }

    var headers: [String: String]? {
        return ["Content-Type": "application/json"]
    }

    var sampleData: Data {
        return Data()
    }
}

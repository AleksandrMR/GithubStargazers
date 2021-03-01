//
//  RequestRouter.swift
//  GithubStargazers
//
//  Created by Aleksandr Milashevski on 01/03/21.
//

import Foundation
import Alamofire

enum RequestRouter: URLRequestBuilder {
    case getListOfStargazers(pagen: Int)

    var path: String {
        switch self {
        case .getListOfStargazers:
            return ServerPaths.allStargazersList.rawValue
        }
    }

    var headers: HTTPHeaders? {
        switch self {
        default:
            return nil
        }
    }

    var parametrs: Parameters? {
        var param = Parameters()
        switch self {
        case .getListOfStargazers(pagen: let pagen):
            param[ServerParam.numberOfPage.rawValue] = pagen
        }
        return param
    }

    var method: HTTPMethod {
        switch self {
        case .getListOfStargazers:
            return .get
        }
    }
}

//
//  URLRequestBuilder.swift
//  GithubStargazers
//
//  Created by Aleksandr Milashevski on 01/03/21.
//

import Foundation
import Alamofire

protocol URLRequestBuilder: URLRequestConvertible {

    var baseURL: URL { get }
    var path: String { get }
    var headers: HTTPHeaders? { get }
    var parametrs: Parameters? { get }
    var method: HTTPMethod { get }
}

//MARK: - Extensions
extension URLRequestBuilder {

    var baseURL: URL {
        return URL(string: apiURL)!
    }

    func asURLRequest() throws -> URLRequest {
        let url = try baseURL.asURL()

        var request = URLRequest(url: url.appendingPathComponent(path))
        request.httpMethod = method.rawValue

        // what encoding is expected for each call
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        switch method {
        case .get:
            request.allHTTPHeaderFields = headers?.dictionary
            request = try URLEncoding.default.encode(request, with: parametrs)
        default:
            break
        }
        return request
    }
}

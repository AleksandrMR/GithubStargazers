//
//  RequestManager.swift
//  GithubStargazers
//
//  Created by Aleksandr Milashevski on 01/03/21.
//

import Foundation
import Alamofire

enum RequestResult<T: Codable> {
    case success(T)
    case failure(AFError)
}

class RequestManager<T: URLRequestBuilder> {
    func send<U: Codable>(service: T, decodeType: U.Type, complition: @escaping (RequestResult<U>) -> Void) {
        guard let urlRequest = service.urlRequest else { return }
        AF.request(urlRequest).responseDecodable(of: U.self) { response in
            switch response.result {
            case .success(let resulte):
                complition(.success(resulte))
            case .failure(let error):
                complition(.failure(error))
            }
        }
    }
}

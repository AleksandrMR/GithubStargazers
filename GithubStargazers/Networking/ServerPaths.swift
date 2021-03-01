//
//  ServerPaths.swift
//  GithubStargazers
//
//  Created by Aleksandr Milashevski on 01/03/21.
//

import Foundation

var apiURL: String {
    let baseURL = "https://api.github.com/repos/"
    return "\(baseURL)\(Constants.ownerForRequest)/\(Constants.repoForRequest)"
}

enum ServerPaths: String {
    case allStargazersList = "/stargazers"
   
}

enum ServerParam: String {
    case numberOfPage = "page"
    case limitElement = "per_page"
}

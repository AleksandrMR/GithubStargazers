//
//  Constants.swift
//  GithubStargazers
//
//  Created by Aleksandr Milashevski on 01/03/21.
//

import UIKit

class Constants {
    
    //    MARK: - Request
    
    static let baseURL = "https://api.github.com/repos/"
    static let endpoint = "/stargazers"
    
    static var limitElementForPage = 25
    static var indexOfPageToRequest = 1
    static var ownerForRequest = ""
    static var repoForRequest = ""
    
    //    MARK: - Application texts
    
    //    AlertSearchRepo
    static let titleAlertSearch = "Insert ownerName and repoName"
    static let messageOfSearchAlert = ""
    static let titleActionOfSearchAlert = "Search"
    static let titleCancelActionOfSearchAlert = "Cancel"
    static let ownerPlaceholderAlert = "enter owner name"
    static let repoPlaceholderAlert = "enter repo name"
    
    //    AlertError
    static let titleAlertError = "Error"
    static let titleActionAlertError = "OK"
    static let errorMessage = "Most likely you entered the wrong ownerName o repoName, please try again."
    
    
    static let viewCornerValue = CGFloat(19)
}


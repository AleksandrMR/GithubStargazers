//
//  UIViewControllerExtension.swift
//  GithubStargazers
//
//  Created by Aleksandr Milashevski on 01/03/21.
//

import UIKit

extension UIViewController {
    
    func alertOneButton(title: String,
                        message: String,
                        titleAction: String,
                        style: UIAlertController.Style,
                        handler: @escaping ((UIAlertAction) -> Void)) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: style)
        let action = UIAlertAction(title: titleAction, style: .default, handler: handler)
        alert.addAction(action)
        self.present(alert, animated: true, completion: nil)
    }
    
    func alertTwoButton(title: String,
                        message: String,
                        titleAction: String,
                        titleCancelAction: String,
                        style: UIAlertController.Style,
                        handlerAction: @escaping ((UIAlertAction) -> Void),
                        handlerCancel: @escaping ((UIAlertAction) -> Void)) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: style)
        let action = UIAlertAction(title: titleAction, style: .default, handler: handlerAction)
        let cancelAction = UIAlertAction(title: titleCancelAction, style: .cancel, handler: handlerCancel)
        alert.addAction(action)
        alert.addAction(cancelAction)
        self.present(alert, animated: true, completion: nil)
    }
}

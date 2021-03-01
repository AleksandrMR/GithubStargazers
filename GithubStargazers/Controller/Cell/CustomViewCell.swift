//
//  CustomViewCell.swift
//  GithubStargazers
//
//  Created by Aleksandr Milashevski on 01/03/21.
//

import UIKit
import Kingfisher

class CustomViewCell: UITableViewCell {

    //    MARK: - Outlets
    @IBOutlet weak var contentSubView: UIView!
    @IBOutlet weak var avaterImageView: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    
    //    MARK: - Flow funcs
    override func awakeFromNib() {
        super.awakeFromNib()
        
        contentSubView.myShadow()
        contentSubView.layer.cornerRadius = Constants.viewCornerValue
        avaterImageView.layer.cornerRadius = Constants.viewCornerValue
    }

    func configCell(with stargazers: ListStargazer) {
        
        guard let avatarURL = URL(string: stargazers.avatarURL ?? "") else { return }
        avaterImageView.kf.indicatorType = .activity
        avaterImageView.kf.setImage(with: avatarURL)
        
        guard let userName = stargazers.login else { return }
        userNameLabel.text = userName
    }
}

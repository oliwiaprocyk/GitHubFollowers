//
//  FollowersCell.swift
//  GitHubFollowers
//
//  Created by Oliwia Procyk on 16/04/2023.
//

import UIKit

class FollowersCell: UICollectionViewCell {
    
    static let reuseID = "FollowersCell"
    
    let avatarImageView = GHFAvatarImageView(frame: .zero)
    let usernameLabel = GHFTitleLabel(textAlignment: .center, fontSize: 16)
    
    let padding: CGFloat = 8
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubviews(avatarImageView, usernameLabel)
        configureImageView()
        configureLabel()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setCell(followers: FollowerModel) {
        avatarImageView.downloadImage(fromURL: followers.avatarUrl)
        usernameLabel.text = followers.login
    }
    
    private func configureImageView() {
        NSLayoutConstraint.activate([
            avatarImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: padding),
            avatarImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: padding),
            avatarImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -padding),
            avatarImageView.heightAnchor.constraint(equalToConstant: UIScreen.main.bounds.height * 100/896),
            avatarImageView.widthAnchor.constraint(equalTo: avatarImageView.heightAnchor)
        ])
    }
    
    private func configureLabel() {        
        NSLayoutConstraint.activate([
            usernameLabel.topAnchor.constraint(equalTo: avatarImageView.bottomAnchor, constant: 12),
            usernameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: padding),
            usernameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -padding),
            usernameLabel.heightAnchor.constraint(equalToConstant: 20)
        ])
    }
}

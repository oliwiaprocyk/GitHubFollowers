//
//  GHFItemInfoView.swift
//  GitHubFollowers
//
//  Created by Oliwia Procyk on 20/04/2023.
//

import UIKit

enum ItemInfoType {
    case repos, gists, followers, following
}

class GHFItemInfoView: UIView {
    
    let symbolImageView = UIImageView()
    let titleLable = GHFTitleLabel(textAlignment: .left, fontSize: 14)
    let countLabel = GHFTitleLabel(textAlignment: .center, fontSize: 14)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
        addSubviews(symbolImageView, titleLable, countLabel)
        
        symbolImageView.translatesAutoresizingMaskIntoConstraints = false
        symbolImageView.contentMode = .scaleAspectFill
        symbolImageView.tintColor = .label
        
        NSLayoutConstraint.activate([
            symbolImageView.topAnchor.constraint(equalTo: self.topAnchor),
            symbolImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            symbolImageView.widthAnchor.constraint(equalToConstant: 20),
            symbolImageView.heightAnchor.constraint(equalToConstant: 20),
            
            titleLable.centerYAnchor.constraint(equalTo: symbolImageView.centerYAnchor),
            titleLable.leadingAnchor.constraint(equalTo: symbolImageView.trailingAnchor, constant: 12),
            titleLable.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            titleLable.heightAnchor.constraint(equalToConstant: 18),
            
            countLabel.topAnchor.constraint(equalTo: symbolImageView.bottomAnchor, constant: 4),
            countLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            countLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            countLabel.heightAnchor.constraint(equalToConstant: 18)
        ])
    }
    
    func set(itemInfoType: ItemInfoType, withCount: Int) {
        switch itemInfoType {
        case .repos:
            symbolImageView.image = SFSymbols.repos
            titleLable.text = "Puplic Repos"
        case .gists:
            symbolImageView.image = SFSymbols.gists
            titleLable.text = "Puplic Gists"
        case .followers:
            symbolImageView.image = SFSymbols.followers
            titleLable.text = "Followers"
        case .following:
            symbolImageView.image = SFSymbols.following
            titleLable.text = "Following"
        }
        countLabel.text = String(withCount)
    }
}

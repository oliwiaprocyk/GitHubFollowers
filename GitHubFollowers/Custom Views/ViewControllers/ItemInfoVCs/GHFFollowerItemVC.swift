//
//  GHFFollowerItemVC.swift
//  GitHubFollowers
//
//  Created by Oliwia Procyk on 20/04/2023.
//

import UIKit

protocol GHFFollowerItemVCDelegate: AnyObject {
    func didTapGetFollowers(for user: UserModel)
}

class GHFFollowerItemVC: GHFItemInfoVC {
    
    weak var delegate: GHFFollowerItemVCDelegate!
    
    init(user: UserModel, delegate: GHFFollowerItemVCDelegate){
        super.init(user: user)
        self.delegate = delegate
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureItems()
    }
    
    private func configureItems() {
        itemInfoViewOne.set(itemInfoType: .followers, withCount: user.followers)
        itemInfoViewTwo.set(itemInfoType: .following, withCount: user.following)
        actionButton.set(backgroundColor: .systemGreen, title: "Get Followers")
    }
    
    override func actionButtonTapped() {
        delegate.didTapGetFollowers(for: user)
    }
}

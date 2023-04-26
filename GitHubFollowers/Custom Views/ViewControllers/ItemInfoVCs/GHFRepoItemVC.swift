//
//  GHFRepoItemVC.swift
//  GitHubFollowers
//
//  Created by Oliwia Procyk on 20/04/2023.
//

import UIKit

protocol GHFRepoItemVCDelegate: AnyObject {
    func didTapGitHubProfile(for user: UserModel)
}

class GHFRepoItemVC: GHFItemInfoVC {
    
    weak var delegate: GHFRepoItemVCDelegate!
    
    init(user: UserModel, delegate: GHFRepoItemVCDelegate){
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
        itemInfoViewOne.set(itemInfoType: .repos, withCount: user.publicRepos)
        itemInfoViewTwo.set(itemInfoType: .gists, withCount: user.publicGists)
        actionButton.set(backgroundColor: .systemPurple, title: "Github Profile")
    }
    
    override func actionButtonTapped() {
        delegate.didTapGitHubProfile(for: user)
    }
}

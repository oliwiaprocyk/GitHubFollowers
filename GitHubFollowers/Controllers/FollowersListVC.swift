//
//  FollowersListVC.swift
//  GitHubFollowers
//
//  Created by Oliwia Procyk on 14/04/2023.
//

import UIKit

class FollowersListVC: GHFDataLoadingVC {
    
    enum Section {
        case main
    }
    
    var username: String!
    var followers: [FollowerModel] = []
    var filteredFollowers: [FollowerModel] = []
    
    var page: Int = 1
    var hasMoreFollowers = true
    var isSearching = false
    var isLoadingMoreFollowers = false
    
    var collectionView: UICollectionView!
    var dataSource: UICollectionViewDiffableDataSource<Section, FollowerModel>!
    
    init(username: String) {
        super.init(nibName: nil, bundle: nil)
        self.username = username
        title = username
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureViewController()
        configureSearchController()
        configureCollectionView()
        getFollowers(username: username, page: page)
        configureDataSource()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    private func configureViewController() {
        view.backgroundColor = .systemBackground
        navigationController?.navigationBar.prefersLargeTitles = true
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addButtonTapped))
    }
    
    private func configureSearchController() {
        let searchController = UISearchController()
        searchController.searchResultsUpdater = self
        searchController.searchBar.placeholder = "Search for a username"
        
        navigationItem.searchController = searchController
    }
    
    private func getFollowers(username: String, page: Int) {
        showLoadingView()
        isLoadingMoreFollowers = true
        
        NetworkManager.shared.getFollowers(username: username, page: page) { [weak self] result in
            
            guard let self = self else { return }
            self.dismissLoadingView()
            
            switch result {
            case .success(let followers):
                self.updateUI(with: followers)
                
            case .failure(let error):
                self.presentGHFAlertOnMainThread(alertTitle: "Error", message: error.rawValue, buttonTitle: "Ok")
            }
            
            self.isLoadingMoreFollowers = false
        }
    }
    
    private func updateUI(with followers: [FollowerModel]) {
        if followers.count < 100 { self.hasMoreFollowers = false }
        self.followers.append(contentsOf: followers)
        
        if self.followers.isEmpty {
            let message = "This user doesn't have any followers. Go follow them 😄"
            DispatchQueue.main.async {
                self.showEmptyStateView(message: message, view: self.view)
            }
            return
        }
        
        self.updateData(followers: self.followers)
    }
    
    private func configureCollectionView() {
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: UIHelper.createThreeColumnFlowLayout(with: view))
        view.addSubview(collectionView)
        
        collectionView.delegate = self
        
        collectionView.backgroundColor = .systemBackground
        collectionView.register(FollowersCell.self, forCellWithReuseIdentifier: FollowersCell.reuseID)
    }
    
    private func configureDataSource() {
        dataSource = UICollectionViewDiffableDataSource<Section, FollowerModel>(collectionView: collectionView, cellProvider: { collectionView, indexPath, follower in
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FollowersCell.reuseID, for: indexPath) as! FollowersCell
            cell.setCell(followers: follower)
            
            return cell
        })
    }
    
    private func updateData(followers: [FollowerModel]) {
        var snapshot = NSDiffableDataSourceSnapshot<Section, FollowerModel>()
        snapshot.appendSections([.main])
        snapshot.appendItems(followers)
        
        DispatchQueue.main.async {
            self.dataSource.apply(snapshot, animatingDifferences: true)
        }
    }
    
    @objc private func addButtonTapped() {
        showLoadingView()
        
        NetworkManager.shared.getUserInfo(username: username) { [weak self] result in
            guard let self = self else { return }
            self.dismissLoadingView()
            
            switch result {
            case .success(let user):
                self.addUserToFavorites(user: user)
                
            case .failure(let error):
                self.presentGHFAlertOnMainThread(alertTitle: "Something went wrong", message: error.rawValue, buttonTitle: "Ok")
            }
        }
    }
    
    private func addUserToFavorites(user: UserModel) {
        let favorite = FollowerModel(login: user.login, avatarUrl: user.avatarUrl)
        
        PersistenceManager.updateWith(favorite: favorite, actionType: .add) { [weak self] error in
            guard let self = self else { return }
            
            guard let error = error else {
                self.presentGHFAlertOnMainThread(alertTitle: "Success!", message: "You have successfully favorited this user 🎉", buttonTitle: "Hooray!")
                return
            }
            
            self.presentGHFAlertOnMainThread(alertTitle: "Something went wrong", message: error.rawValue, buttonTitle: "Ok")
        }
    }
}

extension FollowersListVC: UICollectionViewDelegate {
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        let height = scrollView.frame.size.height
        
        if offsetY >= contentHeight - height {
            guard hasMoreFollowers, !isLoadingMoreFollowers else {return}
            page += 1
            getFollowers(username: username, page: page)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let activeArray = isSearching ? filteredFollowers : followers
        let follower = activeArray[indexPath.item]
        
        let userInfoVC = UserInfoVC(username: follower.login)
        
        userInfoVC.delegate = self
        let navController = UINavigationController(rootViewController: userInfoVC)
        
        present(navController, animated: true)
    }
}

extension FollowersListVC: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard let filter = searchController.searchBar.text, !filter.isEmpty else {
            filteredFollowers.removeAll()
            updateData(followers: followers)
            isSearching = false
            return
        }
        isSearching = true
        
        filteredFollowers = followers.filter({$0.login.lowercased().contains(filter.lowercased())})
        updateData(followers: filteredFollowers)
    }
}

extension FollowersListVC: UserInfoVCDelegate {
    func didRequestFollowers(username: String) {
        self.username = username
        self.title = username
        self.page = 1
        
        self.followers.removeAll()
        self.filteredFollowers.removeAll()
        
        self.getFollowers(username: username, page: page)
        self.collectionView.scrollToItem(at: IndexPath(item: 0, section: 0), at: .top, animated: true)
    }
}

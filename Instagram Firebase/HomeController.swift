//
//  HomeController.swift
//  Instagram Firebase
//
//  Created by Juan Ramirez on 9/1/20.
//  Copyright © 2020 Sebapps. All rights reserved.
//

import UIKit
import Firebase

class HomeController: UICollectionViewController {
    
    private var posts = [Post]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.backgroundColor = .white
        
        collectionView.register(HomePostCell.self, forCellWithReuseIdentifier: HomePostCell.cellId)
        
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(handleRefresh), for: .valueChanged)
        collectionView.refreshControl = refreshControl
        
        setupNavigationItems()
        
        fetchAllPosts()
    }
    
    private func setupNavigationItems() {
        let instagramLogoImage = UIImage(named: "Instagram_logo_white")?.withRenderingMode(.alwaysTemplate)
        navigationItem.titleView = UIImageView(image: instagramLogoImage)
        navigationItem.titleView?.tintColor = .black
    }
    
    @objc private func handleUpdateHomeFeed() {
        handleRefresh()
    }
    
    private func fetchAllPosts() {
        fetchCurrentUserPosts()
        fetchFollowingUserIds()
    }
    
    private func fetchCurrentUserPosts() {
        guard let uid = Auth.auth().currentUser?.uid else { return }

        Database.fetchUserWithUID(uid: uid) { [unowned self] (user) in
            self.fetchPostsWithUser(user)
        }
    }
    
    fileprivate func fetchFollowingUserIds() {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        let reference = Database.database().reference().child("following").child(uid)
        
        reference.observeSingleEvent(of: .value, with: { (snapshot) in
            guard let userIdsDictionary = snapshot.value as? [String: Any] else { return }
            
            userIdsDictionary.forEach { (followedUserId, _) in
                Database.fetchUserWithUID(uid: followedUserId) { (user) in
                    self.fetchPostsWithUser(user)
                }
            }
        }) { (error) in
            print("Failed to fetch following user ids: \(error)")
        }
    }
    
    fileprivate func fetchPostsWithUser(_ user: User) {
        let reference = Database.database().reference().child("posts").child(user.uid)
        
        reference.observeSingleEvent(of: .value, with: { (snapshot) in
            self.collectionView.refreshControl?.endRefreshing()
            
            guard let snapshotDictionaries = snapshot.value as? [String: Any] else { return }
            
            snapshotDictionaries.forEach { (key, value) in
                guard let dictionary = value as? [String: Any] else { return }
                
                let post = Post(user: user, dictionary: dictionary)
                self.posts.append(post)
            }
            
            self.posts.sort { (post1, post2) -> Bool in
                return post1.creationDate.compare(post2.creationDate) == .orderedDescending
            }
            
            self.collectionView.reloadData()
        }) { (error) in
            print("Failed to fetch posts: \(error)")
        }
    }
    
    // iOS9
    // let refreshControl = UIRefreshControl()
    
    @objc private func handleRefresh() {
        posts.removeAll()
        fetchAllPosts()
    }
    
}

// MARK: - Datasource

extension HomeController {
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return posts.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HomePostCell.cellId, for: indexPath) as? HomePostCell else { return UICollectionViewCell() }
        
        cell.post = posts[indexPath.item]
        
        return cell
    }
    
}

// MARK: - HomeController: UICollectionViewDelegateFlowLayout

extension HomeController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        // This is how to render a 1:1 aspect ratio
        var height: CGFloat = 40 + 8 + 8 // Username + userProfileImageView
        height += view.frame.width // For image
        height += 50  // For action buttons
        height += 60
        
        return .init(width: collectionView.frame.width, height: height)
    }
    
}

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
        
        setupNavigationItems()
        
        fetchPosts()
    }
    
    private func setupNavigationItems() {
        let instagramLogoImage = UIImage(named: "Instagram_logo_white")?.withRenderingMode(.alwaysTemplate)
        navigationItem.titleView = UIImageView(image: instagramLogoImage)
        navigationItem.titleView?.tintColor = .black
    }
    
    private func fetchPosts() {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        let reference = Database.database().reference().child("posts").child(uid)

        reference.observeSingleEvent(of: .value, with: { (snapshot) in
            guard let snapshotDictionaries = snapshot.value as? [String: Any] else { return }

            snapshotDictionaries.forEach { (key, value) in
                guard let dictionary = value as? [String: Any] else { return }

                let post = Post(dictionary: dictionary)
                self.posts.append(post)
            }

            self.collectionView.reloadData()
        }) { (error) in
            print("Failed to fetch posts: \(error)")
        }
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
        return .init(width: collectionView.frame.width, height: 200)
    }
    
}

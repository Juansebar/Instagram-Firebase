//
//  UserProfileController.swift
//  Instagram Firebase
//
//  Created by Juan Ramirez on 8/17/20.
//  Copyright © 2020 Sebapps. All rights reserved.
//

import UIKit
import Firebase

class UserProfileController: UICollectionViewController {
    
    var userId: String?
    private var user: User?
    
    private let interItemSpacing: CGFloat = 0.5
    
    private var posts = [Post]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView?.backgroundColor = .white
        
        fetchUser {
            self.fetchOrderedPosts()
        }
        
        collectionView.register(UserProfileHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "headerId")
        collectionView.register(UserProfilePhotoCell.self, forCellWithReuseIdentifier: UserProfilePhotoCell.cellId)
        
        setupLogoutButton()
    }
    
    private func fetchUser(completion: @escaping () -> Void) {
        guard let uid = userId ?? Auth.auth().currentUser?.uid else { return }
        
        Database.fetchUserWithUID(uid: uid) { [unowned self] (user) in
            self.user = user
            
            self.navigationItem.title = self.user?.username ?? ""
            self.collectionView.reloadData()
            
            completion()
        }
    }
    
    private func setupLogoutButton() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "gear")?.withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(handleLogout))
    }
    
    @objc private func handleLogout() {
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        alertController.addAction(UIAlertAction(title: "Log Out", style: .destructive, handler: { (_) in
            print("Perform log out")
            do {
                try Auth.auth().signOut()
                
                let loginController = LoginController()
                let navigationController = UINavigationController(rootViewController: loginController)
                navigationController.modalPresentationStyle = .fullScreen
                self.present(navigationController, animated: true, completion: nil)
            } catch let signoutError {
                print("Failed to sign out: \(signoutError)")
            }
        }))
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        present(alertController, animated: true, completion: nil)
    }
    
    private func fetchPosts() {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        let reference = Database.database().reference().child("posts").child(uid)
        
        reference.observeSingleEvent(of: .value, with: { (snapshot) in
            guard let snapshotDictionaries = snapshot.value as? [String: Any] else { return }
            
            snapshotDictionaries.forEach { (key, value) in
                guard let dictionary = value as? [String: Any] else { return }
                
                guard let user = self.user else { return }
                let post = Post(user: user, dictionary: dictionary)
                self.posts.append(post)
            }
            
            self.collectionView.reloadData()
        }) { (error) in
            print("Failed to fetch posts: \(error)")
        }
    }
    
    private func fetchOrderedPosts() {
        guard let uid = user?.uid else { return }
        let ref = Database.database().reference().child("posts").child(uid)
        
        // Later implement some pagination of data
        ref.queryOrdered(byChild: "creationDate").observe(.childAdded, with: { (snapshot) in
            guard let user = self.user else { return }
            guard let dictionary = snapshot.value as? [String: Any] else { return }
            let post = Post(user: user, dictionary: dictionary)
            self.posts.insert(post, at: 0)

            self.collectionView.reloadData()
        }) { (error) in
            print("Failed to fetch new post: \(error)")
        }
    }
    
}

extension UserProfileController: UICollectionViewDelegateFlowLayout {
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return posts.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: UserProfilePhotoCell.cellId, for: indexPath) as? UserProfilePhotoCell else { return UICollectionViewCell() }
        
        cell.post = posts[indexPath.item]
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "headerId", for: indexPath) as? UserProfileHeader else { return UICollectionViewCell() }
        
        header.user = user
        header.backgroundColor = .white
        return header
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return .init(width: view.frame.width, height: 200)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let measurement = (view.frame.width - (interItemSpacing * 2)) / 3 
        return .init(width: measurement, height: measurement)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return interItemSpacing * 2
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return interItemSpacing
    }
    
}

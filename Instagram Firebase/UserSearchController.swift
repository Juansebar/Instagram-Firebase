//
//  UserSearchController.swift
//  Instagram Firebase
//
//  Created by Juan Ramirez on 9/26/20.
//  Copyright © 2020 Sebapps. All rights reserved.
//

import UIKit
import Firebase

class UserSearchController: UICollectionViewController {
    
    private var users: [User] = []
    private var filteredUsers: [User] = []
    
    private lazy var searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.placeholder = "Enter username"
        searchBar.tintColor = .gray
        searchBar.delegate = self
//        UITextField.appearance(whenContainedInInstancesOf: [UISearchBar.self]).backgroundColor = UIColor(red: 240/255, green: 240/255, blue: 240/255, alpha: 1)
        return searchBar
    }()  // This executes the closure and returns your searchBar
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.titleView = searchBar
        
        collectionView.alwaysBounceVertical = true
        collectionView?.backgroundColor = .white
        
        collectionView.register(UserSearchCell.self, forCellWithReuseIdentifier: UserSearchCell.cellId)
        
        fetchUsers()
    }
    
    fileprivate func fetchUsers() {
        let reference = Database.database().reference().child("users")
        
        reference.observeSingleEvent(of: .value, with: { (snapshot) in
            guard let dictionaries = snapshot.value as? [String: Any] else { return }
            
            dictionaries.forEach { (key, _) in
                Database.fetchUserWithUID(uid: key) { [unowned self] (user) in
                    self.users.append(user)
                    self.filteredUsers.append(user)
                }
                
                self.collectionView.reloadData()
            }
        }) { (error) in
            print("Failed to fetch users: \(error)")
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return filteredUsers.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: UserSearchCell.cellId, for: indexPath) as? UserSearchCell else { return UICollectionViewCell() }
        
        cell.user = filteredUsers[indexPath.item]
        
        return cell
    }
    
}

// MARK: - UserSearchController: UICollectionViewDelegateFlowLayout

extension UserSearchController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return .init(width: view.frame.width, height: 66)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return .zero
    }
    
}

// MARK: - UserSearchController: UISearchBarDelegate

extension UserSearchController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.count > 0 {
            filteredUsers = users.filter { (user) -> Bool in
                return user.username.contains(searchText)
            }
        } else {
            filteredUsers = users
        }
        
        collectionView.reloadData()
    }
    
}

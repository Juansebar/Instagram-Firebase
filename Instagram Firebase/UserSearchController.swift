//
//  UserSearchController.swift
//  Instagram Firebase
//
//  Created by Juan Ramirez on 9/26/20.
//  Copyright © 2020 Sebapps. All rights reserved.
//

import UIKit

class UserSearchController: UICollectionViewController {
    
    private let searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.placeholder = "Enter username"
        searchBar.tintColor = .gray
//        UITextField.appearance(whenContainedInInstancesOf: [UISearchBar.self]).backgroundColor = UIColor(red: 240/255, green: 240/255, blue: 240/255, alpha: 1)
        return searchBar
    }()  // This executes the closure and returns your searchBar
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.titleView = searchBar
        
        collectionView.alwaysBounceVertical = true
        collectionView?.backgroundColor = .white
        
        collectionView.register(UserSearchCell.self, forCellWithReuseIdentifier: UserSearchCell.cellId)
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: UserSearchCell.cellId, for: indexPath) as? UserSearchCell else { return UICollectionViewCell() }
        
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

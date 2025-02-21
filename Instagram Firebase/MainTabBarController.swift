//
//  MainTabBarController.swift
//  Instagram Firebase
//
//  Created by Juan Ramirez on 8/17/20.
//  Copyright © 2020 Sebapps. All rights reserved.
//

import UIKit
import Firebase

class MainTabBarController : UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        delegate = self
        
        // Check if user is logged in
        if Auth.auth().currentUser == nil {
            DispatchQueue.main.async {
                let loginController = LoginController()
                let navigationController = UINavigationController(rootViewController: loginController)
                navigationController.modalPresentationStyle = .fullScreen
                self.present(navigationController, animated: true, completion: nil)
                return
            }
        }
        
        view.backgroundColor = .white
        
        setupViewControllers()
    }
    
    private func setupViewControllers() {
        // Home
        let homeFlowLayout = UICollectionViewFlowLayout()
        let homeController = HomeController(collectionViewLayout: homeFlowLayout)
        homeController.view.backgroundColor = .white
        let homeNavController = templateNavigationController(root: homeController, unselectedIcon: "home_unselected", selectedIcon: "home_selected")
        
        // Search
        let searchFlowlayout = UICollectionViewFlowLayout()
        let searchController = UserSearchController(collectionViewLayout: searchFlowlayout)
        searchController.view.backgroundColor = .white
        let searchNavController = templateNavigationController(root: searchController, unselectedIcon: "search_unselected", selectedIcon: "search_selected")
        
        // Camera
        let cameraController = UIViewController()
        cameraController.view.backgroundColor = .white
        let cameraNavController = templateNavigationController(root: cameraController, unselectedIcon: "plus_unselected", selectedIcon: "plus_unselected")
        
        // Favorites
        let favoritesController = UIViewController()
        favoritesController.view.backgroundColor = .white
        let favoritesNavController = templateNavigationController(root: favoritesController, unselectedIcon: "like_unselected", selectedIcon: "like_selected")
        
        // User Profile
        let profileFlowlayout = UICollectionViewFlowLayout()
        let userProfileController = UserProfileController(collectionViewLayout: profileFlowlayout)
        userProfileController.view.backgroundColor = .white
        let userProfileNavController = templateNavigationController(root: userProfileController, unselectedIcon: "profile_unselected", selectedIcon: "profile_selected")
        
        tabBar.tintColor = .black
        viewControllers = [homeNavController,
                           searchNavController,
                           cameraNavController,
                           favoritesNavController,
                           userProfileNavController]
        
        // Modify tab bar item insets
        guard let tabBarItems = tabBar.items else { return }
        for item in tabBarItems {
            item.imageInsets = UIEdgeInsets(top: 4, left: 0, bottom: -4, right: 0)
        }
        
    }
    
    func resetViewControllers() {
        setupViewControllers()
    }
    
    private func templateNavigationController(root viewController: UIViewController, unselectedIcon: String?, selectedIcon: String?) -> UINavigationController {
        let navigationController = UINavigationController(rootViewController: viewController)
        
        if let imageName = unselectedIcon {
            navigationController.tabBarItem.image = UIImage(named: imageName)
        }
        if let imageName = selectedIcon {
            navigationController.tabBarItem.image = UIImage(named: imageName)
        }
        
        return navigationController
    }
    
}

extension MainTabBarController: UITabBarControllerDelegate {
    
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        let index = viewControllers?.firstIndex(of: viewController)
        
        if index == 2 {
            let layout = UICollectionViewFlowLayout()
            let photoSelectorController = PhotoSelectorController(collectionViewLayout: layout)
            let photoSelectorNavController = templateNavigationController(root: photoSelectorController, unselectedIcon: nil, selectedIcon: nil)
            present(photoSelectorNavController, animated: true, completion: nil)
            
            return false
        }
        
        return true
    }
    
}

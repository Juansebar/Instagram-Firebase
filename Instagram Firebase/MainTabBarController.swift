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
        let layout = UICollectionViewFlowLayout()
        let userProfileController = UserProfileController(collectionViewLayout: layout)
        userProfileController.view.backgroundColor = .red
        
        let navigationController = UINavigationController(rootViewController: userProfileController)
        navigationController.tabBarItem.image = UIImage(named: "profile_unselected")
        navigationController.tabBarItem.selectedImage =  UIImage(named: "profile_selected")
        
        tabBar.tintColor = .black
        viewControllers = [navigationController, UIViewController()]
    }
    
    func resetViewControllers() {
        setupViewControllers()
    }
    
}

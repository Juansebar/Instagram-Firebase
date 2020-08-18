//
//  LoginController.swift
//  Instagram Firebase
//
//  Created by Juan Ramirez on 8/18/20.
//  Copyright © 2020 Sebapps. All rights reserved.
//

import UIKit

class LoginController: UIViewController {
    
    private let signUpButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Don't have an account? Sign Up", for: .normal)
        button.addTarget(self, action: #selector(handleShowSignUp), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        view.addSubview(signUpButton)
        
        setupViews()
    }
    
    private func setupViews() {
        signUpButton.anchor(top: nil, left: view.leftAnchor, bottom: view.readableContentGuide.bottomAnchor, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 50)
    }
    
    @objc private func handleShowSignUp() {
        
    }
    
}

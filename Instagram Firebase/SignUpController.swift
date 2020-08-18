//
//  SignUpController.swift
//  Instagram Firebase
//
//  Created by Juan Ramirez on 8/17/20.
//  Copyright © 2020 Sebapps. All rights reserved.
//

import UIKit
import Firebase

class SignUpController: UIViewController {

    private let plusPhotoButton: UIButton = {
        let button = UIButton(type: .system)  // Makes it highlight with white
        button.backgroundColor = .white
        button.setImage(UIImage(named: "plus_photo")?.withRenderingMode(.alwaysOriginal), for: .normal)
        button.addTarget(self, action: #selector(handlePlusPhoto), for: .touchUpInside)
        button.layer.cornerRadius = 140/2
        button.layer.masksToBounds = true
//        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let emailTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Email"
//        textField.backgroundColor = UIColor.lightGray.withAlphaComponent(0.1)
        textField.backgroundColor = UIColor(white: 0, alpha: 0.03)
        textField.borderStyle = .roundedRect
        textField.font = UIFont.systemFont(ofSize: 14)
        textField.addTarget(self, action: #selector(handleTextInputChanged), for: .editingChanged)
        return textField
    }()
    
    private let usernameTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Username"
        textField.backgroundColor = UIColor(white: 0, alpha: 0.03)
        textField.borderStyle = .roundedRect
        textField.font = UIFont.systemFont(ofSize: 14)
        textField.addTarget(self, action: #selector(handleTextInputChanged), for: .editingChanged)
        return textField
    }()
    
    private let passwordTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Password"
        textField.backgroundColor = UIColor(white: 0, alpha: 0.03)
        textField.borderStyle = .roundedRect
        textField.font = UIFont.systemFont(ofSize: 14)
        textField.isSecureTextEntry = true
        textField.addTarget(self, action: #selector(handleTextInputChanged), for: .editingChanged)
        return textField
    }()
    
    private lazy var textFieldStackView: UIStackView = {
        let stackview = UIStackView(arrangedSubviews: [emailTextField, usernameTextField, passwordTextField, signUpButton])
        stackview.axis = .vertical
        stackview.alignment = .fill
        stackview.distribution = .fillEqually
        stackview.spacing = 12
        return stackview
    }()
    
    private let signUpButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Sign Up", for: .normal)
        button.backgroundColor = UIColor.rgb(r: 149, g: 204, b: 244)
        button.layer.cornerRadius = 5
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        button.setTitleColor(.white, for: .normal)
        button.isEnabled = false
        
        button.addTarget(self, action: #selector(handleSignUp), for: .touchUpInside)
        
        return button
    }()
    
    private var selectedImage: UIImage? {
        didSet {
            guard let image = selectedImage else { return }
            
            self.plusPhotoButton.setImage(image, for: .normal)
            plusPhotoButton.layer.borderColor = UIColor.black.withAlphaComponent(0.5).cgColor
            plusPhotoButton.layer.borderWidth = 3
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        view.backgroundColor = .white
        
        setupViews()
        setConstraints()
    }
    
    private func setupViews() {
        view.addSubview(plusPhotoButton)
        view.addSubview(textFieldStackView)
    }
    
    private func setConstraints() {
        plusPhotoButton.anchor(top: view.readableContentGuide.topAnchor, left: nil, bottom: nil, right: nil, paddingTop: 25, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 140, height: 140)
        plusPhotoButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        emailTextField.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        textFieldStackView.anchor(top: plusPhotoButton.bottomAnchor, left: view.readableContentGuide.leftAnchor, bottom: nil, right: view.readableContentGuide.rightAnchor, paddingTop: 20, paddingLeft: 25, paddingBottom: 0, paddingRight: -25, width: 0, height: 0)
    }

    @objc private func handleSignUp() {
        guard let email = emailTextField.text, email.count > 0 else { return }
        guard let username = usernameTextField.text, username.count > 0 else { return }
        guard let password = passwordTextField.text, password.count > 0 else { return }
        
        Auth.auth().createUser(withEmail: email, password: password) { (authResult, error) in
            if let error = error {
                print("Failed to create user: \(error.localizedDescription)")
                return
            }
            
            guard let user = authResult?.user else { return }
            print("Successfully created user: \(user.uid)")
            
            // MARK: - Uploading Profile Image
            
            guard let image = self.plusPhotoButton.imageView?.image else { return }
            guard let uploadData = image.jpegData(compressionQuality: 0.3) else { return }
            
            let filename = UUID().uuidString
            let storageRef = Storage.storage().reference().child("profile_images").child(filename)
            
            storageRef.putData(uploadData, metadata: nil) { (metadata, error) in
                if let error = error {
                    print("Failed to upload profile image: \(error)")
                    return
                }
                
                storageRef.downloadURL { (downloadUrl, error) in
                    if let error = error {
                        print("Failed to fetch downloadURL: \(error)")
                        return
                    }
                    
                    guard let profileImageUrl = downloadUrl?.absoluteString else { return }
                    
                    print("Successfully uploaded profile image: \(profileImageUrl)")
                    
                    // MARK: - Uploading User Info
                    
                    let dictionaryValues = ["username": username, "profileImageUrl": profileImageUrl]
                    let values = [user.uid: dictionaryValues]
                    Database.database().reference().child("users").updateChildValues(values) { (err, dbRef) in
                        if let err = err {
                            print("Failed to save user info into db: \(err)")
                            return
                        }

                        print("Successfully saved user info to db")
                    }
                }
                
            }
        }
    }
    
    @objc private func handleTextInputChanged() {
        let isFormValid = emailTextField.text?.count ?? 0 > 0 && usernameTextField.text?.count ?? 0 > 0 && passwordTextField.text?.count ?? 0 > 0

        signUpButton.backgroundColor = isFormValid ? UIColor.rgb(r: 17, g: 154, b: 237) : UIColor.rgb(r: 149, g: 204, b: 244)
        signUpButton.isEnabled = isFormValid
    }
    
    @objc private func handlePlusPhoto() {
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.allowsEditing = true
        present(imagePickerController, animated: true, completion: nil)
    }
    
}

extension SignUpController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    public func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let editedImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            selectedImage = editedImage.withRenderingMode(.alwaysOriginal)
        } else if let originalImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            selectedImage = originalImage.withRenderingMode(.alwaysOriginal)
        }
    
        dismiss(animated: true, completion: nil)
    }
    
}

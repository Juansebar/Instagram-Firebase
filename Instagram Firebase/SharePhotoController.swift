//
//  SharePhotoController.swift
//  Instagram Firebase
//
//  Created by Juan Ramirez on 8/19/20.
//  Copyright © 2020 Sebapps. All rights reserved.
//

import UIKit
import Firebase

class SharePhotoController: UIViewController {
    
    private let photoThumbnailImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = UIColor.rgb(r: 240, g: 240, b: 240)
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private let textView: UITextView = {
        let textView = UITextView()
        textView.font = UIFont.systemFont(ofSize: 14)
        return textView
    }()
    
    private let containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()
    
    var selectedImage: UIImage? {
        didSet {
            photoThumbnailImageView.image = selectedImage
        }
    }
    
    private var isShareButtonEnabled: Bool! {
        didSet {
            navigationItem.rightBarButtonItem?.isEnabled = isShareButtonEnabled
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.rgb(r: 240, g: 240, b: 240)
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Share", style: .plain, target: self, action: #selector(handleSharePhoto))
        
        setupViews()
    }
    
    private func setupViews() {
        containerView.addSubview(photoThumbnailImageView)
        containerView.addSubview(textView)
        view.addSubview(containerView)
        
        containerView.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 100)
        photoThumbnailImageView.anchor(top: containerView.topAnchor, left: containerView.leftAnchor, bottom: containerView.bottomAnchor, right: nil, paddingTop: 8, paddingLeft: 8, paddingBottom: 8, paddingRight: 0, width: 84, height: 0)
        
        textView.anchor(top: containerView.topAnchor, left: photoThumbnailImageView.rightAnchor, bottom: containerView.bottomAnchor, right: containerView.rightAnchor, paddingTop: 0, paddingLeft: 8, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
    }
    
    override var prefersStatusBarHidden: Bool {
         return true
    }
    
    @objc private func handleSharePhoto() {
        // Disable button interaction
        isShareButtonEnabled = false
        
        // Upload the image to Firestore Image
        guard let image = selectedImage else { return }
        guard let uploadData = image.jpegData(compressionQuality: 0.5) else { return }
        let filename = UUID().uuidString
        
        let sharePostreference = Storage.storage().reference().child("posts").child(filename)
        sharePostreference.putData(uploadData, metadata: nil) { (metadata, error) in
            if let error = error {
                print("Failed to upload post image: \(error)")
                self.isShareButtonEnabled = true
                return
            }
            
            sharePostreference.downloadURL { (url, error) in
                guard let downloadURL = url else {
                    print("Uh-oh, an error occurred acquiring the download url")
                    return
                }
                
                self.saveToDatabaseWithImageURL(url: downloadURL.absoluteString)
                print("Successfully uploaded post image: \(downloadURL.absoluteString)")
            }
        }
    }
    
    private func saveToDatabaseWithImageURL(url: String) {
        // Post Image
        guard let postImage = selectedImage else { return }
        
        // Post Caption
        guard let caption = textView.text, caption.count > 0 else { return }
        
        guard let uid = Auth.auth().currentUser?.uid else { return }
        let userPostReference = Database.database().reference().child("posts").child(uid)
        
        let postReference = userPostReference.childByAutoId() // Creates a new child automatically
        
        let values = [
            "imageUrl": url,
            "caption": caption,
            "imageWidth": postImage.size.width,
            "imageHeight": postImage.size.height,
            "creationDate": Date().timeIntervalSince1970
        ] as [String: Any]
        
        postReference.updateChildValues(values) { (error, dbReference) in
            if let error = error {
                self.isShareButtonEnabled = true
                print("Failed to save post to DB: \(error)")
                return
            }
            
            print("Successfully uploaded post to DB")
            self.dismiss(animated: true, completion: nil)
            
            NotificationCenter.default.post(name: Notifications.updateFeedNotificationName, object: nil)
        }
    }
    
}

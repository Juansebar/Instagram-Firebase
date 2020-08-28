//
//  SharePhotoController.swift
//  Instagram Firebase
//
//  Created by Juan Ramirez on 8/19/20.
//  Copyright © 2020 Sebapps. All rights reserved.
//

import UIKit

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
        
    }
    
}

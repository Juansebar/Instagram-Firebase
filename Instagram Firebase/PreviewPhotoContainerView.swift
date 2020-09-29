//
//  PreviewPhotoContainerView.swift
//  Instagram Firebase
//
//  Created by Juan Ramirez on 9/29/20.
//  Copyright © 2020 Sebapps. All rights reserved.
//

import UIKit
import Photos

class PreviewPhotoContainerView: UIView {
    
    var image: UIImage? {
        get {
            return previewImageView.image
        }
        set {
            previewImageView.image = newValue
        }
    }
    
    private let previewImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    private let cancelButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: "cancel"), for: .normal)
        button.addTarget(self, action: #selector(dismiss), for: .touchUpInside)
        return button
    }()
    
    private let saveButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: "save"), for: .normal)
        button.addTarget(self, action: #selector(saveImage), for: .touchUpInside)
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .yellow
        
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        addSubview(previewImageView)
        addSubview(cancelButton)
        addSubview(saveButton)
    }
    
    private func setupConstraints() {
        previewImageView.anchor(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        
        cancelButton.anchor(top: topAnchor, left: leftAnchor, bottom: nil, right: nil, paddingTop: 12, paddingLeft: 12, paddingBottom: 0, paddingRight: 0, width: 50, height: 50)
        
        saveButton.anchor(top: nil, left: leftAnchor, bottom: bottomAnchor, right: nil, paddingTop: 0, paddingLeft: 12, paddingBottom: 12, paddingRight: 0, width: 50, height: 50)
    }
    
    @objc private func dismiss() {
        removeFromSuperview()
    }
    
    @objc private func saveImage() {
        let library = PHPhotoLibrary.shared()
        
        library.performChanges({
            guard let previewImage = self.image else { return }
            PHAssetChangeRequest.creationRequestForAsset(from: previewImage)
        }) { (success, error) in
            if let error = error {
                print("Failed to save image to photo library: \(error)")
                return
            }
            
            print("Successfully saved image to library")
        }
    }
    
}

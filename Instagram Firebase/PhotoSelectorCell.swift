//
//  PhotoSelectorCell.swift
//  Instagram Firebase
//
//  Created by Juan Ramirez on 8/18/20.
//  Copyright © 2020 Sebapps. All rights reserved.
//

import UIKit

class PhotoSelectorCell: UICollectionViewCell {
    
    static let cellId = "cellID"
    
    private let photoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    var image: UIImage? {
        didSet {
            guard let image = image else { return }
            
            photoImageView.image = image
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = UIColor.lightGray.withAlphaComponent(0.5)
        
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        addSubview(photoImageView)
        
        photoImageView.anchor(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor)
    }
    
    override func prepareForReuse() {
        photoImageView.image = nil
    }
    
}

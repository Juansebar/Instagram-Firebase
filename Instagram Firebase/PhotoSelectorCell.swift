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
    
    private let selectedBadgeView: UIView = {
        let view = UIView()
        view.backgroundColor = .green
        view.clipsToBounds = true
        view.isHidden = true
        return view
    }()
    
    var image: UIImage? {
        didSet {
            guard let image = image else { return }
            
            photoImageView.image = image
        }
    }
    
    var isImageSelected: Bool = false {
        didSet {
            selectedBadgeView.isHidden = !isImageSelected
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
        addSubview(selectedBadgeView)
        
        photoImageView.anchor(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor)
        selectedBadgeView.anchor(top: nil, left: nil, bottom: bottomAnchor, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 10, paddingRight: 10, width: 10, height: 10)
        selectedBadgeView.layer.cornerRadius = 5
    }
    
    override func prepareForReuse() {
        photoImageView.image = nil
        isImageSelected = false
    }
    
}

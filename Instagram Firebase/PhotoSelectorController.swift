//
//  PhotoSelectorController.swift
//  Instagram Firebase
//
//  Created by Juan Ramirez on 8/18/20.
//  Copyright © 2020 Sebapps. All rights reserved.
//

import UIKit
import Photos

class PhotoSelectorController: UICollectionViewController {

    private var photos = [UIImage]()
    private var assets = [PHAsset]()
    private var fetchedImages = [String: UIImage]()
    private var selectedImageIndex = 0
    private var selectedImageHighQuality: UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.backgroundColor = .white
        
        collectionView.register(PhotoSelectorHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: PhotoSelectorHeader.headerId)
        collectionView.register(PhotoSelectorCell.self, forCellWithReuseIdentifier: PhotoSelectorCell.cellId)
        
        navigationController?.navigationBar.backgroundColor = .white
        navigationController?.navigationBar.isTranslucent = false
        
        setupNavigationButtons()
        
        fetchPhotos()
    }
    
    private func setupNavigationButtons() {
        navigationController?.navigationBar.tintColor = .black
        navigationItem.rightBarButtonItem = .init(title: "Next", style: .plain, target: self, action: #selector(handleNextButtonTap))
    }
    
    private func assetFetchOptions() -> PHFetchOptions {
        let fetchOptions = PHFetchOptions()
        fetchOptions.fetchLimit = 30
        let sortDescriptor = NSSortDescriptor(key: "creationDate", ascending: false)
        fetchOptions.sortDescriptors = [sortDescriptor]
        
        return fetchOptions
    }
    
    private func fetchPhotos() {
        let fetchOptions = assetFetchOptions()
        let allPhotos = PHAsset.fetchAssets(with: .image, options: fetchOptions)
        DispatchQueue.global(qos: .background).async {
            allPhotos.enumerateObjects { (asset, count, stop) in
                // Access the assets with an ImageManager
                let imageManager = PHImageManager.default()
                let targetSize = CGSize(width: 200, height: 200)
                let options = PHImageRequestOptions()
                options.isSynchronous = true  // With this options it allows all the images to be resized to the targetSize ending up with better quality photos
                imageManager.requestImage(for: asset, targetSize: targetSize, contentMode: .aspectFit, options: options) { (image, info) in
                    if let image = image {
                        self.photos.append(image)
                        self.assets.append(asset)
                    }
                    
                    // Once you get the last image you are ready to reload data
                    if count == allPhotos.count - 1 {
                        DispatchQueue.main.async {
                            self.collectionView.reloadData()
                        }
                    }
                }
            }
        }
    }
    
    @objc private func handleNextButtonTap() {
        if let image = selectedImageHighQuality {
            let sharedPhotoController = SharePhotoController()
            sharedPhotoController.selectedImage = image
            navigationController?.pushViewController(sharedPhotoController, animated: true)
        } else {
            print("Need to select an image to share")
        }
    }
    
}

extension PhotoSelectorController: UICollectionViewDelegateFlowLayout {
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photos.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PhotoSelectorCell.cellId, for: indexPath) as? PhotoSelectorCell else { return UICollectionViewCell() }
        
        cell.prepareForReuse()
        cell.image = photos[indexPath.item]
        
        if selectedImageIndex == indexPath.item {
            cell.isImageSelected = true
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let measurement = (view.frame.width - 3) / 4
        return .init(width: measurement, height: measurement)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return .init(top: 1, left: 0, bottom: 0, right: 0)
    }
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: PhotoSelectorHeader.headerId, for: indexPath) as? PhotoSelectorHeader else { return UICollectionReusableView() }
        
        if photos.count > 0 && photos.count - 1 >= selectedImageIndex {
            // Check if you have previously fetched an image
            if let fetchedImage = fetchedImages["\(selectedImageIndex)"] {
                print("Image Already Fetched.")
                header.image = fetchedImage
            } else {
                print("Fetching Image....")
                let imageManager = PHImageManager()
                let targetSize = CGSize(width: 600, height: 600)
                let options = PHImageRequestOptions()
                options.isSynchronous = true
                
                let selectedAsset = assets[selectedImageIndex]
                
                imageManager.requestImage(for: selectedAsset, targetSize: targetSize, contentMode: .aspectFit, options: options) { (image, info) in
                    
                    self.fetchedImages["\(self.selectedImageIndex)"] = image
                    header.image = image
                    self.selectedImageHighQuality = image
                }
            }
        }
        
        return header
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return .init(width: view.frame.width, height: view.frame.width)
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedImageIndex = indexPath.item
        
        collectionView.reloadData()
        
        collectionView.scrollToItem(at: IndexPath(item: 0, section: 0), at: .bottom, animated: true)
    }
    
}

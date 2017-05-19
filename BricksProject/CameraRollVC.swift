//
//  CameraRollVC.swift
//  BricksProject
//
//  Created by Emil Gräs on 13/05/2017.
//  Copyright © 2017 Emil Gräs. All rights reserved.
//

import UIKit
import Photos

class CameraRollVC: UIViewController {

    // MARK: - Properties
    var delegate: ChooseBricksDelegate?
    fileprivate var images = [UIImage]()
    fileprivate var selectedImages = [Int:UIImage]()
    
    // MARK: - Constants
    fileprivate let cellLineSpacing: CGFloat = 1.0
    fileprivate let cellInterItemSpacing: CGFloat = 1.0
    fileprivate let numberOfColumns: Int = 3
    
    // MARK: - IB Outlets
    @IBOutlet weak var collectionView: UICollectionView!
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()
        fetchImages()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: - Helper Methods
    fileprivate func setupCollectionView() {
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(UINib(nibName: Storyboard.Identifier.imageCell, bundle: nil), forCellWithReuseIdentifier: Storyboard.Identifier.imageCell)
    }
    
    fileprivate func fetchImages() {
        let imgManager = PHImageManager.default()
        let requestOptions = PHImageRequestOptions()
        requestOptions.isSynchronous = true
        requestOptions.deliveryMode = .highQualityFormat
        let fetchOptions = PHFetchOptions()
        fetchOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
        let fetchResult: PHFetchResult = PHAsset.fetchAssets(with: .image, options: fetchOptions)
        if fetchResult.count > 0 {
            let targetSize = CGSize(width: 200, height: 200)
            for index in 0..<fetchResult.count {
                let asset = fetchResult.object(at: index)
                imgManager.requestImage(for: asset, targetSize: targetSize, contentMode: .aspectFit, options: requestOptions, resultHandler: { image, error in
                    if let image = image {
                        self.images.append(image)
                    }
                })
            }
        } else {
            // TODO: no images in photo library
        }
        collectionView.reloadData()
    }
}

// MARK: - Collection View DataSource
extension CameraRollVC: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Storyboard.Identifier.imageCell, for: indexPath) as! ImageCell
        selectedImages.keys.contains(indexPath.item) ? cell.mark(value: true) : cell.mark(value: false)
        cell.image = images[indexPath.item]
        return cell
    }
}

// MARK: - Collection View Delegate FlowLayout
extension CameraRollVC: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let screenWidth: CGFloat = UIScreen.main.bounds.width
        let spacing: CGFloat = cellLineSpacing
        let cellWidth = (screenWidth / CGFloat(numberOfColumns)) - (((CGFloat(numberOfColumns) - 1) * spacing) / CGFloat(numberOfColumns))
        return CGSize(width: cellWidth, height: cellWidth)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return cellLineSpacing
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return cellInterItemSpacing
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as! ImageCell
        if selectedImages.keys.contains(indexPath.item) {
            selectedImages.removeValue(forKey: indexPath.item)
        } else {
            selectedImages[indexPath.item] = cell.image!
        }
        collectionView.reloadItems(at: [indexPath])
        
        // convert from dictionary to list
        var images = [UIImage]()
        for image in selectedImages.values {
            images.append(image)
        }
        delegate?.selectedImages(images)
    }
}

//
//  InstagramPageVC.swift
//  EGPageViewController
//
//  Created by Emil Gräs on 08/05/2017.
//  Copyright © 2017 Emil Gräs. All rights reserved.
//

import UIKit

class InstagramVC: UIViewController {
    
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

}

// MARK: - Collection View DataSource
extension InstagramVC: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 33
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Storyboard.Identifier.imageCell, for: indexPath) as! ImageCell
        return cell
    }
}

// MARK: - Collection View Delegate FlowLayout
extension InstagramVC: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let screenWidth: CGFloat = UIScreen.main.bounds.width
        let spacing: CGFloat = cellLineSpacing
        let cellWidth = (screenWidth / CGFloat(numberOfColumns)) - (((CGFloat(numberOfColumns) - 1) * spacing) / CGFloat(numberOfColumns))
        return CGSize(width: cellWidth, height: cellWidth)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return cellInterItemSpacing
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 1.0
    }
}

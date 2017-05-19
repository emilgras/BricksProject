//
//  ImageCell.swift
//  EGPageViewController
//
//  Created by Emil Gräs on 09/05/2017.
//  Copyright © 2017 Emil Gräs. All rights reserved.
//

import UIKit

class ImageCell: UICollectionViewCell {
    
    fileprivate var markView: UIView?
    var image: UIImage? {
        didSet {
            if let image = image { imageView.image = image }
        }
    }
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var overlayView: UIView!
    @IBOutlet weak var markedView: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    func mark(value: Bool) {
        overlayView.isHidden = !value
        markedView.isHidden = !value
    }

}

//
//  ImageCropVC.swift
//  BricksProject
//
//  Created by Emil Gräs on 19/05/2017.
//  Copyright © 2017 Emil Gräs. All rights reserved.
//

import UIKit

class ImageCropVC: UIViewController {

    var image: UIImage?
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var imageViewEqualHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var imageViewEqualWidthConstraint: NSLayoutConstraint!
    
    @IBAction func cropButtonTapped(_ sender: Any) {
        let scale:CGFloat = 1/scrollView.zoomScale
        let x:CGFloat = scrollView.contentOffset.x * scale
        let y:CGFloat = scrollView.contentOffset.y * scale
        let width:CGFloat = scrollView.frame.size.width * scale
        let height:CGFloat = scrollView.frame.size.height * scale
        let croppedCGImage = imageView.image?.cgImage?.cropping(to: CGRect(x: x, y: y, width: width, height: height))
        let croppedImage = UIImage(cgImage: croppedCGImage!)
        setImageToCrop(image: croppedImage)
    }
    
    @IBAction func dismissTapped(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        scrollView.delegate = self
        setImageToCrop(image: image!)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: - Helper Methods
    func setImageToCrop(image:UIImage) {
        imageView.image = image
        imageViewEqualWidthConstraint.constant = image.size.width
        imageViewEqualHeightConstraint.constant = image.size.height
        let scaleHeight = scrollView.frame.size.width/image.size.width
        let scaleWidth = scrollView.frame.size.height/image.size.height
        scrollView.minimumZoomScale = max(scaleWidth, scaleHeight)
        scrollView.zoomScale = max(scaleWidth, scaleHeight)
    }
}

extension ImageCropVC: UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }
}

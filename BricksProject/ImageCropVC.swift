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
    
    @IBAction func cropButtonTapped(_ sender: Any) {
        let croppedImage = cropImage(image: image!)
        setCroppedImage(image: croppedImage)
    }
    
    @IBAction func dismissTapped(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupScrollView()
        addImage()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: - Helper Methods
    fileprivate func setupScrollView() {
        scrollView.delegate = self
        scrollView.minimumZoomScale = 1.0
        scrollView.maximumZoomScale = 2.0
        scrollView.zoomScale = 1.0
    }
    
    fileprivate func addImage() {
        guard let image = image else { return }
        imageView.image = image
    }
    
    fileprivate func cropImage(image: UIImage) -> UIImage {
        let scale:CGFloat = 1/scrollView.zoomScale
        print("scale: \(scale)")
        let x:CGFloat = scrollView.contentOffset.x * scale
        let y:CGFloat = scrollView.contentOffset.y * scale
        let width:CGFloat = scrollView.frame.size.width * scale
        let height:CGFloat = scrollView.frame.size.height * scale
        let croppedCGImage = imageView.image?.cgImage?.cropping(to: CGRect(x: x, y: y, width: width, height: height))
        return UIImage(cgImage: croppedCGImage!)
    }
    
    fileprivate func setCroppedImage(image:UIImage) {
        imageView.image = image
//        imageViewEqualWidthConstraint.constant = image.size.width
//        imageViewEqualHeightConstraint.constant = image.size.height

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
    
    func scrollViewDidEndZooming(_ scrollView: UIScrollView, with view: UIView?, atScale scale: CGFloat) {

    }
    
    func scrollViewDidZoom(_ scrollView: UIScrollView) {
        let scale = imageView.frame.height/scrollView.frame.height
        print(scale)
    }
}

//
//  ChooseBricksVC.swift
//  BricksProject
//
//  Created by Emil Gräs on 13/05/2017.
//  Copyright © 2017 Emil Gräs. All rights reserved.
//

import UIKit

protocol ChooseBricksDelegate {
    func selectedImages(_ images: [UIImage])
}

class ChooseBricksVC: UIViewController {

    enum MenuType {
        case cameraRoll
        case instagram
    }
    
    // MARK: - Properties
    fileprivate var order: Order!
    fileprivate var cameraRollVC: CameraRollVC!
    fileprivate var instagramVC: InstagramVC!
    fileprivate var currentMenu: MenuType = .cameraRoll
    fileprivate var tapGesture: UITapGestureRecognizer?
    
    // MARK: - IB Outlets
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var topMenuView: UIView!
    @IBOutlet weak var cameraRollMenuLabel: UILabel!
    @IBOutlet weak var instagramMenuLabel: UILabel!
    @IBOutlet weak var menuSelectedView: UIView!
    @IBOutlet weak var bottomMenuViewBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var bottomMenuViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var bottomMenuView: UIView!
    @IBOutlet weak var bottomMenuViewMessageLabel: UILabel!

    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.layoutIfNeeded()
        setupScrollView()
        setupTopMenuView()
        setupBottomMenuView()
        order = Order()
        
        
        /// MOVE THIS ///
        cameraRollVC = UIStoryboard(name: Storyboard.main, bundle: nil).instantiateViewController(withIdentifier: Storyboard.Identifier.cameraRollVC) as! CameraRollVC
        cameraRollVC.delegate = self
        let camView = cameraRollVC.view!
        addChildViewController(cameraRollVC)
        cameraRollVC.didMove(toParentViewController: self)
        contentView.addSubview(camView)
        camView.translatesAutoresizingMaskIntoConstraints = false
        camView.widthAnchor.constraint(equalToConstant: scrollView.frame.width).isActive = true
        camView.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        camView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
        camView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true

        
        instagramVC = UIStoryboard(name: Storyboard.main, bundle: nil).instantiateViewController(withIdentifier: Storyboard.Identifier.instagramVC) as! InstagramVC
        let instaView = instagramVC.view!
        addChildViewController(instagramVC)
        instagramVC.didMove(toParentViewController: self)
        contentView.addSubview(instaView)
        instaView.translatesAutoresizingMaskIntoConstraints = false
        instaView.widthAnchor.constraint(equalToConstant: scrollView.frame.width).isActive = true
        instaView.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        instaView.leadingAnchor.constraint(equalTo: camView.trailingAnchor).isActive = true
        instaView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
        /// MOVE THIS ///
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    // MARK: - Override Methods
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if  segue.identifier == Storyboard.Segue.chooseBricks_purchaseBricks,
            let orderVC = segue.destination as? OrderDetailsVC {
            orderVC.order = self.order
        }
    }
    
    // MARK: - Helper Methods
    fileprivate func setupScrollView() {
        scrollView.delegate = self
        scrollView.showsHorizontalScrollIndicator = false
    }
    
    fileprivate func setupTopMenuView() {
        topMenuView.roundCorners(corners: [.topLeft, .topRight], radius: 12)
        updateMenuView(withProgress: 0.0)
    }
    
    fileprivate func setupBottomMenuView() {
        bottomMenuView.clipsToBounds = false
        bottomMenuViewMessageLabel.isUserInteractionEnabled = true
        bottomMenuViewBottomConstraint.constant = -bottomMenuViewHeightConstraint.constant
        addShadow(toView: bottomMenuView, alpha: 0.5)
    }
    
    fileprivate func addShadow(toView view: UIView, alpha: CGFloat) {
        view.layer.shadowColor = UIColor(red: 48/255.0, green: 48/255.0, blue: 48/255.0, alpha: alpha).cgColor
        view.layer.shadowOpacity = 1
        view.layer.shadowOffset = CGSize(width: 0, height: 0)
        view.layer.shadowRadius = 20
    }
}

extension ChooseBricksVC: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let moved = scrollView.contentOffset.x
        let range = scrollView.frame.width
        let progress = moved / range
        updateMenuView(withProgress: progress)
    }
    
    fileprivate func updateMenuView(withProgress progress: CGFloat) {
        // updating view location
        let pointA = cameraRollMenuLabel.center.x
        let pointB = instagramMenuLabel.center.x
        let DistanceAB = pointB - pointA
        let centerX = (DistanceAB * progress) + pointA
        menuSelectedView.center.x = centerX
        
        // updating view width
        let lengthA = cameraRollMenuLabel.frame.width * 1.2
        let lengthB = instagramMenuLabel.frame.width * 1.2
        let differenceAB = lengthA - lengthB
        let length = max(min((lengthA - (differenceAB * progress)), lengthA), lengthB)
        menuSelectedView.frame.size.width = length
        
        // updating alpha values on labels
        let fromAlpha: CGFloat = 1.0
        let toAlpha: CGFloat = 0.2
        let differenceAlpha: CGFloat = fromAlpha - toAlpha
        let rightIncreasingValue = min(max(((differenceAlpha * progress) + toAlpha), toAlpha), fromAlpha)
        let leftIncreasingValue = min(max((fromAlpha - (differenceAlpha * progress)), toAlpha), fromAlpha)
        
        switch currentMenu {
        case .cameraRoll:
            let from = leftIncreasingValue
            let to = rightIncreasingValue
            cameraRollMenuLabel.alpha = from
            instagramMenuLabel.alpha = to
            break
        case .instagram:
            let from = rightIncreasingValue
            let to = leftIncreasingValue
            instagramMenuLabel.alpha = from
            cameraRollMenuLabel.alpha = to
            break
        }
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        currentMenu = Int(scrollView.contentOffset.x) == 0 ? .cameraRoll : .instagram
    }
}

extension ChooseBricksVC: ChooseBricksDelegate {
    func selectedImages(_ images: [UIImage]) {
        order.images = images
        order.hasImages() ? presentMenu() : dismissMenu()
        order.hasMinimumNumberOfImages { suffuciant, message in
            if suffuciant {
                bottomMenuViewMessageLabel.text = message
                tapGesture = UITapGestureRecognizer(target: self, action: #selector(ChooseBricksVC.menuTapped))
                bottomMenuViewMessageLabel.addGestureRecognizer(tapGesture!)
            } else {
                bottomMenuViewMessageLabel.text = message
                if tapGesture != nil { tapGesture = nil }
                if let gestures = bottomMenuViewMessageLabel.gestureRecognizers, gestures.count > 0 {
                    bottomMenuViewMessageLabel.gestureRecognizers?.removeAll()
                }
            }
        }
    }
    
    func menuTapped() {
        performSegue(withIdentifier: Storyboard.Segue.chooseBricks_purchaseBricks, sender: nil)
    }
    
    fileprivate func presentMenu() {
        bottomMenuViewBottomConstraint.constant = 0
        UIView.animate(withDuration: 0.3, delay: 0.0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.4, options: .curveEaseInOut, animations: {
            self.view.layoutIfNeeded()
        }, completion: nil)
    }
    
    fileprivate func dismissMenu() {
        bottomMenuViewBottomConstraint.constant = -bottomMenuViewHeightConstraint.constant
        UIView.animate(withDuration: 0.3, delay: 0.0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.4, options: .curveEaseInOut, animations: {
            self.view.layoutIfNeeded()
        }, completion: nil)
    }
}




















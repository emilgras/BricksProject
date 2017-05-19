//
//  ViewBricksVC.swift
//  BricksProject
//
//  Created by Emil Gräs on 16/05/2017.
//  Copyright © 2017 Emil Gräs. All rights reserved.
//

import UIKit

class ViewBricksVC: UIViewController {

    // MARK: - Properties
    var order: Order? { didSet {  } }
    fileprivate let customTransitionDelegate = TransitioningDelegate()
    fileprivate var interactionController: UIPercentDrivenInteractiveTransition?
    fileprivate let cellLineSpacing: CGFloat = 15.0
    fileprivate let cellWidth: CGFloat = UIScreen.main.bounds.height / 3
    fileprivate let collectionViewLeftRightPadding: CGFloat = 20
    
    // MARK: - IB Outlets
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var bottomMenuBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var bottomMenuViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var bottomMenuView: UIView!
    @IBOutlet weak var bottomMenuViewMessageLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    
    @IBAction func dismissTapped(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    // MARK: - Life Cycle
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        modalPresentationStyle = .custom
        transitioningDelegate = customTransitionDelegate
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.layoutIfNeeded()
        setupCollectionView()
        setupBottomMenuView()
        contentView.roundCorners(corners: [.topLeft, .topRight], radius: 12)
        view.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(ViewBricksVC.handlePan)))
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        priceLabel.text = order?.price()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        presentMenu()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        guard let identifier = segue.identifier else { return }
//        switch identifier {
//        case Storyboard.Segue.viewBricks_purchaseBricks:
//            guard let purchaseVC = segue.destination as? OrderDetailsVC else { return }
//            purchaseVC.order = order
//            break
//        default:
//            return
//        }
    }
    
    // MARK: - Helepr Methods
    fileprivate func setupCollectionView() {
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.contentInset = UIEdgeInsets(top: 0, left: collectionViewLeftRightPadding, bottom: 0, right: collectionViewLeftRightPadding)
        collectionView.register(UINib(nibName: Storyboard.Identifier.imageCell, bundle: nil), forCellWithReuseIdentifier: Storyboard.Identifier.imageCell)
    }
    
    
    fileprivate func setupBottomMenuView() {
        bottomMenuView.clipsToBounds = false
        bottomMenuViewMessageLabel.isUserInteractionEnabled = true
        bottomMenuBottomConstraint.constant = -bottomMenuViewHeightConstraint.constant
        bottomMenuView.layer.shadowColor = UIColor.black.cgColor
        bottomMenuView.layer.shadowOffset = CGSize(width: 0, height: 0)
        bottomMenuView.layer.shadowRadius = 10
        bottomMenuViewMessageLabel.text = "Videre til betaling"
        bottomMenuViewMessageLabel.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(ViewBricksVC.menuTapped)))
    }
    
    @objc fileprivate func handlePan(_ gesture: UIPanGestureRecognizer) {
        let translationY = gesture.translation(in: gesture.view).y
        let percent = max(translationY / gesture.view!.bounds.size.height, 0)
        
        if gesture.state == .began {
            interactionController = UIPercentDrivenInteractiveTransition()
            customTransitionDelegate.interactionController = interactionController
            dismiss(animated: true)
        } else if gesture.state == .changed {
            interactionController?.update(percent)
        } else if gesture.state == .ended {
            let velocity = gesture.velocity(in: gesture.view).y
            if (percent > 0.5 && velocity == 0) || (velocity > 100 && percent > 0.0) {
                interactionController?.finish()
            } else {
                interactionController?.cancel()
            }
            interactionController = nil
        }
    }
    
    func menuTapped() {
//        performSegue(withIdentifier: Storyboard.Segue.viewBricks_purchaseBricks, sender: nil)
    }
    
    fileprivate func presentMenu() {
        if bottomMenuBottomConstraint.constant != 0 {
            bottomMenuBottomConstraint.constant = 0
            UIView.animate(withDuration: 0.3, delay: 0.0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.4, options: .curveEaseInOut, animations: {
                self.view.layoutIfNeeded()
            }, completion: nil)
        }
    }
    
    fileprivate func addShadow(toView view: UIView, alpha: CGFloat) {
        view.layer.shadowColor = UIColor(red: 48/255.0, green: 48/255.0, blue: 48/255.0, alpha: alpha).cgColor
        view.layer.shadowOpacity = 1
        view.layer.shadowOffset = CGSize(width: -4, height: 4)
        view.layer.shadowRadius = 20
    }
    
    fileprivate func addCornerRadius(toView view: UIView, radius: CGFloat) {
        view.layer.cornerRadius = radius
    }
}

// MARK: - Collection View DataSource
extension ViewBricksVC: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return order!.images.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Storyboard.Identifier.imageCell, for: indexPath) as! ImageCell
        addShadow(toView: cell, alpha: 0.6)
        cell.image = order!.images[indexPath.item]
        return cell
    }
}

// MARK: - Collection View Delegate FlowLayout
extension ViewBricksVC: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: cellWidth, height: cellWidth)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return cellLineSpacing
    }
}

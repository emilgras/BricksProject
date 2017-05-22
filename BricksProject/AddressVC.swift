//
//  AddressVC.swift
//  BricksProject
//
//  Created by Emil Gräs on 14/05/2017.
//  Copyright © 2017 Emil Gräs. All rights reserved.
//

import UIKit

class AddressVC: UIViewController {
    
    // MARK: - Properties
    var address: Address?
    fileprivate let customTransitionDelegate = TransitioningDelegate()
    fileprivate var interactionController: UIPercentDrivenInteractiveTransition?
    fileprivate let textFieldPadding: CGFloat = 15.0
    fileprivate var keyboardIsPresenting = false
    fileprivate var addButtonIsPresenting = false
    fileprivate var keyboardSize: CGSize!
    
    // MARK: - Constants
    fileprivate let zipcodeLimit = 4
    
    // MARK: - IB Outlets
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var addressView: UIView!
    @IBOutlet weak var streetNameTextField: UITextField!
    @IBOutlet weak var streetNumberTextField: UITextField!
    @IBOutlet weak var floorTextField: UITextField!
    @IBOutlet weak var doorTextField: UITextField!
    @IBOutlet weak var zipCodeTextField: UITextField!
    @IBOutlet weak var cityTextField: UITextField!
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var addButtonBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var addButtonHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var dismissButton: UIButton!
    @IBOutlet weak var dismissButtonBottomConstraint: NSLayoutConstraint!
    
    @IBAction func addButtonTapped(_ sender: Any) {
        updateAddressObject()
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func dismissTapped(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func clearButtonTapped(_ sender: Any) {
        address?.clear()
        updateAddressFields()
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
        updateAddressFields()
        
        NotificationCenter.default.addObserver(self, selector: #selector(CreditCardVC.keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        
        addShadow(toView: addressView, alpha: 0.5)
        addCornerRadius(toView: addressView, radius: 8)
        
        // setup add button bottom constraint
        addButton.layer.cornerRadius = addButtonHeightConstraint.constant / 2
        addShadow(toView: addButton, alpha: 0.5)
        addButtonBottomConstraint.constant -= contentView.frame.height
        
        contentView.roundCorners(corners: [.topLeft, .topRight], radius: 12)
        
        streetNameTextField.delegate = self
        streetNumberTextField.delegate = self
        floorTextField.delegate = self
        doorTextField.delegate = self
        zipCodeTextField.delegate = self
        cityTextField.delegate = self
        
        streetNameTextField.addTarget(self, action: #selector(CreditCardVC.textFieldDidChange), for: UIControlEvents.editingChanged)
        streetNumberTextField.addTarget(self, action: #selector(CreditCardVC.textFieldDidChange), for: UIControlEvents.editingChanged)
        floorTextField.addTarget(self, action: #selector(CreditCardVC.textFieldDidChange), for: UIControlEvents.editingChanged)
        doorTextField.addTarget(self, action: #selector(CreditCardVC.textFieldDidChange), for: UIControlEvents.editingChanged)
        zipCodeTextField.addTarget(self, action: #selector(CreditCardVC.textFieldDidChange), for: UIControlEvents.editingChanged)
        cityTextField.addTarget(self, action: #selector(CreditCardVC.textFieldDidChange), for: UIControlEvents.editingChanged)
        
        streetNameTextField.paddingLeft(textFieldPadding)
        streetNumberTextField.paddingLeft(textFieldPadding)
        floorTextField.paddingLeft(textFieldPadding)
        doorTextField.paddingLeft(textFieldPadding)
        zipCodeTextField.paddingLeft(textFieldPadding)
        cityTextField.paddingLeft(textFieldPadding)

        view.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(AddressVC.handlePan)))
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        streetNameTextField.becomeFirstResponder()
        if validAddress() {
            presentAddButton()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        resignCurrentFirstResponder()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: - Helper Methods
    fileprivate func updateAddressFields() {
        streetNameTextField.text = address?.streetName
        streetNumberTextField.text = address?.streetNumber
        floorTextField.text = address?.floor
        doorTextField.text = address?.door
        zipCodeTextField.text = address?.zipCode
        cityTextField.text = address?.city
    }
    
    fileprivate func updateAddressObject() {
        address?.streetName = streetNameTextField.text
        address?.streetNumber = streetNumberTextField.text
        address?.floor = floorTextField.text
        address?.door = doorTextField.text
        address?.zipCode = zipCodeTextField.text
        address?.city = cityTextField.text
    }
    
    fileprivate func resignCurrentFirstResponder() {
        for responder in [
            streetNameTextField,
            streetNumberTextField,
            floorTextField,
            doorTextField,
            zipCodeTextField,
            cityTextField
            ] {
                if responder!.isFirstResponder {
                    responder?.resignFirstResponder()
                    return
                }
        }
    }
    
    fileprivate func presentAddButton() {
        addButton.isUserInteractionEnabled = true
        addButtonBottomConstraint.constant = 20
        UIView.animate(withDuration: 0.4, delay: 0.0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.3, options: .curveEaseInOut, animations: {
            self.view.layoutIfNeeded()
        }, completion: { finished in
            self.addButtonIsPresenting = true
        })
    }
    
    fileprivate func dismissAddButton() {
        addButton.isUserInteractionEnabled = false
        addButtonBottomConstraint.constant -= contentView.frame.height
        UIView.animate(withDuration: 0.5, delay: 0.0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.3, options: .curveEaseInOut, animations: {
            self.view.layoutIfNeeded()
        }, completion: { finsihed in
            self.addButtonIsPresenting = false
        })
    }
    
    // TODO: make as CALayer extension
    fileprivate func addShadow(toView view: UIView, alpha: CGFloat) {
        view.layer.shadowColor = UIColor(red: 48/255.0, green: 48/255.0, blue: 48/255.0, alpha: alpha).cgColor
        view.layer.shadowOpacity = 1
        view.layer.shadowOffset = CGSize(width: -4, height: 4)
        view.layer.shadowRadius = 20
    }
    
    fileprivate func addCornerRadius(toView view: UIView, radius: CGFloat) {
        view.layer.cornerRadius = radius
    }

    func handlePan(_ gesture: UIPanGestureRecognizer) {
        //dismiss(animated: true, completion: nil)
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
    
    // MARK: - Keyboard Observer Methods
    func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            self.keyboardSize = keyboardSize.size
            if !keyboardIsPresenting {
                dismissButtonBottomConstraint.constant += keyboardSize.height
                UIView.animate(withDuration: 0.3, delay: 0.0, options: .curveEaseInOut, animations: {
                    self.view.layoutIfNeeded()
                }, completion: { finished in
                    self.keyboardIsPresenting = true
                })
            }
        }
        
    }
    
    // MARK: - TextField Observer Methods
    func textFieldDidChange(textField: UITextField) {
        // handle valid input
        let validInput = validAddress()
        if  validInput && !addButtonIsPresenting {
            presentAddButton()
        } else if !validInput && addButtonIsPresenting {
            dismissAddButton()
        }
        
        // handle zipcode
        guard let textLength = textField.text?.characters.count else { return }
        switch textField.tag {
        case 4: // zipcode
            if textLength == zipcodeLimit { cityTextField.becomeFirstResponder() }
            break
        default: break
        }
    }
    
    fileprivate func validAddress() -> Bool {
        guard
        let streetName = streetNameTextField.text,
        let streetNumber = streetNumberTextField.text,
        let zipcode = zipCodeTextField.text,
        let city = cityTextField.text
        else { return false }
        return
            !streetName.isEmpty
            && !streetNumber.isEmpty
            && zipcode.characters.count == 4
            && !city.isEmpty
    }
}

extension AddressVC: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        let textFields = [
            streetNameTextField,
            streetNumberTextField,
            floorTextField,
            doorTextField,
            zipCodeTextField,
            cityTextField
        ]
        let tag = textField.tag
        var nextTag = 0
        if tag < textFields.count - 1 {
            nextTag = tag + 1
        }
        for responder in textFields {
            if responder!.tag == nextTag {
                responder?.becomeFirstResponder()
                return true
            }
        }
        return false
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        // handle zipcode
        guard var text = textField.text else { return false }
        let newLength = text.characters.count + string.characters.count - range.length
        switch textField.tag {
        case 2: // floor
            return string.isIntValue || string.isEmpty
        case 4: // zipcode
            return (newLength <= zipcodeLimit && string.isIntValue) || string.isEmpty
        default: return true
        }
    }
}








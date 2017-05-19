//
//  CreditCardVC.swift
//  BricksProject
//
//  Created by Emil Gräs on 14/05/2017.
//  Copyright © 2017 Emil Gräs. All rights reserved.
//

import UIKit

class CreditCardVC: UIViewController {

    // MARK: - Properties
    var creditCard: CreditCard?
    fileprivate var cardNumber = String()
    fileprivate var validUntill = String()
    fileprivate var cvv = String()
    fileprivate let customTransitionDelegate = TransitioningDelegate()
    fileprivate var interactionController: UIPercentDrivenInteractiveTransition?
    fileprivate var keyboardIsPresenting = false
    fileprivate var addButtonIsPresenting = false
    fileprivate var keyboardSize: CGSize!
    
    // MARK: - Constants
    fileprivate let cardNumberLimit = 16
    fileprivate let cardNumberSpacing = 6
    fileprivate let validUntillLimit = 4
    fileprivate let validUntillSpacing = 5
    fileprivate let cvvLimit = 3
   
    // MARK: - IB Outlets
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var creditCardView: UIView!
    @IBOutlet weak var cardNumberTextField: UITextField!
    @IBOutlet weak var cardValidUntillTextField: UITextField!
    @IBOutlet weak var cvvTextField: UITextField!
    @IBOutlet weak var dismissButtonBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var addButtonBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var addButtonHeightConstraint: NSLayoutConstraint!
    
    // MARK: - IB Actions
    @IBAction func addButtonTapped(_ sender: Any) {
        updateCreditCardObject()
        dismiss(animated: true, completion: nil)
    }
    
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

        updateCreditCardFields()
        NotificationCenter.default.addObserver(self, selector: #selector(CreditCardVC.keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        
        // setup add button bottom constraint
        addButton.layer.cornerRadius = addButtonHeightConstraint.constant / 2
        addShadow(toView: addButton, alpha: 0.5)
        addButtonBottomConstraint.constant -= contentView.frame.height
        
        cardNumberTextField.delegate = self
        cardValidUntillTextField.delegate = self
        cvvTextField.delegate = self
        
        cardNumberTextField.addTarget(self, action: #selector(CreditCardVC.textFieldDidChange), for: UIControlEvents.editingChanged)
        cardValidUntillTextField.addTarget(self, action: #selector(CreditCardVC.textFieldDidChange), for: UIControlEvents.editingChanged)
        cvvTextField.addTarget(self, action: #selector(CreditCardVC.textFieldDidChange), for: UIControlEvents.editingChanged)
        
        contentView.roundCorners(corners: [.topLeft, .topRight], radius: 12)
        addShadow(toView: creditCardView, alpha: 0.6)
        addCornerRadius(toView: creditCardView, radius: 8)
        view.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(AddressVC.handlePan)))
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        cardNumberTextField.becomeFirstResponder()
        if validCardInformation() {
            presentAddButton()
        }
        creditCard?.clear()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        resignCurrentFirstResponder()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: - Helper Methods
    fileprivate func updateCreditCardFields() {
        guard let creditCard = creditCard else {  return }
        cardNumberTextField.text = creditCard.cardNumberWithFormat()
        cardValidUntillTextField.text = creditCard.validUntillWithFormat()
        cvvTextField.text = creditCard.cvv
        cardNumber = creditCard.cardNumber != nil ? creditCard.cardNumber! : ""
        validUntill = creditCard.validUntill != nil ? creditCard.validUntill! : ""
        cvv = creditCard.cvv != nil ? creditCard.cvv! : ""
    }
    
    fileprivate func updateCreditCardObject() {
        creditCard?.cardNumber = self.cardNumber
        creditCard?.validUntill = self.validUntill
        creditCard?.cvv = self.cvv
    }
    
    fileprivate func resignCurrentFirstResponder() {
        for responder in [cardNumberTextField, cardValidUntillTextField, cvvTextField] {
            if responder!.isFirstResponder {
                responder?.resignFirstResponder()
                return
            }
        }
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
    
    fileprivate func validCardInformation() -> Bool {
        let expectedCardNumberDigits = cardNumberLimit + cardNumberSpacing
        let expectedValidUntillDigits = validUntillLimit + validUntillSpacing
        let expectedCvvDigits = cvvLimit
        let actualCardNumberDigits = cardNumberTextField.text!.characters.count
        let actualValidUntillDigits = cardValidUntillTextField.text!.characters.count
        let actualCvvDigits = cvvTextField.text!.characters.count
        return (actualCardNumberDigits == expectedCardNumberDigits && actualValidUntillDigits == expectedValidUntillDigits && actualCvvDigits == expectedCvvDigits)
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
        let validInput = validCardInformation()
        if  validInput && !addButtonIsPresenting {
            presentAddButton()
        } else if !validInput && addButtonIsPresenting {
            dismissAddButton()
        }
        
        guard let textLength = textField.text?.characters.count else { return }
        switch textField.tag {
        case 0:
            if textLength == cardNumberLimit + cardNumberSpacing { cardValidUntillTextField.becomeFirstResponder() }
            break
        case 1:
            if textLength == validUntillLimit + validUntillSpacing { cvvTextField.becomeFirstResponder() }
            break
        default: break
        }
    }
}

extension CreditCardVC: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        guard var text = textField.text else { return false }
        let newLength = text.characters.count + string.characters.count - range.length
        switch textField.tag {
        case 0:
        
            // get final card number
            if !string.isEmpty {
                cardNumber += string
            } else {
                let newEndIndex = cardNumber.index(cardNumber.endIndex, offsetBy: -1)
                cardNumber = cardNumber.substring(to: newEndIndex)
            }

            if (newLength == 5 || newLength == 10+1 || newLength == 15+2) && !string.isEmpty {
                cardNumberTextField.text = text + "  "
            } else if (newLength == 5 || newLength == 10+1 || newLength == 15+2 || newLength == 20+3) && string.isEmpty {
                let newEndIndex = cardNumberTextField.text!.index(cardNumberTextField.text!.endIndex, offsetBy: -2)
                let newText = cardNumberTextField.text!.substring(to: newEndIndex)
                cardNumberTextField.text = newText
            }
            return newLength <= (cardNumberLimit + cardNumberSpacing)
        case 1:
            
            // get final valid untill
            if !string.isEmpty {
                validUntill += string
            } else {
                let newEndIndex = validUntill.index(validUntill.endIndex, offsetBy: -1)
                validUntill = validUntill.substring(to: newEndIndex)
            }
            
            if newLength == 3 && !string.isEmpty {
                cardValidUntillTextField.text = text + "  /  "
            } else if newLength == 6 && string.isEmpty {
                let newEndIndex = cardValidUntillTextField.text!.index(cardValidUntillTextField.text!.endIndex, offsetBy: -5)
                let newText = cardValidUntillTextField.text!.substring(to: newEndIndex)
                cardValidUntillTextField.text = newText
            }
            return newLength <= (validUntillLimit + validUntillSpacing)
        case 2:
//            if cvv.characters.count >= cvvLimit { return false }
            // get final cvv
            if !string.isEmpty && cvv.characters.count < cvvLimit {
                cvv += string
            } else if string.isEmpty {
                let newEndIndex = cvv.index(cvv.endIndex, offsetBy: -1)
                cvv = cvv.substring(to: newEndIndex)
            }
            return newLength <= cvvLimit
        default: return false
        }
    }
}




















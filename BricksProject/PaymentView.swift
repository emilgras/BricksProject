//
//  PaymentView.swift
//  BricksProject
//
//  Created by Emil Gräs on 21/05/2017.
//  Copyright © 2017 Emil Gräs. All rights reserved.
//

import UIKit

@objc enum PaymentViewTextFieldType: Int {
    case cardNumber
    case validUntill
    case cvv
}

@objc protocol PaymentViewDelegate: class {
    func paymentViewCardNumberTextField(_ paymentView: PaymentView) -> PaymentViewTextField
    func paymentViewValidUntillTextField(_ paymentView: PaymentView) -> PaymentViewTextField
    func paymentViewCvvTextField(_ paymentView: PaymentView) -> PaymentViewTextField
    
    @objc optional func paymentView(_ paymentView: PaymentView, textFieldOfType type: PaymentViewTextFieldType, didChangeWithValue: String)
    @objc optional func paymentView(_ paymentView: PaymentView, textFieldOfType type: PaymentViewTextFieldType, willResignWithValue: String)
}

//@objc protocol PaymentViewDelegate: class {
//    
//}

class PaymentView: UIView {
    weak var delegate: PaymentViewDelegate? { didSet { initDataSource() }}
    
    var cardNumberTextField: PaymentViewTextField!
    var validUntillTextField: PaymentViewTextField!
    var cvvTextField: PaymentViewTextField!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    fileprivate func commonInit() {

    }
    
    fileprivate func initDataSource() {
        cardNumberTextField = delegate?.paymentViewCardNumberTextField(self)
        validUntillTextField = delegate?.paymentViewValidUntillTextField(self)
        cvvTextField = delegate?.paymentViewCvvTextField(self)
        cardNumberTextField.delegate = self as UITextFieldDelegate
        validUntillTextField.delegate = self as UITextFieldDelegate
        cvvTextField.delegate = self as UITextFieldDelegate
    }
}

extension PaymentView: UITextFieldDelegate {
    
}

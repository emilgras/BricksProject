//
//  PaymentViewCardNumberField.swift
//  BricksProject
//
//  Created by Emil Gräs on 21/05/2017.
//  Copyright © 2017 Emil Gräs. All rights reserved.
//

import UIKit

class PaymentViewCardNumberField: UITextField, UITextFieldDelegate {
    var cardNumber: String?
    
//    internal func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
//        guard var text = textField.text else { return false }
//        let newLength = text.characters.count + string.characters.count - range.length
//        if !string.isEmpty {
//            cardNumber += string
//        } else {
//            let newEndIndex = cardNumber.index(cardNumber.endIndex, offsetBy: -1)
//            cardNumber = cardNumber.substring(to: newEndIndex)
//        }
//        
//        if (newLength == 5 || newLength == 10+1 || newLength == 15+2) && !string.isEmpty {
//            cardNumberTextField.text = text + "  "
//        } else if (newLength == 5 || newLength == 10+1 || newLength == 15+2 || newLength == 20+3) && string.isEmpty {
//            let newEndIndex = cardNumberTextField.text!.index(cardNumberTextField.text!.endIndex, offsetBy: -2)
//            let newText = cardNumberTextField.text!.substring(to: newEndIndex)
//            cardNumberTextField.text = newText
//        }
//        return newLength <= (cardNumberLimit + cardNumberSpacing)
//    }
}

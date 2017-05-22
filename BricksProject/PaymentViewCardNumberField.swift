//
//  PaymentViewCardNumberField.swift
//  BricksProject
//
//  Created by Emil Gräs on 21/05/2017.
//  Copyright © 2017 Emil Gräs. All rights reserved.
//

import UIKit

class PaymentViewCardNumberField: UITextField, UITextFieldDelegate {
    var value: String = String()
    fileprivate let limit: Int = 8
    fileprivate let groupSize: Int = 4
    fileprivate let spacingSize: Int = 2
    fileprivate let delimitter = "  "
    
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

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard var text = textField.text else { return false }
        let newLength = text.characters.count + string.characters.count - range.length
        let addingValue = !string.isEmpty
        
        if addingValue {
            value += string
        } else {
            let newEndIndex = value.index(value.endIndex, offsetBy: -1)
            value = value.substring(to: newEndIndex)
        }
        
        if (newLength == groupSize + 1 || newLength == (2 * groupSize) + spacingSize + 1 || newLength == (3 * groupSize) + (2 * spacingSize) + 1) && addingValue {
            text = text + delimitter
        } else if (newLength == groupSize + 1 || newLength == (2 * groupSize) + spacingSize + 1 || newLength == (3 * groupSize) + (2 * spacingSize) + 1) && !addingValue {
            let newEndIndex = text.index(text.endIndex, offsetBy: -delimitter.characters.count)
            let newText = text.substring(to: newEndIndex)
            text = newText
        }
        return value.characters.count <= limit
    } 
}

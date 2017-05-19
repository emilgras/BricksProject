//
//  Order.swift
//  BricksProject
//
//  Created by Emil Gräs on 14/05/2017.
//  Copyright © 2017 Emil Gräs. All rights reserved.
//

import UIKit

class Order {
    var images = [UIImage]()
    var address = Address()
    var creditCard = CreditCard()
    
    func hasImages() -> Bool {
        return images.count > 0 ? true : false
    }
    
    func hasMinimumNumberOfImages(completion: (_ sufficiant: Bool, _ message: String) -> Void) {
        var sufficiant = false
        var message = ""
        
        if images.count > 0 {
            if images.count < 3 {
                sufficiant = false
                message = "Vælg minimum \(3 - images.count) mere"
            } else {
                sufficiant = true
                message = "\(images.count) valgt - Se din ordre her"
            }
        }
        completion(sufficiant, message)
    }
    
    func price() -> String {
        let minimumNumberOfImages = 3
        let extraChargePerImage = 30
        let basePrice = 349
        
        var currentPrice = 0
        if images.count >= minimumNumberOfImages {
            currentPrice = basePrice
            currentPrice += (images.count - minimumNumberOfImages) * extraChargePerImage
        }
        return "\(currentPrice) kr"
    }
}

class Address {
    var streetName: String?
    var streetNumber: String?
    var floor: String?
    var door: String?
    var zipCode: String?
    var city: String?
    
    func isValid() -> Bool {
        return streetName != nil
        && streetNumber != nil
        && floor != nil
        && door != nil
        && zipCode != nil
        && city != nil
    }
    
    func clear() {
        streetName = nil
        streetNumber = nil
        floor = nil
        door = nil
        zipCode = nil
        city = nil
    }
}

class CreditCard {
    var cardNumber: String?
    var validUntill: String?
    var cvv: String?
    
    func isValid() -> Bool {
        return cardNumber != nil && validUntill != nil && cvv != nil
    }
    
    func clear() {
        cardNumber = nil
        validUntill = nil
        cvv = nil
    }
    
    func cardNumberWithFormat() -> String {
        var formatted = ""
        if let cardNumber = cardNumber {
            for (index, char) in String(describing: cardNumber).characters.enumerated() {
                if index != 0 && index % 4 == 0 {
                    formatted += "  "
                }
                formatted += "\(char)"
            }
        }
        return formatted
    }
    
    func validUntillWithFormat() -> String {
        var formatted = ""
        if let validUntill = validUntill {
            for (index, char) in String(describing: validUntill).characters.enumerated() {
                if index != 0 && index % 2 == 0 {
                    formatted += "  /  "
                }
                formatted += "\(char)"
            }
        }
        return formatted
    }
}

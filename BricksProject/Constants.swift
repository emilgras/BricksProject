//
//  Constants.swift
//  BricksProject
//
//  Created by Emil Gräs on 13/05/2017.
//  Copyright © 2017 Emil Gräs. All rights reserved.
//

import Foundation

struct Storyboard {

    static let main = "Main"
    
    struct Identifier {
        static let imageCell = "ImageCell"
        static let contentMenuCell = "ContentMenuCell"
        static let headerMenuCell = "HeaderMenuCell"
        static let cameraRollVC = "CameraRollVC"
        static let instagramVC = "InstagramVC"
    }

    struct Segue {
        //static let chooseBricks_orderDetails = "ChooseBricks-OrderDetails"
        static let chooseBricks_purchaseBricks = "ChooseBricks-PurchaseBricks"
//        static let viewBricks_purchaseBricks = "ViewBricks-PurchaseBricks"
        static let orderDetails_address = "OrderDetails-Address"
        static let orderDetails_creditCard = "OrderDetails-CreditCard"
    }
    
}

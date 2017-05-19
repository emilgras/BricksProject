//
//  Extensions.swift
//  BricksProject
//
//  Created by Emil Gräs on 13/05/2017.
//  Copyright © 2017 Emil Gräs. All rights reserved.
//

import UIKit

extension UIView {
    func roundCorners(corners:UIRectCorner, radius: CGFloat) {
        let rect = CGRect(x: self.bounds.origin.x, y: self.bounds.origin.y, width: self.frame.width, height: self.frame.height)
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        self.layer.mask = mask
    }
}

extension UITextField {
    func paddingLeft(_ padding: CGFloat) {
        let paddingView = UIView(frame: CGRect(x: self.frame.origin.x, y: self.frame.origin.y, width: padding, height: self.frame.height))
        paddingView.backgroundColor = UIColor.clear
        self.leftView = paddingView
        self.leftViewMode = UITextFieldViewMode.always
    }
}

extension String {
    struct NumberFormat {
        static let instance = NumberFormatter()
    }
    var isIntValue:Bool {
        return ((NumberFormat.instance.number(from: self)?.intValue) != nil)
    }
}

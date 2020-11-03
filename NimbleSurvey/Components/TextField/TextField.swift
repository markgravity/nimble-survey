//
//  UITextField.swift
//  NimbleSurvey
//
//  Created by Mark G on 29/10/2020.
//

import UIKit

class TextField: UITextField {
    @IBInspectable var horizontalMargin : CGPoint = CGPoint.init(x: 0, y: 0)
    @IBInspectable var placeholderTextColor : UIColor = .black
    
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return CGRect.init(x: bounds.origin.x + horizontalMargin.x, y: bounds.origin.y, width: bounds.width-(horizontalMargin.y+horizontalMargin.x), height: bounds.height)
    }
    
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return CGRect.init(x: bounds.origin.x + horizontalMargin.x, y: bounds.origin.y, width: bounds.width-(horizontalMargin.y+horizontalMargin.x), height: bounds.height)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        let attributes = [
            NSAttributedString.Key.foregroundColor : placeholderTextColor,
            NSAttributedString.Key.font : font!
        ]
        
        attributedPlaceholder = NSAttributedString(string: placeholder ?? "", attributes:attributes)
    }

}

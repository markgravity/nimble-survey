//
//  GradientsView.swift
//  Moco360
//
//  Created by Mark G on 5/27/20.
//  Copyright © 2020 Mobiclix. All rights reserved.
//

#if os(iOS) && !IS_EXTENSION
import Gradients
import UIColor_Hex_Swift

//@IBDesignable
public class LinearGradientView: UIView {
    fileprivate var _gradientLayer: CALayer?
    
    @IBInspectable var degree: CGFloat = 0
    @IBInspectable var colors: String?
    @IBInspectable var locations: String?
    
    open override func layoutSubviews() {
        super.layoutSubviews()
        style()
    }
    
    open func style() {
        _gradientLayer?.removeFromSuperlayer()
        
        // Convert params
        guard
            let colorsString = self.colors,
            let locationsString = self.locations
        else { return }
        
        let colors: [CGColor] = colorsString
            .split(separator: ",")
            .map {
                UIColor(String($0)).cgColor
            }
        let locations: [NSNumber] = locationsString
            .split(separator: ",")
            .map {
                NSNumber(value: Double($0)!)
            }
        
        // Make gradient layer
        let gradientLayer = Gradients.linear(
            to: .degree(degree),
            colors: colors,
            locations: locations
        )
        
        // Add to current layer
        layer.insertSublayer(gradientLayer, at: 0)
        gradientLayer.frame = bounds
        gradientLayer.cornerRadius = cornerRadius
        
        _gradientLayer = gradientLayer
    }
    
    open override func prepareForInterfaceBuilder() {
        style()
    }
}
#endif

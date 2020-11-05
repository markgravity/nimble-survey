//
//  ContainerComponent.swift
//  SwiftyComponent
//
//  Created by Mark G on 3/21/20.
//

#if os(iOS)
import UIKit

open class ContainerComponent: View {
    
    // Rotation
    @IBInspectable
    open var rotationDegree: CGFloat = 0 {
        didSet {
            #if os(iOS)
            transform = CGAffineTransform(rotationAngle: rotationDegree * .pi / 180)
            #endif
        }
    }
    
    
    // Gradient
    private var gradientLayer: CAGradientLayer?
    
    @IBInspectable
    open var beginColor: UIColor? = nil
    
    @IBInspectable
    open var endColor: UIColor? = nil
    
    @IBInspectable
    open var beginPoint: CGPoint = .zero
    
    @IBInspectable
    open var endPoint: CGPoint = .zero
    
    open override func draw(_ rect: CGRect) {
        super.draw(rect)
        _configureGradient()
    }
    
    fileprivate func _configureGradient() {
        guard let beginColor = beginColor, let endColor = endColor else { return }
        let layer: CALayer? = self.layer
        
        gradientLayer?.removeFromSuperlayer()
        gradientLayer = CAGradientLayer()
        gradientLayer?.frame = layer?.bounds ?? .zero
        gradientLayer?.colors = [beginColor.cgColor, endColor.cgColor]
        gradientLayer?.startPoint = beginPoint
        gradientLayer?.endPoint = endPoint
        gradientLayer?.cornerRadius = layer?.cornerRadius ?? 0
        layer?.insertSublayer(gradientLayer!, at: 0)
    }
    
    open override func prepareForInterfaceBuilder() {
        _configureGradient()
    }
}
#endif

//
//  UIView+Exts.swift
//  tinhte-unofficial-swift
//
//  Created by Mark G on 1/23/18.
//  Copyright © 2018 Mark G. All rights reserved.
//

#if os(iOS)
import UIKit
import PureLayout


public extension UIView {
    enum LoadingIndicatorPosition {
        case center, centerLeft, centerRight
    }
    
    var className : String {
        return String(NSStringFromClass(type(of: self)).split(separator: ".").last!)
    }
    
    @IBInspectable var cornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        
        set {
            layer.roundCorners(radius: newValue)
        }
    }
    
    @IBInspectable var shadowRadius: CGFloat {
        get {
            return layer.shadowRadius
        }
        
        set {
            layer.shadowRadius = newValue
            layer.addShadow()
        }
    }
    
    @IBInspectable var shadowBlur: CGFloat {
        get {
            return layer.shadowRadius
        }
        
        set {
            layer.shadowRadius = newValue / 2
            layer.addShadow()
        }
    }
    
//    @IBInspectable var shadowSpread: CGFloat {
//        get {
//            return layer.shadowRadius
//        }
//        
//        set {
//            layer.shadowRadius = newValue / 2
//            layer.addShadow()
//        }
//    }
    
    @IBInspectable var shadowOpacity: Float {
        get {
            return layer.shadowOpacity
        }
        
        set {
            layer.shadowOpacity = newValue
            layer.addShadow()
        }
    }
    @IBInspectable var shadowColor: UIColor? {
        get {
            return layer.shadowColor != nil ? UIColor(cgColor: layer.shadowColor!) : nil
        }
        
        set {
            layer.shadowColor = newValue?.cgColor
            layer.addShadow()
        }
    }
    @IBInspectable var shadowOffset: CGSize {
        get {
            return layer.shadowOffset
        }
        
        set {
            layer.shadowOffset = newValue
            layer.addShadow()
        }
    }
    @IBInspectable var zPosition: CGFloat {
        get {
            return layer.zPosition
        }
        
        set {
            layer.zPosition = newValue
        }
    }
    
    @IBInspectable var borderColor: UIColor? {
        get {
            return layer.borderColor != nil ? UIColor(cgColor: layer.borderColor!) : nil
        }
        
        set {
            layer.borderColor = newValue?.cgColor
        }
    }
    
    @IBInspectable var borderWidth: CGFloat {
        get {
            return layer.borderWidth
        }
        
        set {
            layer.borderWidth = newValue
        }
    }
    
    func removeDashedBorder(_ view: UIView) {
        view.layer.sublayers?.forEach {
            if "kShapeDashed" == $0.name {
                $0.removeFromSuperlayer()
            }
        }
    }
    
    func addDashedBorder(width: CGFloat? = nil, height: CGFloat? = nil, lineWidth: CGFloat = 2, lineDashPattern:[NSNumber]? = [6,3], strokeColor: UIColor = UIColor.red, fillColor: UIColor = UIColor.clear) {
        
        
        var fWidth: CGFloat? = width
        var fHeight: CGFloat? = height
        
        if fWidth == nil {
            fWidth = self.frame.width
        }
        
        if fHeight == nil {
            fHeight = self.frame.height
        }
        
        let shapeLayer:CAShapeLayer = CAShapeLayer()
        
        let shapeRect = CGRect(x: 0, y: 0, width: fWidth!, height: fHeight!)
        
        shapeLayer.bounds = shapeRect
        shapeLayer.position = CGPoint(x: fWidth!/2, y: fHeight!/2)
        shapeLayer.fillColor = fillColor.cgColor
        shapeLayer.strokeColor = strokeColor.cgColor
        shapeLayer.lineWidth = lineWidth
        shapeLayer.lineJoin = CAShapeLayerLineJoin.round
        shapeLayer.lineDashPattern = lineDashPattern
        shapeLayer.name = "kShapeDashed"
        shapeLayer.path = UIBezierPath(roundedRect: shapeRect, cornerRadius: 5).cgPath
        
        self.layer.addSublayer(shapeLayer)
    }
    
    func isClosest(view:UIView)-> Bool{
        if view == self {
            return true
        } else if let superview = self.superview{
            return superview.isClosest(view: view)
        } else {
            return false
        }
    }
    
    func showLoadingIndicator(
        style:UIActivityIndicatorView.Style = .gray,
        color: UIColor = .gray,
        position : LoadingIndicatorPosition = .center,
        offset:CGPoint = CGPoint(x: 0, y: 0)){
        let loadingView = UIActivityIndicatorView(style: style)
        loadingView.tag = 20795
        loadingView.startAnimating()
        loadingView.translatesAutoresizingMaskIntoConstraints = false
        loadingView.color = color
        
        addSubview(loadingView)
        
        switch position {
        case .center:
            loadingView.autoCenterInSuperview()
            let constraints = self.constraints
            for constraint in constraints{
                if constraint.firstAttribute == .centerY {
                    constraint.constant = offset.y
                } else if constraint.firstAttribute == .centerX {
                    constraint.constant = offset.x
                }
            }
            
        case .centerLeft:
            
            let constraints = [
                NSLayoutConstraint.init(item: loadingView, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1, constant: offset.y),
                NSLayoutConstraint.init(item: loadingView, attribute: .leading, relatedBy: .equal, toItem: self, attribute: .leading, multiplier: 1, constant: offset.x)
            ]
            
            NSLayoutConstraint.activate(constraints)
            
        case .centerRight:
            
            let constraints = [
                NSLayoutConstraint.init(item: loadingView, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1, constant: offset.y),
                NSLayoutConstraint.init(item: loadingView, attribute: .trailing, relatedBy: .equal, toItem: self, attribute: .trailing, multiplier: 1, constant: offset.x)
            ]
            
            NSLayoutConstraint.activate(constraints)
        }
        
        
        
    }
    
    func dismissLoadingIndicator(){
        for subview in subviews{
            if subview is UIActivityIndicatorView
                && subview.tag == 20795 {
                let loadingView = subview as! UIActivityIndicatorView
                loadingView.stopAnimating()
                loadingView.removeFromSuperview()
            }
        }
    }
    
    func initSubviews() {
        let nib = UINib.init(nibName: className, bundle: nil)
        guard let view = nib.instantiate(withOwner: self, options: nil).first as? UIView else {
            fatalError("Can not find a view")
        }
        
        addSubview(view)
        view.autoPinEdgesToSuperviewEdges()
    }
    
    func rotate(duration: CFTimeInterval = 1.0) {
        let rotateAnimation = CABasicAnimation(keyPath: "transform.rotation")
        rotateAnimation.fromValue = 0.0
        rotateAnimation.toValue = CGFloat.pi * 2
        rotateAnimation.duration = duration
        rotateAnimation.repeatCount = Float.infinity
        self.layer.add(rotateAnimation, forKey: "animation.rotation")
    }
    
    func stopRotating(){
        self.layer.removeAnimation(forKey: "animation.rotation")
    }
    
}

// MARK: Constraints
public extension UIView {
    var heightConstraint: NSLayoutConstraint? {
        constraints
            .first {
                $0.firstItem === self
                    && $0.firstAttribute == .height
            }
    }
    
    var widthConstraint: NSLayoutConstraint? {
        constraints
            .first {
                $0.firstItem === self
                    && $0.firstAttribute == .width
            }
    }
    
    var firstLeftConstraint: NSLayoutConstraint? {
        superview?.constraints
            .first {
                ($0.firstItem === self || $0.secondItem === self)
                    && $0.firstAttribute == .leading
            }
    }
}

// MARK: - Sketch
public extension UIView {
    func applySketchShadow(
        color: UIColor = .black,
        alpha: Float = 0.2,
        x: CGFloat = 0,
        y: CGFloat = 2,
        blur: CGFloat = 4,
        spread: CGFloat = 0)
    {
        

        layer.shadowColor = color.cgColor
        layer.shadowOpacity = alpha
        layer.shadowOffset = CGSize(width: x, height: y)
        layer.shadowRadius = blur / 2
        if spread == 0 {
            layer.shadowPath = UIBezierPath(
                roundedRect: layer.bounds,
                cornerRadius: 22
            )
            .cgPath
            
        } else {
            let dx = -spread
            let rect = bounds.insetBy(dx: dx, dy: dx)
            layer.shadowPath = UIBezierPath(
                roundedRect: rect,
                cornerRadius: 22
            ).cgPath
        }
    }
}
#endif

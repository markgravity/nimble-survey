//
//  NSLayoutConstraint.swift
//  SwiftyBase
//
//  Created by Mark G on 4/8/20.
//

#if os(iOS)
public extension NSLayoutConstraint {
    var hasNotch: Bool {
        if #available(iOS 11.0, *) {
            let bottom = UIApplication.shared.keyWindow?.safeAreaInsets.bottom ?? 0
            return bottom > 0
        } else {
            
            return false
        }
        
    }
    
    @IBInspectable var iPhoneXFamilyConstant : CGFloat {
        get {
            return constant
        }
        
        set {
            if hasNotch {
                constant = newValue
            }
        }
    }
}
#endif

//
//  UIColor.swift
//  SwiftyBase
//
//  Created by Mark G on 26/09/2020.
//

#if os(iOS)
import UIKit

public extension UIColor {
    static func hex(_ string: String) -> UIColor {
        UIColor(hexString: string)
    }
    
    func isLight() -> Bool
    {
        // algorithm from: http://www.w3.org/WAI/ER/WD-AERT/#color-contrast
        let components: [CGFloat] = self.cgColor.components ?? []
        let brightness: CGFloat = ((components[0] * 299) + (components[1] * 587) + (components[2] * 114)) / 1000
        
        if brightness < 0.5
        {
            return false
        }
        else
        {
            return true
        }
    }
}

#endif

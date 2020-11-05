//
//  UIStoryboard+Utils.swift
//  VADriver
//
//  Created by Mark G on 9/26/17.
//  Copyright © 2017 Tomlar. All rights reserved.
//

#if os(iOS)
import UIKit

public extension UIStoryboard {
    func instantiateViewController<T>( withType type:T.Type)-> T{
        let name = "\(T.self)".replacingOccurrences(of: ".Type", with: "")
        return instantiateViewController(withIdentifier:  name) as! T
    }
    
    func instantiateViewController<T>( withNavigationOf type:T.Type)-> (UINavigationController, T){
        var name =  "\(T.self)".replacingOccurrences(of: ".Type", with: "")
        name = name.replacingOccurrences(of: "Controller", with: "NavigationController")
        let navigationController = instantiateViewController(withIdentifier:  name) as! UINavigationController
        
        return (
            navigationController,
            navigationController.topViewController as! T
        )
    }
}
#endif

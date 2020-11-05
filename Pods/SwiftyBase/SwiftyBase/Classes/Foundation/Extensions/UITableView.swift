//
//  UITableView.swift
//  SwiftyBase
//
//  Created by Mark G on 4/3/20.
//

#if os(iOS)
import UIKit

public extension UITableView {
    func register<T>(_ type: T.Type) {
        let nib = UINib(nibName: "\(T.self)", bundle: nil)
        register(nib, forCellReuseIdentifier: "\(T.self)")
    }
    
    func dequeueReusableCell<T>(withType type:T.Type) -> T? {
        let name = "\(T.self)"
        return dequeueReusableCell(withIdentifier: name) as? T
    }
    
    
    func dequeueReusableCell<T>(withType type:T.Type, for indexPath:IndexPath) -> T? {
        
        let name = "\(T.self)"
        return dequeueReusableCell(withIdentifier: name, for: indexPath) as? T
    }
}
#endif

//
//  UICollectionView.swift
//  Moco360
//
//  Created by Mark G on 7/20/18.
//  Copyright © 2018 Mobiclix. All rights reserved.
//

#if os(iOS)
import UIKit
import RxSwift

public extension UICollectionView {
    func dequeueReusableCell<T>(withType type:T.Type, indexPath:IndexPath) -> T? {
        let name = "\(T.self)"
        
        return dequeueReusableCell(withReuseIdentifier: name, for: indexPath) as? T
    }
}

#endif

//
//  UICollectionView+Ext.swift
//  Moco360
//
//  Created by Mark G on 3/23/20.
//  Copyright © 2020 Mobiclix. All rights reserved.
//

#if os(iOS)
import UIKit

public extension UICollectionView {
    func register<T>(_ type: T.Type) {
        let nib = UINib(nibName: "\(T.self)", bundle: nil)
        register(nib, forCellWithReuseIdentifier: "\(T.self)")
    }
}

#endif

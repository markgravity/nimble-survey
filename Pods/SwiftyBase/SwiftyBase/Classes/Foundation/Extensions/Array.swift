//
//  Array.swift
//  Pods
//
//  Created by Mark G on 10/10/2020.
//

import Foundation

public extension Array {
    func find<T>(by type: T.Type) -> T? {
        first {
            $0 is T
        } as? T
    }
    
    func findIndex<T>(by type: T.Type) -> T? {
        firstIndex {
            $0 is T
        } as? T
    }
    
}

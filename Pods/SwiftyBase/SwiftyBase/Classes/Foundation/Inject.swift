//
//  Inject.swift
//  Moco360
//
//  Created by Mark G on 3/18/20.
//  Copyright © 2020 Mobiclix. All rights reserved.
//

import Swinject

//fileprivate let _enviromentLocator = Container()
@propertyWrapper
public struct Inject<T> {
    var value: T?
    public var wrappedValue: T {
        mutating get {
            value = value != nil ? value : baseLocator.resolve(T.self)
            
            return value!
        }
    }
    
    public init() {
        
        value = baseLocator.resolve(T.self)
    }
}

//@propertyWrapper
//public struct Enviroment<T> {
//
//    var value: T?
//    public var wrappedValue: T {
//        mutating get {
//            value!
//        }
//
//        mutating set {
//            value = newValue
//            _enviromentLocator
//                .register(T.self) { _ in newValue }
//                .inObjectScope(.weak)
//        }
//    }
//
//    public init() {}
//}



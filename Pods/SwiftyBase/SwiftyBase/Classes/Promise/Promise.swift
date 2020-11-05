//
//  Promise.swift
//  Moco360
//
//  Created by Mark G on 3/22/20.
//  Copyright © 2020 Mobiclix. All rights reserved.
//

#if os(iOS)
import UIKit
#elseif os(macOS)
import Cocoa
#endif
import Promises
import RxSwift

public func await<Value>(nullable promise: Promise<Value>?) throws -> Value? {
    if let promise = promise {
        return try await(promise)
    }
    
    return nil
}

public func await<Value>(onMainThread promise: Promise<Value>) throws -> Value {
    let _promise = Promise<Value>.pending()
    promise.then {
        promise.fulfill($0)
    }
    .catch {
        promise.reject($0)
    }
    
    return try await(_promise)
}

// MARK: - Extension
public extension Promise {
    
    func map<T>(_ transform: @escaping (_ value: Value) -> T) -> Promise<T> {
        let promise = Promise<T>.pending()
        
        then { promise.fulfill(transform($0)) }
        .catch { promise.reject($0) }
        
        return promise
    }
    
    func debug(_ identifier: String)-> Promise<Value> {
        let promise = Promise<Value>.pending()
        then {
            print("[\(identifier)] - success > \($0)")
            promise.fulfill($0)
        }
        .catch {
            print("[\(identifier)] - error > \($0)")
            promise.reject($0)
        }
        
        return promise
    }
    
    // TODO: Retain circle beaware
    func asObservable() -> Observable<Value> {
        
        Observable<Value>.create { [weak self] ob in
            
            self?.then {
                ob.onNext($0)
                ob.onCompleted()
            }.catch {
                ob.onError($0)
            }
            
            return Disposables.create()
        }
    }

    static func error(_ error: Error) -> Promise<Value> {
        Promise<Value> { fulfill, reject in
            reject(error)
        }
    }
    
    static func value(_ value: Value) -> Promise<Value> {
        Promise<Value> { fulfill, reject in
            fulfill(value)
        }
    }
}

public extension Promise where Value == Void {
    static func success() -> Promise<Value> {
        Promise<Value> { fulfill, reject in
            fulfill(())
        }
    }
}

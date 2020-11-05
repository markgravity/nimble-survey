//
//  Rx+Extension.swift
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
import RxSwift
import Promises

public extension Observable {
    // TODO: Retain circle check
    var first: Promise<Element> {
        let promise = Promise<Element>.pending()
        let subscription = subscribe(onNext: {
            promise.fulfill($0)
        }, onError: {
            promise.reject($0)
        })
        promise.always {
            subscription.dispose()
        }
        
        return promise
    }
}

public extension Observable where Element == Bool {
    func invert() -> Observable<Element> {
        map { !$0 }
    }
}

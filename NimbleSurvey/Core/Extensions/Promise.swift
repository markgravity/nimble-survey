//
//  Promise.swift
//  NimbleSurvey
//
//  Created by Mark G on 31/10/2020.
//

import Promises
import SwiftyBase

extension Promise {
    
    @discardableResult
    func catchThenAlert(ignores types: Error.Type..., handler: VoidHandler? = nil) -> Promise<Value> {
        self.catch {
            
            // Skip alert an ignored error type
            for type in types {
                guard Swift.type(of: $0) == type else {
                    continue
                }
                
                return
            }
            
            alert($0, handler)
        }
    }
    
    @discardableResult
    func catchThenAlert<T:Equatable&Error>(ignores types: Error.Type..., also errors:[T]? = nil, handler: VoidHandler? = nil) -> Promise<Value> {
        self.catch {
            
            // Skip alert an ignored error type
            for type in types {
                guard Swift.type(of: $0) == type else {
                    continue
                }
                
                return
            }
            
            // Skip alert an ignored error
            for error in errors ?? [] {
                guard ($0 as? T) == error else {
                    continue
                }
                
                return
            }
            
            alert($0,handler)
        }
    }
}

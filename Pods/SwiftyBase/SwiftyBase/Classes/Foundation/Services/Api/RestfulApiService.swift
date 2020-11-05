//
//  RestfulApi.swift
//  Moco360
//
//  Created by Mark G on 3/18/20.
//  Copyright © 2020 Mobiclix. All rights reserved.
//

import Foundation
import ObjectMapper
import Promises


// MARK: - Restfultable
public protocol Restfultable {
    associatedtype Object: Mappable
    associatedtype List: ListResponsable
    
    func info(id: Int?, params: HttpParametable?, token: String?) -> Promise<Object>
    func list(params: HttpParametable?, token: String?) -> Promise<List>
    func create(params: HttpParametable?, token: String?) -> Promise<Object>
    func update(id: Int?, params: HttpParametable?, token: String?) -> Promise<Object>
    func delete(id: Int?, params: HttpParametable?, token: String?) -> Promise<Void>
}

// MARK: - RestfulApiService
open class RestfulApiService<Object: Mappable, List: ListResponsable>: Restfultable {
    @Inject public var api: ApiService
    
    open var baseUrl: String? { nil }
    open var endPoint: String { "" }
    
    public init() {}
    
    // Info
    open func info(id: Int? = nil, params: HttpParametable? = nil, token: String? = nil) -> Promise<Object> {
        
        return Promise(on: .global()) { () -> Object in
            
            let response = try await(
                self.api.request(
                    method: .get,
                    baseUrl: self.baseUrl,
                    endPoint: id == nil ? self.endPoint : "\(self.endPoint)/\(id!)",
                    token: token,
                    params: params
                )
            )
            return response.asObject()
        }
    }
    
    // List
    open func list(params: HttpParametable? = nil, token: String? = nil) -> Promise<List> {
        
        return Promise(on: .global()) { () -> List in
            
            let response = try await(
                self.api.request(
                    method: .get,
                    baseUrl: self.baseUrl,
                    endPoint: self.endPoint,
                    token: token,
                    params: params
                )
            )
            
            return response.asList()
        }
    }
    
    // Create
    @discardableResult
    open func create(params: HttpParametable? = nil, token: String? = nil) -> Promise<Object> {
        return Promise(on: .global()) { () -> Object in
            
            let response = try await(
                self.api.request(
                    method: .post,
                    baseUrl: self.baseUrl,
                    endPoint: self.endPoint,
                    token: token,
                    params: params
                )
            )
            
            return response.asObject()
        }
    }
    
    // Update
    @discardableResult
    open func update(id: Int? = nil, params: HttpParametable? = nil, token: String? = nil) -> Promise<Object> {
        return Promise(on: .global()) { () -> Object in
            
            let response = try await(
                self.api.request(
                    method: .put,
                    baseUrl: self.baseUrl,
                    endPoint: id == nil ? self.endPoint : "\(self.endPoint)/\(id!)",
                    token: token,
                    params: params
                )
            )
            
            return response.asObject()
        }
    }
    
    // Delete
    @discardableResult
    open func delete(id: Int? = nil, params: HttpParametable? = nil, token: String? = nil) -> Promise<Void> {
        return Promise(on: .global()) { () -> Void in
            
            let response = try await(
                self.api.request(
                    method: .delete,
                    baseUrl: self.baseUrl,
                    endPoint: id == nil ? self.endPoint : "\(self.endPoint)/\(id!)",
                    token: token,
                    params: params
                )
            )
            
            return response.asVoid()
        }
    }
}

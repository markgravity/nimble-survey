//
//  HttpApi.swift
//  Moco360
//
//  Created by Mark G on 3/18/20.
//  Copyright © 2020 Mobiclix. All rights reserved.
//

import Foundation
import Promises
import Alamofire

// MARK: - Protocol
public typealias RequestHandler = () -> Promise<Data>
public protocol ApiService {
    func request(
        method: HttpMethod,
        baseUrl: String?,
        endPoint: String,
        token: String?,
        params: HttpParametable?
    ) -> Promise<ApiResponse>
    
    func upload(
        method: HttpMethod,
        baseUrl: String?,
        endPoint: String,
        token: String?,
        params: FormDataParametable
    ) -> Promise<ApiResponse>
    
    func download(
        method: HttpMethod,
        baseUrl: String?,
        endPoint: String,
        token: String?,
        params: HttpParametable
    ) -> Promise<URL>
}


public extension ApiService {
    func request(
        method: HttpMethod,
        baseUrl: String? = nil,
        endPoint: String,
        token: String? = nil,
        params: HttpParametable? = nil
    ) -> Promise<ApiResponse> {
        
        request(
            method: method,
            baseUrl: baseUrl,
            endPoint: endPoint,
            token: token,
            params: params
        )
    }
    
    func upload(
        method: HttpMethod,
        baseUrl: String? = nil,
        endPoint: String,
        token: String? = nil,
        params: FormDataParametable
    ) -> Promise<ApiResponse> {
        upload(
            method: method,
            baseUrl: baseUrl,
            endPoint: endPoint,
            token: token,
            params: params
        )
    }
    
    func download(
        method: HttpMethod,
        baseUrl: String? = nil,
        endPoint: String,
        token: String? = nil,
        params: HttpParametable
    ) -> Promise<URL> {
        download(
            method: method,
            baseUrl: baseUrl,
            endPoint: endPoint,
            token: token,
            params: params
        )
    }
}

//
//  HttpParams.swift
//  Moco360
//
//  Created by Mark G on 3/19/20.
//  Copyright © 2020 Mobiclix. All rights reserved.
//

import Foundation
import ObjectMapper
import Alamofire

// MARK: - HttpParametable
public protocol HttpParametable {
    var encoding: HttpParamsEncoding { get }
    mutating func mapping(map: Map)
    func toJSON() -> [String:Any]
}

public extension HttpParametable {
    var encoding: HttpParamsEncoding { JsonParamsEncoding.default }
    
    func toJSON() -> [String:Any] {
        var object = self
        let map = Map(mappingType: .toJSON, JSON: [:])
        object.mapping(map: map)
        return map.JSON
    }
}

// MARK: - Encoding
public protocol HttpParamsEncoding: ParameterEncoding {}

public struct JsonParamsEncoding: HttpParamsEncoding {
    public static var `default`: JsonParamsEncoding { return JsonParamsEncoding() }
    
    public func encode(
        _ urlRequest: URLRequestConvertible,
        with parameters: Parameters?
    ) throws -> URLRequest {
        
        return try JSONEncoding.default.encode(
            urlRequest,
            with: parameters
        )
    }
}

public struct UrlParamsEncoding: HttpParamsEncoding {
    public static var `default`: UrlParamsEncoding { return UrlParamsEncoding() }
    public var replacesDash: Bool = true
    
    public func encode(
        _ urlRequest: URLRequestConvertible,
        with parameters: Parameters?
    ) throws -> URLRequest {
        
        var params: Parameters? = parameters
        if let parameters = parameters,
            replacesDash {
            params = Parameters()
            for (k, v) in parameters {
                let nK = k.replacingOccurrences(of: "_", with: "-")
                params?[nK] = v
            }
        }
        
        return try URLEncoding.default.encode(
            urlRequest,
            with: params
        )
    }
}


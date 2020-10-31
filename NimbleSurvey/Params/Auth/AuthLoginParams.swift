//
//  AuthLoginParams.swift
//  NimbleSurvey
//
//  Created by Mark G on 31/10/2020.
//

import ObjectMapper
import SwiftyBase

struct AuthLoginParams {
    
    // Properties
    fileprivate let _grantType: AuthLoginGrantType = .refreshToken
    fileprivate let _clientId: String = Constant.Auth.Key
    fileprivate let _clientSerect: String = Constant.Auth.Serect
    
    let email: String?
    let password: String?
}

// MARK: - HttpParametable
extension AuthLoginParams: HttpParametable {
    
    mutating func mapping(map: Map) {
        _grantType       >>> (map["grant_type"], EnumTransform<AuthLoginGrantType>())
        _clientId        >>> map["client_id"]
        _clientSerect    >>> map["client_secret"]
        email           >>> map["email"]
        password        >>> map["password"]
    }
}

// MARK: - Enums
enum AuthLoginGrantType: String {
    case password = "password"
    case refreshToken = "refresh_token"
}

//
//  AuthRefreshTokenParams.swift
//  NimbleSurvey
//
//  Created by Mark G on 31/10/2020.
//

import ObjectMapper
import SwiftyBase

struct AuthRefreshTokenParams {
    
    // Properties
    fileprivate let _grantType: AuthLoginGrantType = .refreshToken
    fileprivate let _clientId: String = Constant.Auth.Key
    fileprivate let _clientSerect: String = Constant.Auth.Serect
    
    let refreshToken: String
}

// MARK: - HttpParametable
extension AuthRefreshTokenParams: HttpParametable {
    
    mutating func mapping(map: Map) {
        _grantType       >>> (map["grant_type"], EnumTransform<AuthLoginGrantType>())
        _clientId        >>> map["client_id"]
        _clientSerect    >>> map["client_secret"]
        refreshToken     >>> map["refresh_token"]
    }
}

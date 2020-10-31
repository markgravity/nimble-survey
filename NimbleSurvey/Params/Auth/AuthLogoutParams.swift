//
//  AuthLogoutParams.swift
//  NimbleSurvey
//
//  Created by Mark G on 31/10/2020.
//

import ObjectMapper
import SwiftyBase

struct AuthLogoutParams {
    
    // Properties
    fileprivate let _clientId: String = Constant.Auth.Key
    fileprivate let _clientSerect: String = Constant.Auth.Serect
    let token: String
}

// MARK: - HttpParametable
extension AuthLogoutParams: HttpParametable {
    
    mutating func mapping(map: Map) {
        _clientId        >>> map["client_id"]
        _clientSerect    >>> map["client_secret"]
        
        token            >>> map["token"]
    }
}

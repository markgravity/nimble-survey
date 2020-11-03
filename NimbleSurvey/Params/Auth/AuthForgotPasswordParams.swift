//
//  AuthForgotPasswordParams.swift
//  NimbleSurvey
//
//  Created by Mark G on 31/10/2020.
//

import ObjectMapper
import SwiftyBase

struct AuthForgotPasswordParams {
    
    // Properties
    fileprivate let _clientId: String = Constant.Auth.Key
    fileprivate let _clientSerect: String = Constant.Auth.Serect
    fileprivate var _user: [String:Any] {
        ["email": email as Any]
    }
    var email: String?

    
}

// MARK: - HttpParametable
extension AuthForgotPasswordParams: HttpParametable {
    
    mutating func mapping(map: Map) {
        _clientId        >>> map["client_id"]
        _clientSerect    >>> map["client_secret"]
        _user            >>> map["user"]
    }
}

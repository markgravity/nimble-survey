//
//  UserTokenInfo.swift
//  NimbleSurvey
//
//  Created by Mark G on 31/10/2020.
//

import ObjectMapper

struct UserTokenInfo {
    
    // Properties
    var accessToken: String!
    var refreshToken: String!
    var expiresIn: TimeInterval!
    
}

// MARK: - Mappble
extension UserTokenInfo: Mappable {
    init?(map: Map) {}
    
    mutating func mapping(map: Map) {
        accessToken     <- map["attributes.access_token"]
        refreshToken    <- map["attributes.refresh_token"]
        expiresIn       <- map["attributes.expires_in"]
    }
}

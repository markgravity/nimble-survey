//
//  UserService.swift
//  NimbleSurvey
//
//  Created by Mark G on 31/10/2020.
//

import SwiftyBase
import Promises

// MARK: - Protocol
protocol UserService: RestfulApiService<UserInfo, ListResponse<UserInfo>> {
    
    func me() -> Promise<UserInfo>
}

// MARK: Implements
class UserServiceImpl: RestfulApiService<UserInfo, ListResponse<UserInfo>>, UserService {
  
    override
    var endPoint: String {""}
    
    func me() -> Promise<UserInfo> {
        api.request(
            method: .get,
            baseUrl: nil,
            endPoint: "/me",
            token: nil,
            params: nil
        )
        .map { $0.asObject() }
    }
}

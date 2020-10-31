//
//  UserService.swift
//  NimbleSurvey
//
//  Created by Mark G on 31/10/2020.
//

import SwiftyBase
import Promises

// MARK: - Protocol
protocol UserService {
    
    func me() -> Promise<UserInfo>
}

// MARK: Implements
class UserServiceImpl: UserService {
    @Inject fileprivate var _api: ApiService
    
    func me() -> Promise<UserInfo> {
        _api.request(
            method: .get,
            baseUrl: nil,
            endPoint: "/me",
            token: nil,
            params: nil
        )
        .map { $0.asObject() }
    }
}

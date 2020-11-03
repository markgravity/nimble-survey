//
//  AuthService.swift
//  NimbleSurvey
//
//  Created by Mark G on 31/10/2020.
//

import SwiftyBase
import Promises

// MARK: - Protocol
protocol AuthService {
    
    func login(params: AuthLoginParams) -> Promise<UserTokenInfo>
    func logout(params: AuthLogoutParams) -> Promise<Void>
    func refreshToken(params: AuthRefreshTokenParams) -> Promise<UserTokenInfo>
    func forgotPassword(params: AuthForgotPasswordParams) -> Promise<Void>
}

// MARK: Implements
class AuthServiceImpl: AuthService {
    @Inject fileprivate var _api: ApiService
    
    func login(params: AuthLoginParams) -> Promise<UserTokenInfo> {
        _api.request(
            method: .post,
            baseUrl: nil,
            endPoint: "/oauth/token",
            token: nil,
            params: params
        )
        .map { $0.asObject() }
    }
    
    func logout(params: AuthLogoutParams) -> Promise<Void> {
        _api.request(
            method: .post,
            baseUrl: nil,
            endPoint: "/oauth/revoke",
            token: nil,
            params: params
        )
        .map { $0.asVoid() }
    }
    
    func refreshToken(params: AuthRefreshTokenParams) -> Promise<UserTokenInfo> {
        _api.request(
            method: .post,
            baseUrl: nil,
            endPoint: "/oauth/token",
            token: nil,
            params: params
        )
        .map { $0.asObject() }
    }
    
    func forgotPassword(params: AuthForgotPasswordParams) -> Promise<Void> {
        _api.request(
            method: .post,
            baseUrl: nil,
            endPoint: "/passwords",
            token: nil,
            params: params
        )
        .map { $0.asVoid() }
    }
}

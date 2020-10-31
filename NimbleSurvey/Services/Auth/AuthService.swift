//
//  AuthService.swift
//  NimbleSurvey
//
//  Created by Mark G on 31/10/2020.
//

import SwiftyBase
import Promises

// MARK: - Protocol
protocol AuthService: RestfulApiService<UserTokenInfo, ListResponse<UserTokenInfo>> {
    
    func login(params: AuthLoginParams) -> Promise<UserTokenInfo>
    func logout(params: AuthLogoutParams) -> Promise<Void>
    func refreshToken(params: AuthRefreshTokenParams) -> Promise<UserTokenInfo>
    func forgotPassword(params: AuthForgotPasswordParams) -> Promise<Void>
}

// MARK: Implements
class AuthServiceImpl: RestfulApiService<UserTokenInfo, ListResponse<UserTokenInfo>>, AuthService {
  
    override
    var endPoint: String {"/oauth"}
    
    func login(params: AuthLoginParams) -> Promise<UserTokenInfo> {
        api.request(
            method: .post,
            baseUrl: nil,
            endPoint: "\(endPoint)/token",
            token: nil,
            params: params
        )
        .map { $0.asObject() }
    }
    
    func logout(params: AuthLogoutParams) -> Promise<Void> {
        api.request(
            method: .post,
            baseUrl: nil,
            endPoint: "\(endPoint)/revoke",
            token: nil,
            params: params
        )
        .map { $0.asVoid() }
    }
    
    func refreshToken(params: AuthRefreshTokenParams) -> Promise<UserTokenInfo> {
        api.request(
            method: .post,
            baseUrl: nil,
            endPoint: "\(endPoint)/token",
            token: nil,
            params: params
        )
        .map { $0.asObject() }
    }
    
    func forgotPassword(params: AuthForgotPasswordParams) -> Promise<Void> {
        api.request(
            method: .post,
            baseUrl: nil,
            endPoint: "/passwords",
            token: nil,
            params: params
        )
        .map { $0.asVoid() }
    }
}

//
//  AuthVM.swift
//  NimbleSurvey
//
//  Created by Mark G on 29/10/2020.
//

import RxSwift
import SwiftyBase
import Promises
import Burritos

// MARK: - Protocol
protocol AuthVM {
    var user: ValueObservable<UserInfo?> { get }
    var isAuthenticated: ValueObservable<Bool> { get }
    
    
    func retrieve() -> Promise<Void>
    func login(params: AuthLoginParams) -> Promise<Void>
    func logout() -> Promise<Void>
    func refreshToken() -> Promise<Void>
    func forgotPassword(params: AuthForgotPasswordParams) -> Promise<Void>
}

// MARK: - Implements
class AuthVMImpl: AuthVM {
    static var rawTokenKey: String { "auth_raw_token" }
    
    @Inject fileprivate var _userService: UserService
    @Inject fileprivate var _authService: AuthService
    
    /// Token
    @UserDefault(AuthVMImpl.rawTokenKey, defaultValue: "", userDefaults: locator.resolve(UserDefaults.self)!)
    fileprivate var _rawToken: String
    fileprivate var _token: UserTokenInfo? {
        UserTokenInfo(JSONString: _rawToken)
    }
    
    /// User
    fileprivate let _user = MutableValue<UserInfo?>(nil)
    var user: ValueObservable<UserInfo?> {
        _user
    }
    
    /// Authentication flag
    var isAuthenticated: ValueObservable<Bool> {
        _user
            .map {
                $0 != nil
            }
    }
    
}

// MARK: - Public
extension AuthVMImpl {
    
    /// Attemp to retrieve local authentication info
    /// and fetch user info
    func retrieve() -> Promise<Void> {
        
        Promise(on: .global()) {
            
            // No authentication
            guard let token = self._token
            else { return }
            
            // Set token into api configs
            ApiConfigs.token = token.accessToken
            
            // Request for user info
            do {
                
                let user = try await(
                    self._userService.me()
                )
                self._user.accept(user)
            } catch {
                
                // Handle invalid token
                guard let apiException = error as? ApiException,
                      case .other(let errorBag) = apiException,
                      errorBag.hasError(source: .unauthorized, code: .invalidToken)
                else {
                    throw error
                }
                
                // Clear auth when token
                // was invalided
                self._clearToken()
                self._user.accept(nil)
            }
            
        }
    }
    
    func login(params: AuthLoginParams) -> Promise<Void> {
        
        Promise(on: .global()) {
            
            // Request for a token info
            var userToken: UserTokenInfo!
            do {
                userToken = try await(
                    self._authService.login(params: params)
                )
            } catch {
                throw AuthException.invalidGrant
            }
            
            // Store user token
            self._storeToken(userToken)
            
            // Request for user info
            let user = try await(
                self._userService.me()
            )
            self._user.accept(user)
        }
    }
    
    func logout() -> Promise<Void> {
        
        Promise(on: .global()) {
            
            guard let token = self._token
            else { return }
            
            // Revoke auth, ignore error
            // from revoking in server side
            let params = AuthLogoutParams(token: token.accessToken)
            try? await(
                self._authService.logout(params: params)
            )
            
            // Clear local data
            self._clearToken()
            self._user.accept(nil)
        }
    }
    
    func refreshToken() -> Promise<Void> {
        
        Promise(on: .global()) {
            
            guard let token = self._token
            else {
                throw AuthException.invalidGrant
            }
            
            // Request for a new token info
            let params = AuthRefreshTokenParams(refreshToken: token.refreshToken)
            var userToken: UserTokenInfo!
            do {
                userToken = try await(
                    self._authService.refreshToken(params: params)
                )
            } catch {
                throw AuthException.invalidGrant
            }
            
            // Store user token
            self._storeToken(userToken)
        }
    }
    
    func forgotPassword(params: AuthForgotPasswordParams) -> Promise<Void> {
        
        Promise(on: .global()) {
            
            try await(
                self._authService.forgotPassword(params: params)
            )
        }
    }
}

// MARK: - Private
fileprivate extension AuthVMImpl {
    func _storeToken(_ token: UserTokenInfo) {
        
        // Store local
        self._rawToken = token.toJSONString() ?? ""
        
        // Set token into ApiConfigs
        ApiConfigs.token = token.accessToken
    }
    
    func _clearToken() {
        
        // Clear in local
        self._rawToken = ""
        
        // Clear in ApiConfigs
        ApiConfigs.token = nil
    }
}

// MARK: - State & Enums
enum AuthException: LocalizedError {
    case invalidGrant
    
    var errorDescription: String? {
        switch self {
        case .invalidGrant:
            return "auth.invalid_grant_msg".trans()
        }
    }
}

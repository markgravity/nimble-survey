//
//  AuthForgotPasswordVM.swift
//  NimbleSurvey
//
//  Created by Mark G on 31/10/2020.
//

import RxSwift
import SwiftyBase
import Promises

// MARK: - Protocol
protocol AuthForgotPasswordVM {
    var state: ValueObservable<AuthForgotPasswordState> { get }
    var isValid: Observable<Bool> { get }
    
    func reset() -> Promise<Void>
    func setEmail(_ text: String?)
}

// MARK: - Implements
class AuthForgotPasswordVMImpl: AuthForgotPasswordVM {
    
    @Inject fileprivate var _authVM: AuthVM
    fileprivate var _isResetting: Bool = false
    
    /// Email
    fileprivate let _email = MutableValue<String?>(nil)

    /// State
    fileprivate let _state = MutableValue<AuthForgotPasswordState>(.initial)
    var state: ValueObservable<AuthForgotPasswordState> {
        _state
    }
    
    /// Delimiter when able to reset
    var isValid: Observable<Bool> {
        _email
            .map {
                $0?.count ?? 0 > 0
            }
    }
}

// MARK: - Public
extension AuthForgotPasswordVMImpl {
    
    func reset() -> Promise<Void> {
        
        return Promise(on: .global()) {
            
            // Validate state
            guard !self._isResetting
            else { return }
            
            // Mark as logging
            self._isResetting = true
            self._state.accept(.resetting)
            
            // Begin reset
            let params = AuthForgotPasswordParams(
                email: self._email.value
            )
            try await(
                self._authVM.forgotPassword(params: params)
            )
            
            self._state.accept(.resetted)
            self._state.accept(.initial)
            self._isResetting = false
        }
        .catch {
            self._state.accept(.error($0 as NSError))
            self._state.accept(.initial)
            self._isResetting = false
        }
    }
    
    func setEmail(_ text: String?) {
        _email.accept(text)
    }
}

// MARK: - Private
fileprivate extension AuthForgotPasswordVMImpl {
    
    
}

// MARK: - State & Enums
enum AuthForgotPasswordState: Equatable {
    
    case initial
    case resetting
    case resetted
    case error(NSError)
}

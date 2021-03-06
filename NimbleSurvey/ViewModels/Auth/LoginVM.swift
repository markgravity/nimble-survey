//
//  LoginVM.swift
//  NimbleSurvey
//
//  Created by Mark G on 31/10/2020.
//

import RxSwift
import SwiftyBase
import Promises

// MARK: - Protocol
protocol LoginVM {
    var state: ValueObservable<LoginState> { get }
    var isValid: Observable<Bool> { get }
    
    func login() -> Promise<Void>
    func setEmail(_ text: String?)
    func setPassword(_ text: String?)
}

// MARK: - Implements
class LoginVMImpl: LoginVM {
    @Inject fileprivate var _authVM: AuthVM
    
    fileprivate var _isLogging = false
    
    /// Email
    fileprivate let _email = MutableValue<String?>(nil)
    
    /// Password
    fileprivate let _password = MutableValue<String?>(nil)
    
    /// State
    fileprivate let _state = MutableValue<LoginState>(.initial)
    var state: ValueObservable<LoginState> {
        _state
    }
    
    /// Delimiter when able to login
    var isValid: Observable<Bool> {
        Observable.combineLatest(
            _email,
            _password
        )
        .withUnretained(self)
        .map {
            $0.0._isValid($0.1.0, $0.1.1)
        }
    }
}

// MARK: - Public
extension LoginVMImpl {
    
    func login() -> Promise<Void> {

        return Promise(on: .global()) {
            
            // Validate state
            guard !self._isLogging
            else { return }
            
            // Mark as logging
            self._isLogging = true
            self._state.accept(.logging)
            
            // Begin login
            let param = AuthLoginParams(
                email: self._email.value,
                password: self._password.value
            )
            try await(
                self._authVM.login(params: param)
            )
            
            self._state.accept(.logged)
            self._isLogging = false
        }
        .catch {
            self._state.accept(.error($0 as NSError))
            self._state.accept(.initial)
            self._isLogging = false
        }
    }
    
    func setEmail(_ text: String?) {
        _email.accept(text)
    }
    
    func setPassword(_ text: String?) {
        _password.accept(text)
    }
}

// MARK: - Private
fileprivate extension LoginVMImpl {
    
    func _isValid(_ email: String?, _ password: String?) -> Bool {
        guard let email = email,
              let password = password
        else { return false }
        
        return email.count > 0 && password.count > 0
    }
}

// MARK: - State & Enums
enum LoginState: Equatable {
    
    case initial
    case logging
    case logged
    case error(NSError)
}

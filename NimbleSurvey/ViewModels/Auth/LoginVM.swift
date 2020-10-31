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
    
    func login(email: String?, password: String?) -> Promise<Void>
}

// MARK: - Implements
class LoginVMImpl: LoginVM {
    @Inject fileprivate var _authVM: AuthVM
    
    /// State
    fileprivate let _state = MutableValue<LoginState>(.initial)
    var state: ValueObservable<LoginState> {
        _state
    }
}

// MARK: - Public
extension LoginVMImpl {
    
    func login(email: String?, password: String?) -> Promise<Void> {
        
        // Validate state
        guard case .initial = _state.value
        else { return .success() }

        return Promise(on: .global()) {
            
            // Mark as logging
            self._state.accept(.logging)
            
            // Begin login
            let param = AuthLoginParams(
                email: email,
                password: password
            )
            try await(
                self._authVM.login(params: param)
            )
        }
        .catch {
            self._state.accept(.error($0))
            self._state.accept(.initial)
        }
    }
}

// MARK: - Private
fileprivate extension LoginVMImpl {
    
}

// MARK: - State & Enums
enum LoginState {
    
    case initial
    case logging
    case error(Error)
}

//
//  LandingVM.swift
//  NimbleSurvey
//
//  Created by Mark G on 31/10/2020.
//

import RxSwift
import SwiftyBase
import Promises

// MARK: - Protocol
protocol LandingVM {
    func fetch() -> Promise<Void>
}

// MARK: - Implements
class LandingVMImpl: LandingVM {
    @Inject fileprivate var _authVM: AuthVM
}

// MARK: - Public
extension LandingVMImpl {
    
    func fetch() -> Promise<Void> {
        
        Promise(on: .global()) {
            try await(
                self._authVM.retrieve()
            )
        }.timeout(5)
    }
}

// MARK: - Private
fileprivate extension LandingVMImpl {
    
}

// MARK: - State & Enums

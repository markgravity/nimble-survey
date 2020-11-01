//
//  LocatorRegister.swift
//  anyWidget
//
//  Created by Mark G on 26/09/2020.
//  Copyright © 2020 Mark G. All rights reserved.
//

import SwiftyBase

let locator = baseLocator
class LocatorRegister: NSObject, PluginRegisterable {
    
    override init() {
        super.init()
        
        _registerFactories()
        _registerSingletons()
    }
    
    func configure(application: UIApplication, launchOptions: [UIApplication.LaunchOptionsKey : Any]?) {
    }
}

// MARK: - Factories
fileprivate extension LocatorRegister {
    
    func _registerFactories() {
        
        // Http
        locator.register(HttpService.self) { _ in
            HttpServiceImpl()
        }
        
        // Api
        locator.register(ApiService.self) { _ in
            ApiServiceImpl()
        }
        
        // User
        locator.register(UserService.self) { _ in
            UserServiceImpl()
        }
        
        // Auth
        locator.register(AuthService.self) { _ in
            AuthServiceImpl()
        }
        
        // SurveyService
        locator.register(SurveyService.self) { _ in
            SurveyServiceImpl()
        }
        
        // UserDefaults
        locator.register(UserDefaults.self) { _ in
            UserDefaults.standard
        }
        
        // LandingVM
        locator.register(LandingVM.self) { _ in
            LandingVMImpl()
        }
        
        // LoginVM
        locator.register(LoginVM.self) { _ in
            LoginVMImpl()
        }
        
        // ForgetPasswordVM
        locator.register(AuthForgotPasswordVM.self) { _ in
            AuthForgotPasswordVMImpl()
        }
        
        // HomeVM
        locator.register(HomeVM.self) { _ in
            HomeVMImpl()
        }
    }
}

// MARK: - Singleton
fileprivate extension LocatorRegister {
    
    func _registerSingletons() {
        
        locator.registerSingleton(AuthVM.self, AuthVMImpl())
    }
}

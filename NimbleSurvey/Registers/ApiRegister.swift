//
//  ApiRegister.swift
//  Moco360
//
//  Created by Mark G on 3/27/20.
//  Copyright © 2020 Mobiclix. All rights reserved.
//

import Promises
import AlamofireNetworkActivityLogger
import SwiftyBase
import RxSwift
import SwiftyPopup

class ApiRegister: NSObject, PluginRegisterable {
    @Inject fileprivate var _authVM: AuthVM
    
    fileprivate let _disposeBag = DisposeBag()
    fileprivate var _isRefreshingToken: Bool = false
    fileprivate var _onNavigating = false
    
    var isPersistent: Bool = true
    
    
    override init() {
        super.init()
        
        // Base url
        ApiConfigs.baseUrl = Constant.App.ApiUrl
        ApiConfigs.retry = { [weak self] error, request, trace in
            
            // Handle invalid token only
            guard let `self` = self,
                  let apiException = error as? ApiException,
                  case .other(let errorBag) = apiException,
                  errorBag.hasError(source: .unauthorized, code: .invalidToken)
            else { throw error }
            
            
            // Make a request waiting
            guard !self._isRefreshingToken else {
                let data =  try await(self._waitForRefreshingToken(request: request))
                return data
            }
            
            // Begin refreshing token
            self._isRefreshingToken = true
            do {
                try await(self._authVM.refreshToken())
            } catch {
                
                // Proceed the logout
                // on any error
                self._navigateToLogin(by: apiException)
                throw apiException
            }
            
            self._isRefreshingToken = false
            
            // Retry the request
            let data = try await(request())
            return data
        }
        
        // Log
        #if DEBUG
        NetworkActivityLogger.shared.level = .debug
        NetworkActivityLogger.shared.startLogging()
        #endif
    }
    
    func configure(application: UIApplication, launchOptions: [UIApplication.LaunchOptionsKey : Any]?) {
    }
}

// MARK: - Private
fileprivate extension ApiRegister {
    
    /// Navigate to login for critical error
    /// such as: unauthorized
    func _navigateToLogin(by exception: ApiException) {
        guard _authVM.isAuthenticated.value
                && !_onNavigating else {
            return
        }
        _onNavigating = true
        
        // Logout
        _ = _authVM.logout()
        
        
        // Navigate to login screen
        let storyboard = UIStoryboard(name: "Auth", bundle: nil)
        
        // Main thread check
        let task: VoidHandler = { [weak self] in
            let controller = storyboard.instantiateViewController(withIdentifier: "LoginNavigationController")
            UIView.keyWindow?.rootViewController = controller
            
            // Clean all popups
            PopupNavigator.dismissAll()
            
            // Show alert
            alert(exception)
            
            
            self?._onNavigating = false
        }
        
        // Make sure it run on main thread
        guard Thread.isMainThread else {
            DispatchQueue.main.async {
                task()
            }
            return
        }
        
        task()
    }
    
    /// Make a request waiting
    /// when we're refreshing token
    func _waitForRefreshingToken(request: RequestHandler) throws -> Promise<Data> {
        let timeout = 5
        var tick = 1
        while _isRefreshingToken && tick < timeout {
            tick += 1
            sleep(1)
        }
        
        return request()
    }
}

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

class ApiRegister: NSObject, PluginRegisterable {
    fileprivate let _disposeBag = DisposeBag()
    
    var isPersistent: Bool = true
    
    
    func configure(application: UIApplication, launchOptions: [UIApplication.LaunchOptionsKey : Any]?) {
        
        // Base url
        ApiConfigs.baseUrl = Constant.App.ApiUrl
//        ApiConfigs.retry = { [unowned self] error, request, trace in
//            
//            guard let apiException = error as? ApiException
//            else { throw error }
//            
//            switch apiException {
//            case .tokenExpired, .tokenInvalid:
//                _ = _authVM.logout()
//                throw error
//                
//            default:
//                throw error
//            }
//        }
        // Log
        #if DEBUG
        NetworkActivityLogger.shared.level = .debug
        NetworkActivityLogger.shared.startLogging()
        #endif
    }
}

//
//  Locator.swift
//  SwiftyBase
//
//  Created by Mark G on 3/24/20.
//

#if os(iOS)
import UIKit
#elseif os(macOS)
import Cocoa
#endif
import Swinject

public let baseLocator = Container()
private var _singletonServices = [String : Any]()

// Singleton
public extension Container {
    func registerSingleton<Service>(_ serviceType: Service.Type,_ service: Service) {
        //        _singletonServices["\(Service.self)"] = service
        baseLocator.register(serviceType) { _ in service }
    }
    
    func callAsFunction<Service>(_ type: Service.Type) -> Service {
        baseLocator.resolve(type)!
    }
    
    func weakResolve<Service>(_ serviceType: Service.Type) -> Service? {
        let service = resolve(serviceType)
        if let service = service {
            register(serviceType) { _ in service }.inObjectScope(.weak)
        }
        
        return service
    }
    
    func weakResolve<Service, Arg1>(
        _ serviceType: Service.Type,
        argument: Arg1
    ) -> Service? {
        
        let service = resolve(serviceType, argument: argument)
        if let service = service {
            register(serviceType) { _ in service }.inObjectScope(.weak)
        }
        
        return service
    }
}

//
//  Ext+UIViewController.swift
//  VideoChat
//
//  Created by Quang Huy on 5/14/18.
//  Copyright © 2018 Mobiclix. All rights reserved.
//

#if os(iOS)
import UIKit
import Promises
import RxSwift

public extension UIViewController {
    func performSegue<T>(withType: T.Type, sender: Any?){
        let name = "\(T.self)"
        
        performSegue(withIdentifier: name, sender: sender)
    }
    
    func performSegue<T>(withNavigationOf type: T.Type, sender: Any?){
        var name = "\(T.self)"
        name = name.replacingOccurrences(of: "Controller", with: "NavigationController")
        
        performSegue(withIdentifier: name, sender: sender)
    }
    
    func attachDismissKeyboardOnTap() {
        let recognizer = UITapGestureRecognizer.init(target: self, action: #selector(dismissKeyboard))
        if let this = self as? UIGestureRecognizerDelegate {
            recognizer.delegate = this
        }
        view.addGestureRecognizer(recognizer)
    }
    
    @objc func dismissKeyboard(){
        view.endEditing(true)
    }
    
    func dismissAllPresentedViewControllers(animated: Bool) -> Promise<Void> {
        var controllers = [UIViewController]()
        var controller = presentedViewController
        while controller != nil {
            controllers.append(controller!)
            controller = controller?.presentedViewController
        }
        
        var main = Observable.just(())
        for controller in controllers.reversed() {
            let observable = Observable<Void>.deferred {
                Observable.create { ob in
                    controller.dismiss(animated: animated, completion: {
                        ob.onNext(())
                        ob.onCompleted()
                    })
                    
                    return Disposables.create()
                }
            }
            
            main = main.flatMap {
                observable
            }
        }
        
        return main.first
    }
}
#endif

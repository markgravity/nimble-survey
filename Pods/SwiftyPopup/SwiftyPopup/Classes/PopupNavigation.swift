//
//  PopupNavigation.swift
//  SwiftyPopup
//
//  Created by Mark G on 4/17/20.
//

import UIKit
import Promises

public class PopupNavigation<R: Any> {
    
    let promise = Promise<R>.pending()
    fileprivate weak var _popup: UIView?
    fileprivate weak var _container: UIView!
    fileprivate var _isRoot: Bool = false
    
    public init(container: UIView, popup: UIView? = nil) {
        _container = container
        _popup = popup
    }
    
    public func pop(_ result: R) {
        var view: UIView? = _popup
        while view != nil {
            if view is PopupView {
                (view as! PopupView).dismiss(animated: true)
                break
            }
            
            view = view?.superview
        }
        
        promise.fulfill(result)
    }
    
    public func popAll() {
        PopupNavigator.dismissAll()
    }
    
    /// Push a new content
    public func push<T: Popupable>(popup: T) -> Promise<T.ResultType> {
        
        PopupNavigator.show(popup: popup, in: _container, isRoot: false)
    }
}

// Void
public extension PopupNavigation where R == Void {
    func pop() {
        pop(())
    }
}

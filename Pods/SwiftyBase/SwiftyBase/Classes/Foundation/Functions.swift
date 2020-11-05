//
//  Functions.swift
//  SwiftyBase
//
//  Created by Mark G on 4/17/20.
//

#if os(iOS)
import UIKit
import NVActivityIndicatorView

public typealias VoidHandler = () -> Void
public typealias ValueChangedHandler<T> = (_ value: T) -> Void

public func showProgressHUD() {

    let data = ActivityData.init(type: .circleStrokeSpin)
    NVActivityIndicatorPresenter.sharedInstance.startAnimating(data, nil)
}

public func dismissProgressHUD() {
    NVActivityIndicatorPresenter.sharedInstance.stopAnimating(nil)
}

#endif

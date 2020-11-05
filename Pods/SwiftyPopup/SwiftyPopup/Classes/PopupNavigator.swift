//
//  PopupNavigator.swift
//  SwiftyPopup
//
//  Created by Mark G on 4/17/20.
//

import UIKit
import Promises
import RxSwift
import RxCocoa

public enum PopupStyle {
    case center, top, bottom, left, right, fullscreen
}

public class PopupNavigator {
    public static weak var defaultWindow: UIWindow?
    public static weak var container: UIView? {
        didSet {
            _isAllPopupDismissed.accept(container == nil)
        }
    }
    fileprivate static var _isAllPopupDismissed = BehaviorRelay(value: true)
    public static var isAllPopupDismissed: Observable<Bool> { _isAllPopupDismissed.asObservable()
    }
    
    @discardableResult
    public static func begin<T: Popupable>(
        with root: T,
        in container: UIView? = nil
    ) -> Promise<T.ResultType> {
        
//        assert(Self.container == nil)
        return show(popup: root, in: container, isRoot: true)
    }
    
    @discardableResult
    public static func push<T: Popupable>(
        popup: T
    ) -> Promise<T.ResultType> {
        
        guard let container = Self.container else {
            return begin(with: popup)
        }
        
        return show(popup: popup, in: container, isRoot: false)
    }
    
    /// Show a content view as popup
    static func show<T: Popupable>(
        popup: T,
        in container: UIView? = nil,
        isRoot: Bool = false
    ) -> Promise<T.ResultType> {
        
        // Container is nil
        let window = UIView.keyWindow ?? defaultWindow
        guard let container  = container ?? window else {
            return Promise<T.ResultType>() {
                throw NSError(domain: "swifty_popup", code: 1, userInfo: nil)
            }
        }
        
        if isRoot {
            Self.container = container
        }
        
        // Create PopupView from view
        let presenter = PopupView(contentView: popup)
        
        presenter.shouldDismissOnBackgroundTouch = popup.shouldDismissOnBackgroundTap
        presenter.didFinishDismissingCompletion = { [unowned popup] in
            
            popup.onDismiss()
            NotificationCenter.default
                .post(name: Notification.Name("AnalyticsPopupClose"), object: "\(T.self)")
            
            if isRoot {
                Self.container = nil
            }
        }
        
        // Dimmed mask alpha
        presenter.dimmedMaskAlpha = popup.dimmedMaskAlpha
        
        // Mask type
        presenter.maskType = popup.maskType
        
        // On background tap
        presenter.onBackgroundTap = { [unowned popup] in
            popup.onBackgroundTap()
        }
        
        // Style
        var layout: PopupView.Layout!
        switch popup.style {
        case .center, .fullscreen:
            layout = PopupView.Layout(horizontal: .center, vertical: .center)
            presenter.showType = .shrinkIn
            presenter.dismissType = .shrinkOut
            
        case .top:
            layout = PopupView.Layout(horizontal: .center, vertical: .top)
            presenter.showType = .slideInFromTop
            presenter.dismissType = .slideOutToTop
            
        case .bottom:
            layout = PopupView.Layout(horizontal: .center, vertical: .bottom)
            presenter.showType = .slideInFromBottom
            presenter.dismissType = .slideOutToBottom
            
        case .left:
            layout = PopupView.Layout(horizontal: .left, vertical: .center)
            presenter.showType = .slideInFromLeft
            presenter.dismissType = .slideOutToLeft
            
        case .right:
            layout = PopupView.Layout(horizontal: .right, vertical: .center)
            presenter.showType = .slideInFromRight
            presenter.dismissType = .slideOutToRight
        }
        
        // Add to container
        container.addSubview(presenter)
        
        
        // Setup Autolayout
        _configureConstraints(
            for: popup,
            container: container,
            style: popup.style,
            minHorizontalSpacing: popup.minHorizontalSpacing,
            minVerticalSpacing: popup.minVerticalSpacing
        )
        
        // Assign a navigator
        popup.navigation = PopupNavigation<T.ResultType>(
            container: container,
            popup: popup
        )
        
        
        // Show popup
        NotificationCenter.default
            .post(name: Notification.Name("AnalyticsPopupOpen"), object: "\(T.self)")
        presenter.show(with: layout)
        
        return popup.navigation.promise
        
    }
    
    public static func dismissAll() {
        guard let container = container else { return }
        _forEachPopup(in: container) {
            $0.dismiss(animated: true)
        }
    }
    
    
    fileprivate static func _forEachPopup(in view: UIView, block: (_ popup: PopupView) -> Void) {
        for subview in view.subviews {
            guard let popup = subview as? PopupView else {
                _forEachPopup(in: subview, block: block)
                continue
            }
            
            block(popup)
        }
    }
    
    fileprivate static func _configureConstraints(
        for view: UIView,
        container: UIView,
        style: PopupStyle,
        minHorizontalSpacing: CGFloat,
        minVerticalSpacing: CGFloat) {
        
        // Max size
        var baseSize = container.frame.size
        var viewSize = view.frame.size
        
        // Get width base on style
        var width: CGFloat = 0
        var height: CGFloat = 0
        switch style {
        case .bottom, .top:
            width = baseSize.width
            height = baseSize.height - minVerticalSpacing
            viewSize.width = width
            
        case .center, .left, .right:
            width = baseSize.width - minHorizontalSpacing
            height = baseSize.height - minVerticalSpacing
            
        case .fullscreen:
            baseSize = UIScreen.main.bounds.size
            viewSize = baseSize
            width = baseSize.width
            height = baseSize.height
        }
        
        // Maxsize
        let maxSize = CGSize(
            width: width,
            height: height
        )
        
        view.translatesAutoresizingMaskIntoConstraints = false
        let constraints = [
            NSLayoutConstraint(
                item: view,
                attribute: .width,
                relatedBy: .equal,
                toItem: nil,
                attribute: .notAnAttribute,
                multiplier: 1,
                constant: viewSize.width
            ),
            NSLayoutConstraint(
                item: view,
                attribute: .height,
                relatedBy: .equal,
                toItem: nil,
                attribute: .notAnAttribute,
                multiplier: 1,
                constant: viewSize.height
            ),
            NSLayoutConstraint(
                item: view,
                attribute: .height,
                relatedBy: .lessThanOrEqual,
                toItem: nil,
                attribute: .notAnAttribute,
                multiplier: 1,
                constant: maxSize.height
            ),
            NSLayoutConstraint(
                item: view,
                attribute: .width,
                relatedBy: .lessThanOrEqual,
                toItem: nil,
                attribute: .notAnAttribute,
                multiplier: 1,
                constant: maxSize.width
            )
        ]
        constraints[0].priority = .defaultHigh - 1
        constraints[1].priority = .defaultHigh - 1
        
        NSLayoutConstraint.activate(constraints)
    }
}


// MARK: - UIView Extensions
public extension UIView {
    static var keyWindow: UIWindow? {
        if #available(iOS 13.0, *) {
            let keyWindow = UIApplication.shared.connectedScenes
                .filter({$0.activationState == .foregroundActive})
                .map({$0 as? UIWindowScene})
                .compactMap({$0})
                .first?.windows
                .filter({$0.isKeyWindow}).first
            
            return keyWindow
        } else {
            
            return UIApplication.shared.keyWindow
        }
    }
}

//
//  Popupable.swift
//  SwiftyPopup
//
//  Created by Mark G on 4/17/20.
//

import UIKit

public protocol Popupable: UIView {
    associatedtype ResultType
    
    var navigation: PopupNavigation<ResultType>! { get set }
    var shouldDismissOnBackgroundTap: Bool { get }
    var dimmedMaskAlpha: CGFloat { get }
    var maskType: PopupMaskType { get }
    var style: PopupStyle { get }
    var minHorizontalSpacing: CGFloat { get }
    var minVerticalSpacing: CGFloat { get }
    
    func onBackgroundTap()
    func onDismiss()
}

public extension Popupable {
    var dimmedMaskAlpha: CGFloat { 0.5 }
    var maskType: PopupMaskType { .dimmed }
    var shouldDismissOnBackgroundTap: Bool { true }
    var style: PopupStyle { .center }
    var minHorizontalSpacing: CGFloat { 40 }
    var minVerticalSpacing: CGFloat { 100 }
    
    func onDismiss() {}
}

// Void
public extension Popupable where ResultType == Void {
    
    func onBackgroundTap() {
        
        guard shouldDismissOnBackgroundTap else { return }
        navigation.pop(())
    }
}


// Bool
public extension Popupable where ResultType == Bool {
    func onBackgroundTap() {
        
        guard shouldDismissOnBackgroundTap else { return }
        navigation.pop(false)
    }
}

// Typealias
public typealias PopupMaskType = PopupView.MaskType

//
//  Component.swift
//  test
//
//  Created by Mark G on 3/20/20.
//  Copyright © 2020 Mark G. All rights reserved.
//
#if os(iOS)
import UIKit

open class Component: UIView, Componentable {

    public var parent: Component? {
        guard var parent = self.subviews.first else { return nil }
        
        while !(parent is Component) {
            
            guard parent.subviews.first != nil else {
                return nil
            }
            
            parent = parent.subviews.first!
        }
        
        return parent as? Component
    }
    
    // Content view
    internal var _contentView: View!
    
    // Slots
    open var slots: [Slot] { [Slot]() }
    
    // is loaded
    public private(set) var isLoaded: Bool = false
    
//    open override var backgroundColor: UIColor? {
//        set {
//            _contentView.backgroundColor = newValue
//        }
//
//        get {
//            _contentView.backgroundColor
//        }
//    }
    
    // MARK: - Initialize
    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        _initContentView(size: frame.size)
    }

    override public init(frame: CGRect) {
        super.init(frame: frame)
        _initContentView(size: frame.size)
        
        isLoaded = true
        didLoad()
    }

    public init() {
        super.init(frame: .zero)
        _initContentView(size: .zero)
        
        isLoaded = true
        didLoad()
    }

    override open func awakeFromNib() {
        super.awakeFromNib()
        _fillSlots()
        
        isLoaded = true
        didLoad()
    }
    
    open func didLoad() {}
    open func didAppear() {}
    open func didDisappear() {}
    
    open override func willMove(toWindow newWindow: UIWindow?) {
        super.willMove(toWindow: newWindow)
        
        guard newWindow != nil else  {
            didDisappear()
            
            return
        }
        
        didAppear()
    }
    
    func _initContentView(size: CGSize) {
       __initContentView(size: size)
    }
    
    func _fillSlots(
        _ view: View? = nil,
        _ mappedSlots: [String:View]? = nil
    ) {
        __fillSlots(view, mappedSlots)
    }
}


#elseif os(macOS)
open class NSComponent: NSView, Componentable {
    
    public var parent: NSComponent? {
        guard var parent = self.subviews.first else { return nil }
        
        while !(parent is NSComponent) {
            
            guard parent.subviews.first != nil else {
                return nil
            }
            
            parent = parent.subviews.first!
        }
        
        return parent as? NSComponent
    }
    
    // Content view
    internal var _contentView: View!
    
    // Slots
    open var slots: [Slot] { [Slot]() }
    
    // is loaded
    public private(set) var isLoaded: Bool = false
    
    // MARK: - Initialize
    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        _initContentView(size: frame.size)
    }
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
        _initContentView(size: frame.size)
        
        isLoaded = true
        didLoad()
    }
    
    public init() {
        super.init(frame: .zero)
        _initContentView(size: .zero)
        
        isLoaded = true
        didLoad()
    }
    
    override open func awakeFromNib() {
        super.awakeFromNib()
        _fillSlots()
        
        isLoaded = true
        didLoad()
    }
    
    open override func viewWillMove(toWindow newWindow: NSWindow?) {
        super.viewWillMove(toWindow: newWindow)
        
        guard newWindow != nil else  {
            didDisappear()
            
            return
        }
        
        didAppear()
    }
    
    open func didLoad() {}
    open func didAppear() {}
    open func didDisappear() {}
    
    func _initContentView(size: CGSize) {
        __initContentView(size: size)
    }
    
    
    
    func _fillSlots(
        _ view: View? = nil,
        _ mappedSlots: [String:View]? = nil
    ) {
        __fillSlots(view, mappedSlots)
    }
}
#endif

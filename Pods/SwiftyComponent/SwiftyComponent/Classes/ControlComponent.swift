//
//  ControlComponent.swift
//  Pods-SwiftyComponent_Example
//
//  Created by Mark G on 3/22/20.
//

#if os(iOS)
import UIKit

open class ControlComponent: UIControl, Componentable {
    
    // Content view
    var _contentView: UIView!
    
    // Button
    var _button: UIButton!
    
    // Slots
    open var slots: [Slot] { [Slot]() }
    
    // MARK: - Initialize
    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        _initContentView(size: frame.size)
    }
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
        _initContentView(size: frame.size)
        didLoad()
    }
    
    public init() {
        super.init(frame: .zero)
        _initContentView(size: .zero)
        didLoad()
    }
    
    override open func awakeFromNib() {
        super.awakeFromNib()
        _fillSlots()
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
        _initButton()
    }
    
    func _fillSlots(_ view: UIView? = nil, _ mappedSlots: [String:UIView]? = nil) {
        __fillSlots(view, mappedSlots)
    }
    
    func _initButton() {
        _button = UIButton(frame: bounds)
        _button.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        addSubview(_button)
        
        
        _button.addTarget(self, action:#selector(_touchUpInside) , for: .touchUpInside)
    }
    
    @objc func _touchUpInside() {
        sendActions(for: .touchUpInside)
    }
}

#endif

//@IBDesignable

//
//  SlotComponent.swift
//  test
//
//  Created by Mark G on 3/20/20.
//  Copyright © 2020 Mark G. All rights reserved.
//

#if os(iOS)
import UIKit
#elseif os(macOS)
import Cocoa
#endif

@propertyWrapper
public struct Slot {
    public let name: String
    
    public weak var value: View!
    public var wrappedValue: View! {
        set {
            value = newValue
        }
        
        get {
            value
        }
    }
    
    public init(_ name: String) {
        self.name = name
    }
}


// MARK: - SlotComponent
//@IBDesignable
open class SlotComponent: View {
    
    private var _isInterfaceBuilder = false
    var isFilled: Bool = false
    
    // Slot name
    private var _name: String? = nil
    @IBInspectable public var name: String {
        get {
            assert(_name != nil && _name!.count > 0, "Slot name is required")
            return _name!
        }
        
        set {
            _name = newValue
        }
    }
    
    @IBInspectable public var isDynamicHeight: Bool = false
    
    open override func awakeFromNib() {
        super.awakeFromNib()
        
        // Clear background on slot
        #if os(iOS)
        backgroundColor = .clear
        #elseif os(macOS)
        layer?.backgroundColor = .clear
        #endif
    }
    
    
    // MARK: - Interface Builder
    open override func draw(_ rect: CGRect) {
        
        #if TARGET_INTERFACE_BUILDER
        let name = _name ?? "unnamed"
        
        // Background
        let background = View(frame: CGRect(origin: .zero, size: rect.size))
        background.layer.cornerRadius = 12
        background.layer.borderColor = UIColor(red: 241/255, green: 243/255, blue: 244/255, alpha: 1.0).cgColor
        background.layer.borderWidth = 1
        background.backgroundColor = UIColor(red: 204/255, green: 240/255, blue: 225/255, alpha: 1.0)
        addSubview(background)
        
        // name
        var label = UILabel(frame: .zero)
        label.text = "\(name)"
        label.sizeToFit()
        label.center = CGPoint(x: rect.width / 2, y: rect.height / 2)
        addSubview(label)
        
        // slot
        let height = label.frame.height
        label = UILabel(frame: .zero)
        label.textAlignment = .center
        label.text = "{ slot: \(Int(rect.size.width))w x \(Int(rect.size.height))h }"
        label.sizeToFit()
        label.font = .systemFont(ofSize: 12)
        label.textColor = UIColor(red: 94/255, green: 103/255, blue: 105/255, alpha: 1.0)
        label.center = CGPoint(x: rect.width / 2, y: rect.height / 2 + height)
        addSubview(label)
        #endif
    }
}

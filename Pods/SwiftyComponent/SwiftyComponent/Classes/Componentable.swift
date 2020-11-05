//
//  Componentable.swift
//  Pods-SwiftyComponent_Example
//
//  Created by Mark G on 3/24/20.
//

#if os(iOS)
import UIKit
public typealias View = UIView
public typealias Window = UIWindow
public typealias Control = UIControl
public typealias Color = UIControl
#elseif os(macOS)
import Cocoa
public typealias View = NSView
public typealias Window = NSWindow
public typealias Control = NSControl
public typealias Color = NSColor
#endif

protocol Componentable: View {
    var _nibName: String { get }
    var _contentView: View! { get set }
    var _mappedSlots: [String:View] { get }
    var slots: [Slot] { get }
    
    func didLoad()
    func didAppear()
    func didDisappear()
    func _initContentView(size: CGSize)
    func _fillSlots(_ view: View?, _ mappedSlots: [String:View]?)
}

extension Componentable {
    var _nibName: String {
        return  String(NSStringFromClass(type(of: self)).split(separator: ".").last!)
    }
    
    var _mappedSlots: [String:View] {
        var mappedSlots = [String:View]()
        for slot in slots {
            mappedSlots[slot.name] = slot.wrappedValue
        }
        
        return mappedSlots
    }
    
    func __initContentView(size: CGSize) {
        
        let bundle = Bundle(for: type(of: self))
        #if os(iOS)
        let nib = bundle.loadNibNamed(_nibName, owner: self, options: nil)
        _contentView = nib?.first as? View
        #elseif os(macOS)
        var nib: NSArray?
        bundle.loadNibNamed(_nibName, owner: self, topLevelObjects: &nib)
        _contentView = nib?.first { $0 is NSView } as? View
        #endif
        
        
        
        
        // Assign bound from ui to container
        // when size is zero
        var size = size
        if size == .zero {
            frame = _contentView.bounds
            size = _contentView.bounds.size
        }
        
        // Update ui with size
        _contentView.frame = CGRect(origin: .zero, size: size)
        
        // Fill parent
        #if os(iOS)
        _contentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        #elseif os(macOS)
        _contentView.autoresizingMask = [.width, .height]
        #endif
        
        // Add to container
        addSubview(_contentView)
        
        // Clear background to container
        #if os(iOS)
        backgroundColor = .clear
        #elseif os(macOS)
        layer?.backgroundColor = .clear
        #endif
        
    }
    
    func __fillSlots(
        _ view: View? = nil,
        _ mappedSlots: [String:View]? = nil
    ) {
        
        
        var mappedSlots: [String:View]! = mappedSlots ?? _mappedSlots
        guard mappedSlots.count > 0 else { return }
        
        let view: View! = view ?? _contentView
        
        // Fill slots
        for subview in view.subviews {
            
            // Stop filling when no more slot to fill
            guard mappedSlots.count > 0 else { return }
            
            // Looking deeper into this subview
            // if it's not `SlotComponent`
            guard
                let slotComponent = subview as? SlotComponent,
                !slotComponent.isFilled
                else {
                    __fillSlots(subview, mappedSlots)
                    continue
            }
            
            
            // Get content that will be added to this slot
            guard let content = mappedSlots.removeValue(forKey: slotComponent.name)
                else {
                    
                    //TODO: Remove unfill slots
                    continue
            }
            
            // Clear background
            #if os(iOS)
            content.backgroundColor = .clear
            #elseif os(macOS)
            content.layer?.backgroundColor = .clear
            #endif
            
            // Fill parent for content
            content.frame = slotComponent.bounds
            
            #if os(iOS)
            content.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            #elseif os(macOS)
            content.autoresizingMask = [.width, .height]
            #endif
            
            
            // Add content to slot
            slotComponent.addSubview(content)
            slotComponent.isFilled = true
        }
    }
}


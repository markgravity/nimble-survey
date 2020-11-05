//
//  ReactComponent.swift
//  SwiftyComponent
//
//  Created by Mark G on 3/21/20.
//

#if os(iOS)
import UIKit
import Promises

@objc public protocol ReactComponentDelegate {
    func react(
        _ react: ReactComponent,
        by trigger: UIView,
        didCompleteWith error: Error?
    )
}

public protocol Reactable {
    func react() -> Promise<Void>
}

open class ReactComponent: NSObject {
    @IBOutlet
    public weak var delegate: ReactComponentDelegate?
    
    @IBAction
    public func trigger(_ sender: Any) {
        react(sender as! UIView)
            .then { [weak self] _ in
                guard let `self` = self else { return }
                self.delegate?.react(
                    self,
                    by: sender as! UIView,
                    didCompleteWith: nil
                )
        }
        .catch { [weak self] in
            guard let `self` = self else { return }
            self.delegate?.react(
                self,
                by: sender as! UIView,
                didCompleteWith: $0
            )
        }
        
        
    }
    
    // Only support touchUpInside
    @IBOutlet
    public var triggers: [AnyObject]! {
        didSet {
            _configure(triggers)
        }
    }
    
    
    open func react(_ trigger: UIView? = nil) -> Promise<Void> {
        Promise {}
    }
    
    func _configure(_ triggers: [AnyObject]) {
        for trigger in triggers {
            
            // Trigger is a UIControl
            if let control = trigger as? UIControl {
                control.addTarget(self, action: #selector(trigger(_:)), for: .touchUpInside)
                continue
            }
            
            // Trigger is a UIGestureRecognizer
            if let recognizer = trigger as? UIGestureRecognizer {
                recognizer.addTarget(self, action: #selector(trigger(_:)))
                continue
            }
        }
    }
}


public extension Promise where Value == Void {
    func fulfill() {
        fulfill(())
    }
}
#endif

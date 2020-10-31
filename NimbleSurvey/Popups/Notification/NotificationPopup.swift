//
//  NotificationPopup.swift
//  NimbleSurvey
//
//  Created by Mark G on 31/10/2020.
//

import UIKit
import SwiftyComponent
import SwiftyPopup
import RxSwift

class NotificationPopup: Component, Popupable {
    typealias ResultType = Void
    
    fileprivate let _title: String
    fileprivate let _message: String
    fileprivate var _timer: Timer?
    
    var navigation: PopupNavigation<ResultType>!
    var maskType: PopupMaskType = .init(rawValue: 0)
    var style: PopupStyle = .top
    var shouldDismissOnBackgroundTap: Bool = false
    
    /// Outlets
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var messageLabel: UILabel!
    
    init(title: String, message: String) {
        _title = title
        _message = message
        super.init()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func didLoad() {
        titleLabel.text = _title
        messageLabel.text = _message
        
        _autoDismiss()
    }
    
    @IBAction func onTap(_ sender: Any) {
        _timer?.invalidate()
        navigation.pop()
    }
}

// MARK: - Public
extension NotificationPopup {
    
}

// MARK: - Private
fileprivate extension NotificationPopup {
    
    func _autoDismiss() {
        _timer = Timer.scheduledTimer(
            withTimeInterval: 3,
            repeats: false,
            block: { [weak self] _ in
                
                guard let `self` = self
                else { return }
                self.navigation.pop()
        })
        
    }
}

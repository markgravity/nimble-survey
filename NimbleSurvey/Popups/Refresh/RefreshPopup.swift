//
//  RefreshPopup.swift
//  NimbleSurvey
//
//  Created by Mark G on 01/11/2020.
//

import UIKit
import SwiftyComponent
import SwiftyPopup
import RxSwift

class RefreshPopup: Component, Popupable {
    typealias ResultType = Void
    var navigation: PopupNavigation<ResultType>!
    var maskType: PopupMaskType = .clear
    var shouldDismissOnBackgroundTap: Bool = false
    var style: PopupStyle = .top
    
    @IBOutlet weak var activityIndicatorView: UIActivityIndicatorView!
    
    override func didLoad() {
        activityIndicatorView.startAnimating()
    }
    
    func dismiss() {
        activityIndicatorView.stopAnimating()
        navigation.pop()
    }
}

// MARK: - Public
extension RefreshPopup {
    
}

// MARK: - Private
fileprivate extension RefreshPopup {
    
}

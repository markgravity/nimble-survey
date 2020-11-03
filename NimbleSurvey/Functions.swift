//
//  Functions.swift
//  NimbleSurvey
//
//  Created by Mark G on 31/10/2020.
//

import UIKit
import SwiftyBase

func alert(_ message: String, handler: VoidHandler? = nil) {
    let controller = UIAlertController(
        title: "alert.title_text".trans(),
        message: message,
        preferredStyle: .alert
    )
    
    // Ok
    let action = UIAlertAction(title: "alert.ok_text".trans(), style: .cancel) { _ in
        handler?()
    }
    controller.addAction(action)
    
    guard let window = UIApplication.shared.windows.filter({$0.isKeyWindow}).first
    else { return }
    window.rootViewController?.present(
        controller,
        animated: true,
        completion: nil
    )
}

func alert(_ error: Error,_ handler: VoidHandler? = nil) {
    
    var message = "alert.common_error_msg".trans()
    
    #if DEBUG
    message = (error as NSError).localizedDescription
    #else
    
    // Localized Error
    if let localizedError = error as? LocalizedError {
        message = localizedError.errorDescription ?? message
    }
    #endif
    alert(
        message,
        handler: handler
    )
}

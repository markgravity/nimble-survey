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
        title: "alert.title_text",
        message: message,
        preferredStyle: .alert
    )
    
    guard let window = UIApplication.shared.windows.filter({$0.isKeyWindow}).first
    else { return }
    window.rootViewController?.present(
        controller,
        animated: true,
        completion: nil
    )
}

func alert(_ error: Error,_ handler: VoidHandler? = nil) {
    alert(
        (error as NSError).localizedDescription,
        handler: handler
    )
}

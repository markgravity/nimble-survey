//
//  LandingToLoginSegue.swift
//  NimbleSurvey
//
//  Created by Mark G on 02/11/2020.
//

import UIKit

class LandingToLoginSegue: UIStoryboardSegue {
    
    override func perform() {
        guard let window = source.view.window
        else { return }
        
        let destination = self.destination as! UINavigationController
        let source = self.source as! LandingController
        let controller = destination.topViewController as! LoginController
        
        window.addSubview(controller.view)
        
        // Setup login controller
        // Blur View
        let blurView = controller.backgroundView.blurView!
        blurView.alpha = 0
        
        // Content View
        let contentStackView = controller.contentStackView!
        contentStackView.alpha = 0
        
        // Position fixes
        DispatchQueue.main.async {

            // Logo Image
            let logoImageView = controller.logoImageView!
            let originalFrame = logoImageView.frame
            logoImageView.translatesAutoresizingMaskIntoConstraints = true
            logoImageView.frame = source.logoImageView.frame
            
            // Begin animation
            UIView.animate(withDuration: 0.5,   animations: {
                
                logoImageView.frame = originalFrame
                contentStackView.alpha = 1
                blurView.alpha = 1
            }) { _ in
                controller.view.removeFromSuperview()
                window.rootViewController = destination
            }
        }
    }
}

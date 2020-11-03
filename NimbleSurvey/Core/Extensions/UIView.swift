//
//  UIView.swift
//  NimbleSurvey
//
//  Created by Mark G on 02/11/2020.
//

import UIKit

extension UIView {
    func transformTo(_ view: UIView, scale: CGFloat = 1) {
        guard let convertedFrame = superview?.convert(view.frame, from: view.superview) else {
            fatalError("Your views are not correctly added to the hirearchy")
        }
        transform = transformRect(from: frame, to: convertedFrame * scale)
    }
    
    func morphRectTo(_ view: UIView, scale: CGFloat = 1) {
        guard let convertedFrame = superview?.convert(view.frame, from: view.superview) else {
            fatalError("Your views are not correctly added to the hirearchy")
        }
        alpha = view.alpha
        layer.cornerRadius = view.layer.cornerRadius * scale
        frame = convertedFrame * scale
    }
    private func transformRect(from source: CGRect, to destination: CGRect) -> CGAffineTransform {
        return CGAffineTransform.identity
            .translatedBy(x: destination.midX - source.midX,
                          y: destination.midY - source.midY)
            .scaledBy(x: destination.width / source.width,
                      y: destination.height / source.height)
    }
}

fileprivate extension CGRect {
    static func *(lhs: CGRect, rhs: CGFloat) -> CGRect {
        let scaledWidth = lhs.width * rhs
        let scaledHeight = lhs.height * rhs
        let x = lhs.origin.x + (lhs.width - scaledWidth) / 2
        let y = lhs.origin.y + (lhs.height - scaledHeight) / 2
        return CGRect(x: x, y: y, width: scaledWidth, height: scaledHeight)
    }
}

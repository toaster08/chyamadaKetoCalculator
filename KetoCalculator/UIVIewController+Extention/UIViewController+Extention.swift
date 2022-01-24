//
//  File.swift
//  KetoCalculator
//
//  Created by toaster on 2021/11/23.
//

import Foundation
import UIKit

extension UIViewController {
    func animateView(_ viewToAnimate: UIView) {
        UIView.animate(withDuration: 0.2,
                       delay: 0,
                       options: .curveEaseIn,
                       animations: {
                        viewToAnimate
                            .transform = CGAffineTransform(scaleX: 1.08, y: 1.08)
                       }) { _ in
            UIView.animate(withDuration: 0.2,
                           delay: 0,
                           usingSpringWithDamping: 0.3,
                           initialSpringVelocity: 10,
                           options: .curveEaseOut,
                           animations: {
                            viewToAnimate
                                .transform = .identity
                           }, completion: { _ in
                            viewToAnimate.layer.cornerRadius
                                = viewToAnimate.frame.height / 2
            })
        }
    }
}

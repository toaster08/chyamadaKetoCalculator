//
//  UIButton+Extension.swift
//  KetoCalculator
//
//  Created by toaster on 2022/02/06.
//

import Foundation
import UIKit

extension UIButton {
    func animateButtonView() {
        UIView.animate(withDuration: 0.2,
                       delay: 0,
                       options: .curveEaseIn,
                       animations: {
                        self.transform = CGAffineTransform(scaleX: 1.08, y: 1.08)
                       }) { _ in
            UIView.animate(withDuration: 0.2,
                           delay: 0,
                           usingSpringWithDamping: 0.3,
                           initialSpringVelocity: 10,
                           options: .curveEaseOut,
                           animations: {
                            self.transform = .identity
                           }, completion: { _ in
                            self.layer.cornerRadius
                                = self.frame.height / 2
            })
        }
    }
}

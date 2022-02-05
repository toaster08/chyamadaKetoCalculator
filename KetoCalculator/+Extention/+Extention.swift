//
//  File.swift
//  KetoCalculator
//
//  Created by toaster on 2021/11/23.
//

import Foundation
import UIKit

extension UIViewController {
    func presentAlert(title: String, message: String, actionTitle: String) {
        let alertController = UIAlertController(title: title,
                                                message: message,
                                                preferredStyle: .alert)
        let alertAction = UIAlertAction(title: actionTitle,
                                        style: .default,
                                        handler: nil)
        alertController.addAction(alertAction)
        present(alertController, animated: true, completion: nil)
    }
}

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

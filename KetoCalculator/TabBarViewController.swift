//
//  TabBarViewController.swift
//  KetoCalculator
//
//  Created by toaster on 2021/12/14.
//

import UIKit

final class TabBarViewController: UITabBarController, UITabBarControllerDelegate {
    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
        tabBar.unselectedItemTintColor = #colorLiteral(red: 1, green: 0.4932718873, blue: 0.4739984274, alpha: 1)
    }

    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        if viewController is CalculatorViewController {
            tabBarController.tabBar.barTintColor = UIColor(named: "MainTabBarTintColor")
            tabBarController.tabBarItem.badgeColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
            tabBar.unselectedItemTintColor = #colorLiteral(red: 1, green: 0.4932718873, blue: 0.4739984274, alpha: 1)
        }

        if viewController is SettingViewController {
            tabBarController.tabBar.barTintColor = UIColor(named: "SettingTabBarTintColor")
            tabBarController.tabBarItem.badgeColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
            tabBar.unselectedItemTintColor = #colorLiteral(red: 0, green: 0.5898008943, blue: 1, alpha: 1)
        }
    }
}

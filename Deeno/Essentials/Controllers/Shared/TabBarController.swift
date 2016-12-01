//
//  TabBarController.swift
//  Deeno
//
//  Created by Michal Severín on 23.11.16.
//  Copyright © 2016 Michal Severín. All rights reserved.
//

import UIKit

/**
 Tab bar protocol
 */
protocol TabBarProtocol {
    var controller: UIViewController {get}
    var image: UIImage? {get}
    var selectedImage: UIImage? {get}
    var title: String? {get}
}

class TabBarController: AbstractTabBarController {

    private enum Controllers: TabBarProtocol {

        case account
        case messages
        case rides

        static let allCases: [Controllers] = [.rides, .messages, .account]

        var controller: UIViewController {
            switch self {
            case .account:
                return AccountViewController()
            case .messages:
                return MessageListViewController()
            case .rides:
                return RidesViewController()
            }
        }

        var image: UIImage? {
            switch self {
            case .account:
                return #imageLiteral(resourceName: "user")
            case .messages:
                return #imageLiteral(resourceName: "msg")
            case .rides:
                return #imageLiteral(resourceName: "car")
            }
        }

        var selectedImage: UIImage? {
            switch self {
            case .account:
                return #imageLiteral(resourceName: "user")
            case .messages:
                return #imageLiteral(resourceName: "msg")
            case .rides:
                return #imageLiteral(resourceName: "car")
            }
        }

        var title: String? {
            switch self {
            case .account:
                return "You"
            case .messages:
                return "Messages"
            case .rides:
                return "Rides"
            }
        }
    }

    // MARK: - <Initialize>
    override func setupView() {
        super.setupView()

        tabBar.barTintColor = Palette[.tabBar]
        tabBar.tintColor = Palette[.black]
    }

    internal override func customInit() {
        super.customInit()

        var controllers: [UIViewController] = []
        for controller in Controllers.allCases {
            let navigationController = UINavigationController(rootViewController: controller.controller)
            navigationController.navigationBar.applyStyle(style: .solid(withStatusBarColor: Palette[.primary]))
            navigationController.tabBarItem.title = controller.title
            navigationController.tabBarItem.image = controller.image
            navigationController.tabBarItem.selectedImage = controller.selectedImage
            controllers.append(navigationController)
        }
        viewControllers = controllers
    }
}

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
        case map
        case rides

        static let allCases: [Controllers] = [.rides, .map, .account]

        var controller: UIViewController {
            switch self {
            case .account:
                return AccountViewController()
            case .map:
                return MapViewController()
            case .rides:
                return RidesViewController()
            }
        }

        var image: UIImage? {
            return nil
        }

        var selectedImage: UIImage? {
            return nil
        }

        var title: String? {
            switch self {
            case .account:
                return "You"
            case .map:
                return "Map"
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
            navigationController.navigationBar.applyStyle(style: .black)
            navigationController.tabBarItem.title = controller.title
            navigationController.tabBarItem.image = controller.image
            navigationController.tabBarItem.selectedImage = controller.selectedImage
            controllers.append(navigationController)
        }
        viewControllers = controllers
    }
}

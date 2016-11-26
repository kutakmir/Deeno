//
//  AppDelegate.swift
//  Deeno
//
//  Created by Michal Severín on 22.11.16.
//  Copyright © 2016 Michal Severín. All rights reserved.
//

import DigitsKit
import Fabric
import Firebase
import Crashlytics
import UIKit
import CoreData

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {

        initializeRootVC()
        initializeAnalytics()
        initializeFirebase()

        return true
    }

    func applicationWillTerminate(_ application: UIApplication) {
        self.saveContext()
    }

    // MARK: - Core Data stack
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "Deeno")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    // MARK: - Core Data Saving support
    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }

    // MARK: - Initialization
    fileprivate func initializeRootVC() {
        let navigation: UINavigationController

        window = UIWindow(frame: UIScreen.main.bounds)
        // TODO
//            navigation = UINavigationController(rootViewController: TabBarController())
//        }
//        else {
            navigation = UINavigationController(rootViewController: LoginViewController())
//        }
        navigation.navigationBar.applyStyle(style: .invisible(withStatusBarColor: Palette[.clear]))
        window?.rootViewController = navigation
        window?.makeKeyAndVisible()
    }

    fileprivate func initializeAnalytics() {
        Fabric.with([Crashlytics.self, Digits.self])
    }

    fileprivate func initializeFirebase() {
        FIRApp.configure()
    }
}

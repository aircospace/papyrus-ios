//
//  AppDelegate.swift
//  Papyrus
//
//  Created by Jean Paul Marinho on 29/07/17.
//  Copyright © 2017 aKANJ. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        MCManager.shared.start()
        return true
    }
}

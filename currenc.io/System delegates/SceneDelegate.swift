//
//  SceneDelegate.swift
//  currenc.io
//
//  Created by Ostap on 02.04.2020.
//  Copyright © 2020 Ostap Tyvonovych. All rights reserved.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
           if let windowScene = scene as? UIWindowScene {
               let window = UIWindow(windowScene: windowScene)
               window.rootViewController = UINavigationController(rootViewController: CurrencyRateViewController())
               window.makeKeyAndVisible()
               
               self.window = window
           }
    }
}


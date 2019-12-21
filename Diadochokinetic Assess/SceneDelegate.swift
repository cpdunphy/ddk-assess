//
//  SceneDelegate.swift
//  Diadochokinetic Assess
//
//  Created by Collin on 12/1/19.
//  Copyright © 2019 Ballygorey Apps. All rights reserved.
//

import UIKit
import SwiftUI

let defaults = UserDefaults.standard
let countdownKey = "CountdownTime"
let setDefaultsKey = "UserDefaultsSet"
let showOnboardingKey = "showOnboardingScreen"
let secondsKey = "secondsFromLast"
let heartRateKey = "showHeartRate"
let userLogCountKey = "userLogCount"
let userLogCountLifetimeKey = "userLogCountTOTAL"
let pushNewOnboardingKey = "CurrentBuildVersion"
let buildNum = "Beta2"
let Screen = UIScreen.main.bounds

var userTotalCount = 0

public var regularTextSize: CGFloat = 17

let advertisingGap = 75

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
//        defaults.set(true, forKey: showOnboardingKey)
        if buildNum != defaults.string(forKey: pushNewOnboardingKey) {
            defaults.set(buildNum, forKey: pushNewOnboardingKey)
            defaults.set(true, forKey: showOnboardingKey)
            print("StartingOnboarding")
        } else {
            print("no need to onboard")
        }
        
//        defaults.set(true, forKey: showOnboardingKey)
        if defaults.bool(forKey: setDefaultsKey) == false {
            print("firstTimeLoading")
            defaults.set(3, forKey: countdownKey)
            defaults.set(true, forKey: showOnboardingKey)
            defaults.set(5, forKey: secondsKey)
            defaults.set(false, forKey: heartRateKey)
            defaults.set(0, forKey: userLogCountKey)
            defaults.set(true, forKey: setDefaultsKey)
        } else {
            print("no need to set User defaults")
        }
        
        //Initialize IAPs
        ProductsStore.shared.initializeProducts()
        
        // Create the SwiftUI view that provides the window contents.
        let contentView = TabBarViewController(productsStore: ProductsStore.shared).environmentObject(TimerSession())
//        let contentView = IAPTestingView(productsStore: ProductsStore.shared)
        // Use a UIHostingController as window root view controller.
        if let windowScene = scene as? UIWindowScene {
            let window = UIWindow(windowScene: windowScene)
            window.rootViewController = UIHostingController(rootView: contentView)
            self.window = window
            window.makeKeyAndVisible()
        }
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not neccessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
    }


}


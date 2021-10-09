//
//  AppDelegate.swift
//  Health
//
//  Created by Даниил Марусенко on 02.02.2021.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    // - UI
    var window: UIWindow?
    
    // - CBNab
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
//        let window = UIWindow(frame: UIScreen.main.bounds)
        
        if #available(iOS 15, *) {
            let appearance = UITabBarAppearance()
            let navigationBar = UITabBar()
            appearance.configureWithOpaqueBackground()
            navigationBar.standardAppearance = appearance
            UITabBar.appearance().scrollEdgeAppearance = appearance
        }
                
        self.window?.rootViewController = casualRootVC()
        return true
    }
    
    func casualRootVC() -> UIViewController {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "Main")
        return vc
    }
    
}

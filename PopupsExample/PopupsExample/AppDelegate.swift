//
//  AppDelegate.swift
//  PopupsExample
//
//  Created by Oleg Adamov on 14.10.2020.
//

import UIKit
import Popups

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = ViewController()
        window?.makeKeyAndVisible()
        
        PopupConfig.setup(colors: ExampleColors())
        
        return true
    }
}


class ExampleColors: PopupColors {
    
    var background: UIColor { return UIColor(named: "background")! }
    
    var separator: UIColor { return UIColor(named: "separator")! }
    
    var title: UIColor { return UIColor(named: "title")! }
    
    var subtitle: UIColor { return UIColor(named: "subtitle")! }
    
    var destructive: UIColor { return UIColor(named: "destructive")! }
    
    var buttonText: UIColor { return UIColor(named: "title")! }
    
    var textfieldIcon: UIColor { return UIColor(named: "title")! }
    
    var textfieldPlaceholder: UIColor { return UIColor(named: "textfield_placeholder")! }
    
    var textfieldText: UIColor { return UIColor(named: "title")! }
}

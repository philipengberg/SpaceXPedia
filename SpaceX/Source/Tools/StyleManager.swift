//
//  StyleManager.swift
//  SpaceX
//
//  Created by Philip Engberg on 20/08/2018.
//  Copyright © 2018 Simple Sense. All rights reserved.
//

import Foundation
import UIKit

struct Style {
    struct appearance {
        
        static func applyTranslucentNavigationBarAppearance(to navigationBar: UINavigationBar?) {
            navigationBar?.backgroundColor = .clear
            navigationBar?.barTintColor = .clear
            navigationBar?.shadowImage = UIImage()
            navigationBar?.isTranslucent = false
        }
        
        static func applyDefaultNavigationBarAppearance(to navigationBar: UINavigationBar?) {
            navigationBar?.backgroundColor = #colorLiteral(red: 0.03137254902, green: 0.3254901961, blue: 0.5254901961, alpha: 1)
            navigationBar?.barTintColor = #colorLiteral(red: 0.03137254902, green: 0.3254901961, blue: 0.5254901961, alpha: 1)
            navigationBar?.isTranslucent = false
            navigationBar?.barStyle = .black
        }
        
        static func setUpAppearance() {
            UINavigationBar.appearance().tintColor = UIColor.white
            UINavigationBar.appearance().shadowImage = UIImage()
            
            UINavigationBar.appearance().titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white]
            
            applyDefaultNavigationBarAppearance(to: UINavigationBar.appearance())
            
//            UITabBar.appearance().tintColor = .primaryColor
//            UITabBar.appearance().barTintColor = .darkBlueBackgroundColor
            
//            UITabBarItem.appearance().setTitleTextAttributes([NSAttributedStringKey.font: font.light(size: 10)], for: .normal)
//            UITabBarItem.appearance().setTitleTextAttributes([NSAttributedStringKey.foregroundColor: UIColor.white], for: .normal)
//            UITabBarItem.appearance().setTitleTextAttributes([NSAttributedStringKey.foregroundColor: UIColor.primaryColor], for: .selected)
            
//            UILabel.appearance(whenContainedInInstancesOf: [UITableViewHeaderFooterView.self]).font = .light(size: 12)
            
//            UIBarButtonItem.appearance(whenContainedInInstancesOf: [UINavigationBar.self]).setTitleTextAttributes([NSAttributedStringKey.foregroundColor: UIColor.white,
//                                                                                                                   NSAttributedStringKey.font: UIFont.regular(size: 17)], for: .normal)
//            UIBarButtonItem.appearance(whenContainedInInstancesOf: [UINavigationBar.self]).setBackgroundImage(UIImage.image(with: UIColor.clear), for: .normal, barMetrics: .default)
        }
        
    }
}

extension UIColor {
    static let lightTextColor = #colorLiteral(red: 0.5647058824, green: 0.5647058824, blue: 0.5647058824, alpha: 1)
    static let failedColor = #colorLiteral(red: 0.8274509804, green: 0.2352941176, blue: 0.2352941176, alpha: 1)
    static let succeededColor = #colorLiteral(red: 0.368627451, green: 0.8274509804, blue: 0.2352941176, alpha: 1)
}

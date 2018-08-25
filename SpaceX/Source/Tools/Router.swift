//
//  Router.swift
//  SpaceX
//
//  Created by Philip Engberg on 20/08/2018.
//  Copyright © 2018 Simple Sense. All rights reserved.
//

import Foundation
import JLRoutes
import SafariServices

class Router {
    
    private enum PresentationStyle {
        case push(forceFromRoot: Bool)
        case present(dismissCurrentlyPresented: Bool)
        case tab(tab: WindowManager.Tab)
    }
    
    enum Destination {
        case rocketDetail(rocketId: String)
        case launchDetail(launchId: String, launch: Launch?)
        case launchSite(siteId: String)
        case web(url: URL)
    }
    
    @discardableResult
    static func route(to url: URL) -> Bool {
        print("Routing: \(url)")
        return JLRoutes.routeURL(url)
    }
    
    @discardableResult
    static func route(to destination: Destination) -> Bool {
        switch destination {
            
        case .rocketDetail(let rocketId):
            return Router.Internal.show(viewController: RocketDetailViewController(viewModel: RocketDetailViewModel(rocketId: rocketId)), with: .push(forceFromRoot: false))
            
        case .launchDetail(let launchId, let launch):
            return Router.Internal.show(viewController: LaunchDetailViewController(viewModel: LaunchDetailViewModel(launchId: launchId, launch: launch)), with: .push(forceFromRoot: false))
            
        case .launchSite(let siteId):
            return Router.Internal.show(viewController: LaunchSiteViewController(viewModel: LaunchSiteViewModel(launchSiteId: siteId)), with: .push(forceFromRoot: false))
            
        case .web(let url):
            let safariViewController = SFSafariViewController(url: url)
            WindowManager.topMostViewController()?.present(safariViewController, animated: true, completion: nil)
            return true
        }
    }
    
    private struct Internal {
        static func show(viewController: UIViewController?, with presentationStyle: PresentationStyle, completion: (() -> Void)? = nil) -> Bool {
            
            switch presentationStyle {
            case .push(let forceFromRoot):
                guard let viewCon = viewController else { return false }
                
                let topMostNavigationController = WindowManager.topMostNavigationController()
                
                if forceFromRoot { let _ = topMostNavigationController?.popToRootViewController(animated: false) }
                topMostNavigationController?.pushViewController(viewCon, animated: true, completion: completion)
                
            case .present(let dismissCurrentlyPresented):
                guard let viewCon = viewController else { return false }
                
                if dismissCurrentlyPresented {
                    if let top = WindowManager.topMostViewController() {
                        if top.presentingViewController != nil {
                            top.dismiss(animated: false, completion: { () -> Void in
                                WindowManager.topMostViewController()?.present(viewCon, animated: true, completion: completion)
                            })
                        } else {
                            top.present(viewCon, animated: true, completion: completion)
                        }
                    }
                } else {
                    WindowManager.topMostViewController()?.present(viewCon, animated: true, completion: completion)
                }
                
            case .tab(let tab):
                guard let tabController = WindowManager.shared.tabBarController, let index = WindowManager.shared.tabs.index(of: tab) else { return false }
                if let top = WindowManager.topMostViewController(), top.presentingViewController != nil {
                    top.dismiss(animated: true, completion: nil)
                    tabController.selectedIndex = index
                    completion?()
                } else {
                    tabController.selectedIndex = index
                    completion?()
                }
            }
            
            return true
        }
    }
}

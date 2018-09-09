//
//  SideMenuViewModel.swift
//  SpaceX
//
//  Created by Philip Engberg on 09/09/2018.
//  Copyright © 2018 Simple Sense. All rights reserved.
//

import Foundation
import RxSwift

class SideMenuViewModel {
    
    struct SideMenuItem {
        let type: String
        let name: String
        let tab: WindowManager.Tab
    }
    
    var selectedIndex: Int = 1
    
    let items: [SideMenuItem] = ([SideMenuItem(type: "👨‍🚀", name: "Starman Roadster", tab: .launches),
                                  SideMenuItem(type: "☄️", name: "Launches", tab: .launches),
                                  SideMenuItem(type: "🚀", name: "Rockets", tab: .rockets),
                                  SideMenuItem(type: "💄", name: "Cores", tab: .launches),
                                  SideMenuItem(type: "📦", name: "Payloads", tab: .launches),
                                  SideMenuItem(type: "💎", name: "Capsules", tab: .launches),
                                  SideMenuItem(type: "🐲", name: "Dragons", tab: .launches),
                                  SideMenuItem(type: "⛴", name: "Ships", tab: .launches),
                                  SideMenuItem(type: "🏢", name: "Company", tab: .launches),
                                  SideMenuItem(type: "📖", name: "History", tab: .launches),
                                  SideMenuItem(type: "🤔", name: "About", tab: .launches)])
    
}

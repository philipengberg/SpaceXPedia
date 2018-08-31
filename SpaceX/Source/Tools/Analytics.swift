//
//  Analytics.swift
//  SpaceX
//
//  Created by Philip Engberg on 30/08/2018.
//  Copyright © 2018 Simple Sense. All rights reserved.
//

import Amplitude_iOS
import Foundation

struct Analytics {
    
    static func initialize() {
        Amplitude.instance().initializeApiKey("c7e86e263339e90ad99faa576385e103")
    }
    
    static func trackLaunchesShown() {
        Amplitude.instance().logEvent("Launches shown")
    }
    
    static func trackLaunchDetailShown(for launch: Launch) {
        Amplitude.instance().logEvent("Launch detail shown", withEventProperties: ["Launch name": launch.missionName])
    }
    
    static func trackLaunchSiteShown(for launchSite: LaunchSite) {
        Amplitude.instance().logEvent("Launch site shown", withEventProperties: ["Launch site name": launchSite.fullName])
    }
    
    static func trackRocketDetailShown(for rocket: Rocket) {
        Amplitude.instance().logEvent("Rocket detail shown", withEventProperties: ["Rocket name": rocket.name])
    }
    
    static func trackRoadsterShown() {
        Amplitude.instance().logEvent("Roadster shown")
    }
    
}

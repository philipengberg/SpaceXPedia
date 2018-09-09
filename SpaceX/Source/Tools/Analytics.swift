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
        Amplitude.instance().logEvent("Launch detail shown", withEventProperties: ["Launch name": launch.missionName, "Is upcoming": launch.launchDate.isUpcoming])
    }
    
    static func trackLaunchSiteShown(for launchSite: LaunchSite) {
        Amplitude.instance().logEvent("Launch site shown", withEventProperties: ["Launch site name": launchSite.fullName])
    }
    
    static func trackRocketDetailShown(for rocket: Rocket) {
        Amplitude.instance().logEvent("Rocket detail shown", withEventProperties: ["Rocket name": rocket.name])
    }
    
    static func trackShipDetailShown(for ship: Ship) {
        Amplitude.instance().logEvent("Ship detail shown", withEventProperties: ["Ship name": ship.shipName])
    }
    
    static func trackCoreDetailShown(for core: Rocket.Core) {
        Amplitude.instance().logEvent("Core detail shown", withEventProperties: ["Core serial": core.coreSerial!])
    }
    
    static func trackRoadsterShown() {
        Amplitude.instance().logEvent("Roadster shown")
    }
    
}

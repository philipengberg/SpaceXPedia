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
        track("Launches shown")
    }
    
    static func trackLaunchDetailShown(for launch: Launch) {
        track("Launch detail shown", properties: ["Launch name": launch.missionName, "Is upcoming": launch.launchDate.isUpcoming])
    }
    
    static func trackLaunchSiteShown(for launchSite: LaunchSite) {
        track("Launch site shown", properties: ["Launch site name": launchSite.fullName])
    }
    
    static func trackRocketDetailShown(for rocket: Rocket) {
        track("Rocket detail shown", properties: ["Rocket name": rocket.name])
    }
    
    static func trackShipDetailShown(for ship: Ship) {
        track("Ship detail shown", properties: ["Ship name": ship.shipName])
    }
    
    static func trackCoreDetailShown(for core: Rocket.Core) {
        track("Core detail shown", properties: ["Core serial": core.coreSerial!])
    }
    
    static func trackCapsuleDetailShown(for capsule: Capsule) {
        track("Capsule detail shown", properties: ["Capsule serial": capsule.capsuleSerial])
    }
    
    static func trackRoadsterShown() {
        track("Roadster shown")
    }
    
    private static func track(_ event: String) {
        #if !targetEnvironment(simulator)
        Amplitude.instance().logEvent(event)
        
        #if DEBUG
        print("Tracking: \"\(event)\"")
        #endif
        #endif
    }
    
    private static func track(_ event: String, properties: [String: Any]) {
        #if !targetEnvironment(simulator)
        Amplitude.instance().logEvent(event, withEventProperties: properties)
        
        #if DEBUG
        print("Tracking: \"\(event)\"" + "\n" + "\(properties.map { "\t\"\($0)\": \($1)" }.joined(separator: "\n"))")
        #endif
        #endif
    }
    
}

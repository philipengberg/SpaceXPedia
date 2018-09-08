//
//  LaunchOverviewCellViewModel.swift
//  SpaceX
//
//  Created by Philip Engberg on 08/09/2018.
//  Copyright © 2018 Simple Sense. All rights reserved.
//

import Foundation
import DateToolsSwift

class LaunchOverviewCellViewModel {
    
    let launch: Launch
    
    init(launch: Launch) {
        self.launch = launch
    }
    
    var missionName: String {
        return launch.missionName
    }
    
    var launchDataText: String? {
        return launch.launchDate.displayName
    }
    
    var vehicleName: String {
        if let firstCoreBlock = launch.rocket.firstStage?.cores.first?.block {
            return "\(launch.rocket.name) Block \(firstCoreBlock) \(coreReuseCountText)"
        } else {
            return "\(launch.rocket.name) \(launch.rocket.version) \(coreReuseCountText)"
        }
    }
    
    private var coreReuseCountText: String {
        guard let firstCoreFlight = launch.rocket.firstStage?.cores.first?.flightNumber else { return "" }
        switch firstCoreFlight {
        case 2: return "♳"
        case 3: return "♴"
        case 4: return "♵"
        case 5: return "♶"
        case 6: return "♷"
        case 7: return "♸"
        case 8: return "♹"
        default: return ""
        }
    }
    
    var countDownText: String? {
        guard launch.launchDate.isUpcoming else { return nil }
        let dateComponentFormatter = DateComponentsFormatter()
        dateComponentFormatter.unitsStyle = .full
        dateComponentFormatter.maximumUnitCount = 2
        return dateComponentFormatter.string(from: TimePeriod(beginning: Date(), end: launch.launchDate.date).duration)
    }
    
    var launchSiteName: String? {
        return launch.site?.siteName
    }
    
    var cores: [Rocket.Core] {
        return launch.rocket.firstStage?.cores ?? []
    }
    
    var payloads: [Rocket.Payload] {
        return launch.rocket.secondStage?.payloads ?? []
    }
    
}

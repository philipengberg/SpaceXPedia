//
//  RoadsterViewModel.swift
//  SpaceX
//
//  Created by Philip Engberg on 30/08/2018.
//  Copyright © 2018 Simple Sense. All rights reserved.
//

import Foundation
import RxSwift

class RoadsterViewModel: ValueViewModel<Roadster> {
    
    private let template = "Elon’s 🚘 is currently <highlight>{earth_distance} km</highlight> away from 🌍 moving at about <highlight>{speed} km/h</highlight> 💨 It orbits the ☀️ every <highlight>{period} days</highlight> at a distance between <highlight>{periapsis}</highlight> and <highlight>{apoapsis} AUs</highlight> 📡 It weighs <highlight>{weight} kg</highlight> and has now spent <highlight>{duration} days</highlight> in space ✨"
    
    private let noDecimalsNumberFormatter = NumberFormatter().setUp {
        $0.numberStyle = .decimal
        $0.maximumFractionDigits = 0
    }
    
    private let decimalsNumberFormatter = NumberFormatter().setUp {
        $0.numberStyle = .decimal
        $0.maximumFractionDigits = 2
    }
    
    let roadsterDescription = Variable<String?>(nil)
    
    init(api: API) {
        super.init(api: api, target: .roadster)
        
        object.asObservable().unwrap().map { [weak self] roadster -> String? in
            guard let s = self else { return nil }
            
            return s.template
                .replacingOccurrences(of: "{earth_distance}", with: s.noDecimalsNumberFormatter.string(from: roadster.earthDistanceKm as NSNumber)!)
                .replacingOccurrences(of: "{speed}", with: s.noDecimalsNumberFormatter.string(from: roadster.speed.kmh as NSNumber)!)
                .replacingOccurrences(of: "{period}", with: s.noDecimalsNumberFormatter.string(from: roadster.periodDays as NSNumber)!)
                .replacingOccurrences(of: "{periapsis}", with: s.decimalsNumberFormatter.string(from: roadster.periapsisAu as NSNumber)!)
                .replacingOccurrences(of: "{apoapsis}", with: s.decimalsNumberFormatter.string(from: roadster.apoapsisAu as NSNumber)!)
                .replacingOccurrences(of: "{weight}", with: s.noDecimalsNumberFormatter.string(from: roadster.launchMass.kilos as NSNumber)!)
                .replacingOccurrences(of: "{duration}", with: s.noDecimalsNumberFormatter.string(from: roadster.launchDate.daysAgo as NSNumber)!)
            
        }.bind(to: roadsterDescription).disposed(by: bag)
    }
}

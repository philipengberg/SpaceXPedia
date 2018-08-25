//
//  Measurements.swift
//  SpaceX
//
//  Created by Philip Engberg on 20/08/2018.
//  Copyright © 2018 Simple Sense. All rights reserved.
//

import Foundation
import SwiftyJSON

struct Distance: Serialization {
    let meters: Double
    let feet: Double
    
    init?(json: JSON) {
        guard json["meters"].exists() && json["feet"].exists() else { return nil }
        self.meters = json["meters"].doubleValue
        self.feet = json["feet"].doubleValue
    }
    
    init(meters: Double, feet: Double) {
        self.meters = meters
        self.feet = feet
    }
    
    static let empty = Distance(meters: 0, feet: 0)
}

struct Weight: Serialization {
    let kilos: Double
    let pounds: Double
    
    init?(json: JSON) {
        guard json["kg"].exists() && json["lb"].exists() else { return nil }
        self.kilos = json["kg"].doubleValue
        self.pounds = json["lb"].doubleValue
    }
    
    init(kilos: Double, pounds: Double) {
        self.kilos = kilos
        self.pounds = pounds
    }
    
    static let empty = Weight(kilos: 0, pounds: 0)
}

struct Thrust: Serialization {
    let kiloNewtons: Double
    let poundsForce: Double
    
    init?(json: JSON) {
        guard json["kN"].exists() && json["lbf"].exists() else { return nil }
        self.kiloNewtons = json["kN"].doubleValue
        self.poundsForce = json["lbf"].doubleValue
    }
    
    init(kiloNewtons: Double, poundsForce: Double) {
        self.kiloNewtons = kiloNewtons
        self.poundsForce = poundsForce
    }
    
    static let empty = Thrust(kiloNewtons: 0, poundsForce: 0)
}
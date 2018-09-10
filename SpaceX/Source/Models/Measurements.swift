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
    
    init?(kilos: Double?, pounds: Double?) {
        guard let kg = kilos, let lbs = pounds else { return nil }
        self.kilos = kg
        self.pounds = lbs
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

struct Speed: Serialization {
    let kmh: Double
    let mph: Double
    
    init?(json: JSON) {
        guard json["speed_kph"].exists() && json["speed_mph"].exists() else { return nil }
        self.kmh = json["speed_kph"].doubleValue
        self.mph = json["speed_mph"].doubleValue
    }
    
    init(kmh: Double, mph: Double) {
        self.kmh = kmh
        self.mph = mph
    }
    
    static let empty = Speed(kmh: 0, mph: 0)
}

struct Position: Serialization {
    let latitude: Double
    let longitude: Double
    
    init?(json: JSON) {
        guard json["latitude"].exists() && json["longitude"].exists() else { return nil }
        self.latitude = json["latitude"].doubleValue
        self.longitude = json["longitude"].doubleValue
    }
    
    init(latitude: Double, longitude: Double) {
        self.latitude = latitude
        self.longitude = longitude
    }
    
    static let empty = Position(latitude: 0, longitude: 0)
}

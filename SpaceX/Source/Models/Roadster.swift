//
//  Roadster.swift
//  SpaceX
//
//  Created by Philip Engberg on 30/08/2018.
//  Copyright © 2018 Simple Sense. All rights reserved.
//

import Foundation
import SwiftyJSON

struct Roadster: Serialization {
    
    let name: String
    let launchDate: Date
    let launchMass: Weight
    let noradId: String
    let orbitType: Rocket.Payload.OrbitParameters.ReferenceSystem
    let apoapsisAu: Double
    let periapsisAu: Double
    let semiMajorAxisAu: Double
    let eccentricity: Double
    let inclination: Double
    let longitude: Double
    let periapsisArg: Double
    let periodDays: Double
    let speed: Speed
    let earthDistanceKm: Double
    let marsDistanceKm: Double
    let wikipedia: URL?
    let details: String
    
    init?(json: JSON) {
        guard let launchDate = DateFormatter.ISO8601.date(from: json["launch_date_utc"].stringValue) else { return nil }
        self.name = json["name"].stringValue
        self.launchDate = launchDate
        self.launchMass = Weight(kilos: json["launch_mass_kg"].doubleValue, pounds: json["launch_mass_lbs"].doubleValue)
        self.noradId = json["norad_id"].stringValue
        self.orbitType = Rocket.Payload.OrbitParameters.ReferenceSystem(rawValue: json["orbit_type"].stringValue) ?? .unknown
        self.apoapsisAu = json["apoapsis_au"].doubleValue
        self.periapsisAu = json["periapsis_au"].doubleValue
        self.semiMajorAxisAu = json["semi_major_axis_au"].doubleValue
        self.eccentricity = json["eccentricity"].doubleValue
        self.inclination = json["inclination"].doubleValue
        self.longitude = json["longitude"].doubleValue
        self.periapsisArg = json["periapsis_arg"].doubleValue
        self.periodDays = json["period_days"].doubleValue
        self.speed = Speed(kmh: json["speed_kph"].doubleValue, mph: json["speed_mph"].doubleValue)
        self.earthDistanceKm = json["earth_distance_km"].doubleValue
        self.marsDistanceKm = json["mars_distance_km"].doubleValue
        self.wikipedia = URL(string: json["wikipedia"].stringValue)
        self.details = json["details"].stringValue
    }
}

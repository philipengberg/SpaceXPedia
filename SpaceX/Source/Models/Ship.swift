//
//  Ship.swift
//  SpaceX
//
//  Created by Philip Engberg on 08/09/2018.
//  Copyright © 2018 Simple Sense. All rights reserved.
//

import Foundation
import SwiftyJSON

struct Ship: Serialization {
    
    let shipId: String
    let shipName: String
    let shipModel: String?
    let shipType: String
    let roles: [String]
    let active: Bool
    let imo: Int?
    let mmsi: Int?
    let abs: Int?
    let `class`: Int?
    let weight: Weight?
    let yearBuilt: Int?
    let homePort: String
    let status: String?
    let currentSpeedKnots: Double
    let currentCourseDeg: Double?
    let currentPosition: Position?
    let successfulLandings: Int?
    let attemptedLandings: Int?
    let missions: [MissionReference]
    let url: URL?
    let imageUrl: URL?
    
    init?(json: JSON) {
        guard let shipId = json["ship_id"].string else { return nil }
        self.shipId = shipId
        self.shipName = json["ship_name"].stringValue
        self.shipModel = json["ship_model"].string
        self.shipType = json["ship_type"].stringValue
        self.roles = json["roles"].arrayValue.compactMap { $0.string }
        self.active = json["active"].boolValue
        self.imo = json["imo"].int
        self.mmsi = json["mmsi"].int
        self.abs = json["abs"].int
        self.`class` = json["class"].int
        self.weight = Weight(kilos: json["weight_kg"].double, pounds: json["weight_lbs"].double)
        self.yearBuilt = json["year_built"].int
        self.homePort = json["home_port"].stringValue
        self.status = json["status"].string
        self.currentSpeedKnots = json["speed_kn"].doubleValue
        self.currentCourseDeg = json["course_deg"].double
        self.currentPosition = Position(json: json["position"])
        self.successfulLandings = json["successful_landings"].int
        self.attemptedLandings = json["attempted_landings"].int
        self.missions = json["missions"].arrayValue.compactMap { MissionReference(json: $0) }
        self.url = json["url"].url
        self.imageUrl = json["image"].url
    }
    
}

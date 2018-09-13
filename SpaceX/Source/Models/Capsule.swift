//
//  Capsule.swift
//  SpaceX
//
//  Created by Philip Engberg on 09/09/2018.
//  Copyright © 2018 Simple Sense. All rights reserved.
//

import Foundation
import SwiftyJSON

struct Capsule: Serialization {
    
    let capsuleSerial: String
    let capsuleId: String
    let status: String
    let originalLaunch: Date?
    let missions: [MissionReference]?
    let landings: Int
    let type: String
    let details: String?
    let reuseCount: Int
    
    init?(json: JSON) {
        guard let serial = json["capsule_serial"].string else { return nil }
        self.capsuleSerial = serial
        self.capsuleId = json["capsule_id"].stringValue
        self.status = json["status"].stringValue
        self.originalLaunch = DateFormatter.ISO8601.date(from: json["original_launch"].stringValue)
        
        if json["missions"].exists() {
            self.missions = json["missions"].arrayValue.compactMap { MissionReference(json: $0) }
        } else {
            self.missions = nil
        }
        
        self.landings = json["landings"].intValue
        self.type = json["type"].stringValue
        self.details = json["details"].string
        self.reuseCount = json["reuse_count"].intValue
    }
}

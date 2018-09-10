//
//  MissionReference.swift
//  SpaceX
//
//  Created by Philip Engberg on 10/09/2018.
//  Copyright © 2018 Simple Sense. All rights reserved.
//

import Foundation
import SwiftyJSON

struct MissionReference: Serialization {
    
    let name: String
    let flightId: Int
    
    init?(json: JSON) {
        guard let id = json["flight"].int else { return nil }
        self.flightId = id
        self.name = json["name"].stringValue
    }
    
}

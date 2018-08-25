//
//  LaunchSite.swift
//  SpaceX
//
//  Created by Philip Engberg on 23/08/2018.
//  Copyright © 2018 Simple Sense. All rights reserved.
//

import Foundation
import SwiftyJSON

struct LaunchSite: Serialization {
    
    enum Status: String {
        case active, retired, unknown
        
        var displayName: String {
            return self.rawValue.capitalized
        }
    }
    
    let id: String
    let fullName: String
    let status: Status
    let location: Locatiom
    let vehiclesLaunched: [String]
    let details: String
    
    init?(json: JSON) {
        guard let id = json["id"].string else { return nil }
        guard let location = Locatiom(json: json["location"]) else { return nil }
        self.id = id
        self.fullName = json["full_name"].stringValue
        self.status = Status(rawValue: json["status"].stringValue) ?? .unknown
        self.location = location
        self.vehiclesLaunched = json["vehicles_launched"].arrayValue.compactMap { $0.stringValue }
        self.details = json["details"].stringValue
    }
}

extension LaunchSite {
    
    struct Locatiom: Serialization {
        let name: String
        let region: String
        let latitude: Double
        let longitude: Double
        
        init?(json: JSON) {
            self.name = json["name"].stringValue
            self.region = json["region"].stringValue
            self.latitude = json["latitude"].doubleValue
            self.longitude = json["longitude"].doubleValue
        }
    }
    
}

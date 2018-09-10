//
//  Launch.swift
//  SpaceX
//
//  Created by Philip Engberg on 21/08/2018.
//  Copyright © 2018 Simple Sense. All rights reserved.
//

import Foundation
import SwiftyJSON

struct Launch: Serialization {
    
    let flightNumber: Int
    let missionName: String
    let details: String?
    let launchDate: LaunchDate
    let rocket: Rocket
    let reuse: Reuse
    let launchSuccess: Bool?
    let staticFireDate: Date?
    let site: Site?
    let links: Links?
    let shipIds: [String]
    
    init?(json: JSON) {
        guard let flightNumber = json["flight_number"].int else { return nil }
        guard let rocket = Rocket(json: json["rocket"]) else { return nil }
        guard let launchDate = LaunchDate(json: json) else { return nil }
        self.flightNumber = flightNumber
        self.missionName = json["mission_name"].stringValue
        self.details = json["details"].string
        self.launchDate = launchDate
        self.rocket = rocket
        self.reuse = Reuse(json: json["reuse"]) ?? .empty
        self.launchSuccess = json["launch_success"].bool
        self.staticFireDate = DateFormatter.ISO8601.date(from: json["static_fire_date_utc"].stringValue)
        self.site = Site(json: json["launch_site"])
        self.links = Links(json: json["links"])
        self.shipIds = json["ships"].arrayValue.compactMap { $0.string }
    }
    
}

extension Launch {
    
    struct LaunchDate: Serialization {
        
        enum TentativePrecision: String {
            case hour, day, month, quarter, half, year
        }
        
        let date: Date
        let isTentative: Bool
        let tentativeMaxPrecision: TentativePrecision
        let isUpcoming: Bool
        
        init?(json: JSON) {
            guard let date = DateFormatter.ISO8601.date(from: json["launch_date_utc"].stringValue) else { return nil }
            self.date = date
            self.isTentative = json["is_tentative"].boolValue
            self.tentativeMaxPrecision = TentativePrecision(rawValue: json["tentative_max_precision"].stringValue) ?? .hour
            self.isUpcoming = json["upcoming"].boolValue
        }
        
        var displayName: String {
            if isUpcoming {
                if isTentative {
                    switch tentativeMaxPrecision {
                    case .hour:    return "NET " + DateFormatter.launchDateFormatter.string(from: date)
                    case .day:     return "NET " + DateFormatter.launchDateNETDayFormatter.string(from: date)
                    case .month:   return "NET " + DateFormatter.launchDateNETMonthFormatter.string(from: date)
                    case .quarter: return "NET " + DateFormatter.launchDateNETQuarterFormatter.string(from: date)
                    case .half:    return "NET " + DateFormatter.launchDateNETYearFormatter.string(from: date)
                    case .year:    return "NET " + DateFormatter.launchDateNETYearFormatter.string(from: date)
                    }
                } else {
                    return DateFormatter().shortWeekdaySymbols[Calendar.current.component(.weekday, from: date) - 1] + ", " + DateFormatter.launchDateFormatter.string(from: date)
                }
            } else {
                return DateFormatter.launchDateFormatter.string(from: date)
            }
        }
    }
    
}

extension Launch {
    struct Reuse: Serialization {
        let core: Bool
        let sideCore1: Bool
        let sideCore2: Bool
        let fairings: Bool
        let capsule: Bool
        
        init?(json: JSON) {
            self.core = json["core"].boolValue
            self.sideCore1 = json["side_core1"].boolValue
            self.sideCore2 = json["side_core2"].boolValue
            self.fairings = json["fairings"].boolValue
            self.capsule = json["capsule"].boolValue
        }
        
        init(core: Bool, sideCore1: Bool, sideCore2: Bool, fairings: Bool, capsule: Bool) {
            self.core = core
            self.sideCore1 = sideCore1
            self.sideCore2 = sideCore2
            self.fairings = fairings
            self.capsule = capsule
        }
        
        static let empty = Reuse(core: false, sideCore1: false, sideCore2: false, fairings: false, capsule: false)
        
        var isAnyPartsReused: Bool {
            return core || sideCore1 || sideCore2 || fairings || capsule
        }
    }
}

extension Launch {
    struct Site: Serialization {
        let id: String
        let siteName: String
        let longSiteName: String
        
        init?(json: JSON) {
            guard let id = json["site_id"].string else { return nil }
            self.id = id
            self.siteName = json["site_name"].stringValue
            self.longSiteName = json["site_name_long"].stringValue
        }
    }
}

extension Launch {
    struct Links: Serialization {
        let missionPatch: String?
        let missionPatchSmall: String?
        let redditCampaign: String?
        let redditLaunch: String?
        let redditRecovery: String?
        let redditMedia: String?
        let presskit: String?
        let articleLink: String?
        let wikipedia: String?
        let videoLink: String?
        
        init?(json: JSON) {
            self.missionPatch = json["mission_patch"].string
            self.missionPatchSmall = json["mission_patch_small"].string
            self.redditCampaign = json["reddit_campaign"].string
            self.redditLaunch = json["reddit_launch"].string
            self.redditRecovery = json["reddit_recovery"].string
            self.redditMedia = json["reddit_media"].string
            self.presskit = json["presskit"].string
            self.articleLink = json["article_link"].string
            self.wikipedia = json["wikipedia"].string
            self.videoLink = json["video_link"].string
        }
        
        var youTubeVideoId: String? {
            guard let link = videoLink else { return nil }
            guard let url = URL(string: link) else { return nil }
            guard let components = URLComponents(url: url, resolvingAgainstBaseURL: true) else { return nil }
            guard let host = components.host else { return nil }
            guard host.contains("youtube.com") else { return nil }
            return components.queryItems?.first(where: { $0.name == "v" })?.value
        }
    }
}

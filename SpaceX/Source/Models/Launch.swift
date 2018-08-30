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
    let launchDate: Date?
    let rocket: Rocket
    let reuse: Reuse
    let launchSuccess: Bool?
    let upcoming: Bool
    let staticFireDate: Date?
    let site: Site?
    let links: Links?
    
    init?(json: JSON) {
        guard let flightNumber = json["flight_number"].int else { return nil }
        guard let rocket = Rocket(json: json["rocket"]) else { return nil }
        self.flightNumber = flightNumber
        self.missionName = json["mission_name"].stringValue
        self.details = json["details"].string
        self.launchDate = DateFormatter.ISO8601.date(from: json["launch_date_utc"].stringValue)
        self.rocket = rocket
        self.reuse = Reuse(json: json["reuse"]) ?? .empty
        self.launchSuccess = json["launch_success"].bool
        self.upcoming = json["upcoming"].boolValue
        self.staticFireDate = DateFormatter.ISO8601.date(from: json["static_fire_date_utc"].stringValue)
        self.site = Site(json: json["launch_site"])
        self.links = Links(json: json["links"])
    }
    
    var searchString: String {
        let searchTerms = [missionName, details, rocket.name, rocket.version] + (rocket.firstStage?.cores.map { $0.searchString } ?? [])
        return searchTerms.compactMap { $0?.lowercased() }.joined(separator: " ")
    }
    
}

extension String {
    init?(int: Int?) {
        guard let val = int else { return nil }
        self = "\(val)"
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

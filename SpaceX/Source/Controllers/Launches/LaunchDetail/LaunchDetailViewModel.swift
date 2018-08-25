//
//  LaunchDetailViewModel.swift
//  SpaceX
//
//  Created by Philip Engberg on 22/08/2018.
//  Copyright © 2018 Simple Sense. All rights reserved.
//

import Foundation
import RxSwift

struct InfoSection {
    let sectionName: String?
    let properties: [PropertyWithDetail]
}

struct PropertyWithDetail {
    let propertyName: String
    let propertyValue: String
    let detail: Router.Destination?
    let image: UIImage?
    let longValueText: Bool
    
    init(propertyName: String, propertyValue: String, detail: Router.Destination? = nil, image: UIImage? = nil, longValueText: Bool = false) {
        self.propertyName = propertyName
        self.propertyValue = propertyValue
        self.detail = detail
        self.image = image
        self.longValueText = longValueText
    }
}

class LaunchDetailViewModel: ValueViewModel<Launch> {
    
    let numberFormatter = NumberFormatter().setUp {
        $0.numberStyle = .decimal
    }
    
    let sections = Variable<[InfoSection]>([])

    init(launchId: String, launch: Launch?) {
        super.init(api: SpaceXAPI, target: .launch(id: launchId))
        
        object.asObservable().unwrap().map { [weak self] (launch) -> [InfoSection]? in
            guard let s = self else { return nil }
            return s.generateAllSections(from: launch)
        }.unwrap().bind(to: sections).disposed(by: bag)
        
        self.object.value = launch
    }
    
    private func generateAllSections(from launch: Launch) -> [InfoSection] {
        var sections = [generateBasicInfoSection(from: launch)]
        
        if let firstStage = launch.rocket.firstStage {
            switch firstStage.cores.count {
            case 1:  sections.append(contentsOf: firstStage.cores.enumerated().map { self.generateBoosterSection(from: $1, coreNumber: nil) })
            default: sections.append(contentsOf: firstStage.cores.enumerated().map { self.generateBoosterSection(from: $1, coreNumber: $0) })
            }
        }
        
        if let secondStage = launch.rocket.secondStage {
            sections.append(contentsOf: secondStage.payloads.map { generatePayloadSection(from: $0) })
        }
        
        sections.append(generateLinksSection(from: launch))
        
        return sections
    }
    
    private func generateBasicInfoSection(from launch: Launch) -> InfoSection {
        var props = [PropertyWithDetail(propertyName: "Flight number", propertyValue: "\(launch.flightNumber)")]
        
        if let details = launch.details {
            props.append(PropertyWithDetail(propertyName: "Details", propertyValue: details, longValueText: true))
        }
        
        props.append(PropertyWithDetail(propertyName: "Launch date", propertyValue: DateFormatter.launchDateFormatter.string(from: launch.launchDate!)))
        
        if let launchSuccess = launch.launchSuccess {
            props.append(PropertyWithDetail(propertyName: "Success", propertyValue: "\(launchSuccess ? "Yes" : "No")"))
        }
        
        props.append(PropertyWithDetail(propertyName: "Location", propertyValue: launch.site!.siteName, detail: Router.Destination.launchSite(siteId: launch.site!.id)))
        props.append(PropertyWithDetail(propertyName: "Rocket", propertyValue: launch.rocket.name, detail: Router.Destination.rocketDetail(rocketId: launch.rocket.id), image: launch.rocket.type.image))
        
        return InfoSection(sectionName: nil, properties: props)
    }
    
    private func generateBoosterSection(from core: Rocket.Core, coreNumber: Int?) -> InfoSection {
        var props = [PropertyWithDetail(propertyName: "Serial", propertyValue: core.coreSerial)]
        
        if let block = core.block {
            props.append(PropertyWithDetail(propertyName: "Block", propertyValue: "\(block)"))
        }
        
        
        props.append(contentsOf: [
            PropertyWithDetail(propertyName: "Flight number", propertyValue: "\(core.flightNumber)"),
            PropertyWithDetail(propertyName: "Reused", propertyValue: "\(core.reused ? "Yes" : "No")"),
        ])
        
        if let landingType = core.landingType {
            props.append(PropertyWithDetail(propertyName: "Landing type", propertyValue: landingType.rawValue))
        }
        
        if let landingVehicle = core.landingVehicle {
            props.append(PropertyWithDetail(propertyName: "Landing vehicle", propertyValue: landingVehicle))
        }
        
        if let landingSuccess = core.landingSuccess, core.landingType != nil {
            props.append(PropertyWithDetail(propertyName: "Landing success", propertyValue: "\(landingSuccess ? "Yes" : "No")"))
        }
        
        if let coreNumber = coreNumber {
            return InfoSection(sectionName: "Core #\(coreNumber + 1)", properties: props)
        } else {
            return InfoSection(sectionName: "Core", properties: props)
        }
    }
    
    private func generatePayloadSection(from payload: Rocket.Payload) -> InfoSection {
        var props = [PropertyWithDetail]()
        
        props.append(PropertyWithDetail(propertyName: "Type", propertyValue: payload.payloadType))
        props.append(PropertyWithDetail(propertyName: "Customers", propertyValue: payload.customers.joined(separator: ", ")))
        
        if let nationality = payload.nationality {
            props.append(PropertyWithDetail(propertyName: "Nationality", propertyValue: nationality))
        }
        
        if let manufacturer = payload.manufacturer {
            props.append(PropertyWithDetail(propertyName: "Manufacturer", propertyValue: manufacturer))
        }
        
        if let mass = payload.payloadMass {
            props.append(PropertyWithDetail(propertyName: "Mass", propertyValue: "\(numberFormatter.string(from: NSNumber(value: Int(mass.kilos)))!) kg"))
        }
        
        props.append(PropertyWithDetail(propertyName: "Orbit", propertyValue: payload.orbit))
        
        if let longitude = payload.orbitParameters?.longitude {
            props.append(PropertyWithDetail(propertyName: "Longitude", propertyValue: "\(longitude)°"))
        }
        
        if let inclinationDeg = payload.orbitParameters?.inclinationDeg {
            props.append(PropertyWithDetail(propertyName: "Inclination", propertyValue: "\(inclinationDeg)°"))
        }
        
        if let semiMajorAxisKm = payload.orbitParameters?.semiMajorAxisKm {
            props.append(PropertyWithDetail(propertyName: "Semi major axis", propertyValue: "\(semiMajorAxisKm) km"))
        }
        
        if let eccentricity = payload.orbitParameters?.eccentricity {
            props.append(PropertyWithDetail(propertyName: "Eccentricity", propertyValue: "\(eccentricity)"))
        }
        
        if let periapsisKm = payload.orbitParameters?.periapsisKm {
            props.append(PropertyWithDetail(propertyName: "Periapsis", propertyValue: "\(periapsisKm) km"))
        }
        
        if let apoapsisKm = payload.orbitParameters?.apoapsisKm {
            props.append(PropertyWithDetail(propertyName: "Apoapsis", propertyValue: "\(apoapsisKm) km"))
        }
        
        if let periodMin = payload.orbitParameters?.periodMin {
            props.append(PropertyWithDetail(propertyName: "Period", propertyValue: "\(periodMin) min"))
        }
        
        if let lifespanYears = payload.orbitParameters?.lifespanYears {
            props.append(PropertyWithDetail(propertyName: "Lifespan", propertyValue: "\(lifespanYears) yrs"))
        }
        
        return InfoSection(sectionName: "Payload: \(payload.payloadId)", properties: props)
    }
    
    private func generateLinksSection(from launch: Launch) -> InfoSection {
        var props = [PropertyWithDetail]()
        
        if let missionPatch = URL(string: launch.links?.missionPatch) {
            props.append(PropertyWithDetail(propertyName: "Mission patch", propertyValue: missionPatch.host!, detail: .web(url: missionPatch)))
        }
        
        if let redditCampaign = URL(string: launch.links?.redditCampaign) {
            props.append(PropertyWithDetail(propertyName: "Reddit campaign", propertyValue: redditCampaign.host!, detail: .web(url: redditCampaign)))
        }
        
        if let redditLaunch = URL(string: launch.links?.redditLaunch) {
            props.append(PropertyWithDetail(propertyName: "Reddit launch", propertyValue: redditLaunch.host!, detail: .web(url: redditLaunch)))
        }
        
        if let redditRecovery = URL(string: launch.links?.redditRecovery) {
            props.append(PropertyWithDetail(propertyName: "Reddit recovery", propertyValue: redditRecovery.host!, detail: .web(url: redditRecovery)))
        }
        
        if let redditMedia = URL(string: launch.links?.redditMedia) {
            props.append(PropertyWithDetail(propertyName: "Reddit media", propertyValue: redditMedia.host!, detail: .web(url: redditMedia)))
        }
        
        if let presskit = URL(string: launch.links?.presskit) {
            props.append(PropertyWithDetail(propertyName: "Presskit", propertyValue: presskit.host!, detail: .web(url: presskit)))
        }
        
        if let articleLink = URL(string: launch.links?.articleLink) {
            props.append(PropertyWithDetail(propertyName: "Article link", propertyValue: articleLink.host!, detail: .web(url: articleLink)))
        }
        
        if let wikipedia = URL(string: launch.links?.wikipedia) {
            props.append(PropertyWithDetail(propertyName: "Wikipedia", propertyValue: wikipedia.host!, detail: .web(url: wikipedia)))
        }
        
        return InfoSection(sectionName: "Links", properties: props)
    }
    
}

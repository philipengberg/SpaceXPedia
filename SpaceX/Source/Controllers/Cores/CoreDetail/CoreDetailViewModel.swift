//
//  CoreDetailViewModel.swift
//  SpaceX
//
//  Created by Philip Engberg on 09/09/2018.
//  Copyright © 2018 Simple Sense. All rights reserved.
//

import Foundation
import RxSwift

class CoreDetailViewModel: ValueViewModel<Rocket.Core> {
    
    let sections = Variable<[InfoSection]>([])
    
    let numberFormatter = NumberFormatter().setUp {
        $0.numberStyle = .decimal
    }
    
    init(coreSerial: String, api: API = SpaceXAPI) {
        super.init(api: api, target: .core(coreSerial: coreSerial))
        
        object.asObservable().unwrap().map { [weak self] core -> [InfoSection]? in
            guard let s = self else { return nil }
            return s.generateAllSections(from: core)
        }.unwrap().bind(to: sections).disposed(by: bag)
    }
    
    private func generateAllSections(from core: Rocket.Core) -> [InfoSection] {
        var sections = [generateBasicInfoSection(from: core)]
        
        if let missions = generateMissionsSection(from: core) {
            sections.append(missions)
        }
        
        return sections
    }
    
    private func generateBasicInfoSection(from core: Rocket.Core) -> InfoSection {
        var props = [PropertyWithDetail(propertyName: "Serial", propertyValue: core.coreSerial!)]
        
        if let block = core.block {
            props.append(PropertyWithDetail(propertyName: "Block", propertyValue: "\(block)"))
        }
        
        if let status = core.status {
            props.append(PropertyWithDetail(propertyName: "Status", propertyValue: status.capitalized))
        }
        
        if let reuseCount = core.reuseCount {
            props.append(PropertyWithDetail(propertyName: "Reuse count", propertyValue: "\(reuseCount)"))
        }
        
        if let rtlsLandings = core.rtlsLandings, let rtlsLandingAttempts = core.rtlsLandingAttempts {
            props.append(PropertyWithDetail(propertyName: "RTLS landings", propertyValue: "\(rtlsLandings)/\(rtlsLandingAttempts)"))
        }
        
        if let asdsLandings = core.asdsLandings, let asdsLandingAttempts = core.asdsLandingAttempts {
            props.append(PropertyWithDetail(propertyName: "ASDS landings", propertyValue: "\(asdsLandings)/\(asdsLandingAttempts)"))
        }
        
        if let originalLaunch = core.originalLaunch {
            props.append(PropertyWithDetail(propertyName: "Original launch", propertyValue: DateFormatter.launchDateFormatter.string(from: originalLaunch)))
        }
        
        if let details = core.details {
            props.append(PropertyWithDetail(propertyName: "Details", propertyValue: details, longValueText: true))
        }
        
        return InfoSection(sectionName: nil, properties: props)
    }
    
    private func generateMissionsSection(from core: Rocket.Core) -> InfoSection? {
        guard let missions = core.missions, missions.count > 0 else { return nil }
        
        return InfoSection(sectionName: "Missions", properties: missions.map { PropertyWithDetail(propertyName: $0.name, propertyValue: "", detail: Router.Destination.launchDetail(flightNumber: $0.flightId)) })
    }
    
}

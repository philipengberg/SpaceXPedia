//
//  CapsuleDetailViewModel.swift
//  SpaceX
//
//  Created by Philip Engberg on 09/09/2018.
//  Copyright © 2018 Simple Sense. All rights reserved.
//

import Foundation
import RxSwift

class CapsuleDetailViewModel: ValueViewModel<Capsule> {
    
    let sections = Variable<[InfoSection]>([])
    
    let numberFormatter = NumberFormatter().setUp {
        $0.numberStyle = .decimal
    }
    
    init(capsuleId: String, api: API = SpaceXAPI) {
        super.init(api: api, target: .capsule(capId: capsuleId))
        
        object.asObservable().unwrap().map { [weak self] capsule -> [InfoSection]? in
            guard let s = self else { return nil }
            return s.generateAllSections(from: capsule)
        }.unwrap().bind(to: sections).disposed(by: bag)
    }
    
    private func generateAllSections(from capsule: Capsule) -> [InfoSection] {
        var sections = [generateBasicInfoSection(from: capsule)]
        
        if let missions = generateMissionsSection(from: capsule) {
            sections.append(missions)
        }
        
        return sections
    }
    
    private func generateBasicInfoSection(from capsule: Capsule) -> InfoSection {
        var props = [PropertyWithDetail(propertyName: "Serial", propertyValue: capsule.capsuleSerial)]
        
        props.append(PropertyWithDetail(propertyName: "Type", propertyValue: capsule.type))
        props.append(PropertyWithDetail(propertyName: "Status", propertyValue: capsule.status.capitalized))
        props.append(PropertyWithDetail(propertyName: "Landings", propertyValue: "\(capsule.landings)"))
        props.append(PropertyWithDetail(propertyName: "Reuse count", propertyValue: "\(capsule.reuseCount)"))
        
        if let originalLaunch = capsule.originalLaunch {
            props.append(PropertyWithDetail(propertyName: "Original launch", propertyValue: DateFormatter.launchDateFormatter.string(from: originalLaunch)))
        }
        
        if let details = capsule.details {
            props.append(PropertyWithDetail(propertyName: "Details", propertyValue: details, longValueText: true))
        }
        
        return InfoSection(sectionName: nil, properties: props)
    }
    
    private func generateMissionsSection(from capsule: Capsule) -> InfoSection? {
        guard let missions = capsule.missions, missions.count > 0 else { return nil }
        
        return InfoSection(sectionName: "Missions", properties: missions.map { PropertyWithDetail(propertyName: $0, propertyValue: "") })
    }
    
}

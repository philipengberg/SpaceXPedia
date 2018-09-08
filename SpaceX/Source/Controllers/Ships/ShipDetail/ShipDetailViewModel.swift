//
//  ShipDetailViewModel.swift
//  SpaceX
//
//  Created by Philip Engberg on 08/09/2018.
//  Copyright © 2018 Simple Sense. All rights reserved.
//

import Foundation
import RxSwift

class ShipDetailViewModel: ValueViewModel<Ship> {
    
    let sections = Variable<[InfoSection]>([])
    
    let numberFormatter = NumberFormatter().setUp {
        $0.numberStyle = .decimal
    }
    
    init(shipId: String, api: API = SpaceXAPI) {
        super.init(api: api, target: .ship(shipId: shipId))
        
        object.asObservable().unwrap().map { [weak self] ship -> [InfoSection]? in
            guard let s = self else { return nil }
            return s.generateAllSections(from: ship)
        }.unwrap().bind(to: sections).disposed(by: bag)
    }
    
    private func generateAllSections(from ship: Ship) -> [InfoSection] {
        var sections = [generateBasicInfoSection(from: ship)]
        
        if let landingsSection = generateLandingsSection(from: ship) {
            sections.append(landingsSection)
        }
        
        if let currentStatusSection = generateCurrentStatusSection(from: ship) {
            sections.append(currentStatusSection)
        }
        
        if let missionsSection = generateMissionsSection(from: ship) {
            sections.append(missionsSection)
        }
        
        if let identifiersSection = generateIdentifiersSection(from: ship) {
            sections.append(identifiersSection)
        }
        
        if let linksSection = generateLinksSection(from: ship) {
            sections.append(linksSection)
        }
        
        return sections
    }
    
    private func generateBasicInfoSection(from ship: Ship) -> InfoSection {
        var props = [PropertyWithDetail(propertyName: "Name", propertyValue: ship.shipName)]
        
        if let model = ship.shipModel {
            props.append(PropertyWithDetail(propertyName: "Model", propertyValue: model))
        }
        
        props.append(PropertyWithDetail(propertyName: "Type", propertyValue: ship.shipType))
        
        if ship.roles.count > 0 {
            props.append(PropertyWithDetail(propertyName: "Roles", propertyValue: ship.roles.joined(separator: ", ")))
        }
        
        props.append(PropertyWithDetail(propertyName: "Active", propertyValue: ship.active ? "Yes" : "No"))
        
        if let wieght = ship.weight {
            props.append(PropertyWithDetail(propertyName: "Weight", propertyValue: "\(numberFormatter.string(from: NSNumber(value: wieght.kilos))!) kg"))
        }
        
        if let year = ship.yearBuilt {
            props.append(PropertyWithDetail(propertyName: "Built", propertyValue: "\(year)"))
        }
        
        props.append(PropertyWithDetail(propertyName: "Home port", propertyValue: ship.homePort))
        
        return InfoSection(sectionName: nil, properties: props)
    }
    
    private func generateLandingsSection(from ship: Ship) -> InfoSection? {
        var props = [PropertyWithDetail]()
        
        if let landingAttempts = ship.attemptedLandings {
            props.append(PropertyWithDetail(propertyName: "Attempts", propertyValue: "\(landingAttempts)"))
        }
        
        if let landingSuccesses = ship.successfulLandings {
            props.append(PropertyWithDetail(propertyName: "Successful", propertyValue: "\(landingSuccesses)"))
        }
        
        guard props.count > 0 else { return nil }
        
        return InfoSection(sectionName: "Landings", properties: props)
    }
    
    private func generateCurrentStatusSection(from ship: Ship) -> InfoSection? {
        var props = [PropertyWithDetail]()
        
        guard let status = ship.status else { return nil }
        props.append(PropertyWithDetail(propertyName: "Status", propertyValue: status))
        
        props.append(PropertyWithDetail(propertyName: "Speed", propertyValue: "\(numberFormatter.string(from: NSNumber(value: ship.currentSpeedKnots))!) knots"))
        
        if let course = ship.currentCourseDeg {
            props.append(PropertyWithDetail(propertyName: "Course", propertyValue: "\(numberFormatter.string(from: NSNumber(value: course))!)°"))
        }
        
        if let position = ship.currentPosition {
            props.append(PropertyWithDetail(propertyName: "Latitude", propertyValue: "\(numberFormatter.string(from: NSNumber(value: position.latitude))!)°"))
            props.append(PropertyWithDetail(propertyName: "Longitude", propertyValue: "\(numberFormatter.string(from: NSNumber(value: position.longitude))!)°"))
        }
        
        return InfoSection(sectionName: "Current status", properties: props)
    }
    
    private func generateMissionsSection(from ship: Ship) -> InfoSection? {
        guard ship.missions.count > 0 else { return nil }

        return InfoSection(sectionName: "Missions", properties: ship.missions.map { PropertyWithDetail(propertyName: $0, propertyValue: "") })
    }
    
    private func generateIdentifiersSection(from ship: Ship) -> InfoSection? {
        var props = [PropertyWithDetail]()
        
        if let imo = ship.imo {
            props.append(PropertyWithDetail(propertyName: "IMO", propertyValue: "\(imo)"))
        }
        
        if let mmsi = ship.mmsi {
            props.append(PropertyWithDetail(propertyName: "MMSI", propertyValue: "\(mmsi)"))
        }
        
        if let abs = ship.abs {
            props.append(PropertyWithDetail(propertyName: "ABS", propertyValue: "\(abs)"))
        }
        
        if let lol = ship.class {
            props.append(PropertyWithDetail(propertyName: "Class", propertyValue: "\(lol)"))
        }
        
        guard props.count > 0 else { return nil }
        return InfoSection(sectionName: "Identifiers", properties: props)
    }
    
    private func generateLinksSection(from ship: Ship) -> InfoSection? {
        var props = [PropertyWithDetail]()
        
        if let url = ship.url {
            props.append(PropertyWithDetail(propertyName: "Web", propertyValue: url.host!, detail: .web(url: url)))
        }
        
        guard props.count > 0 else { return nil }
        return InfoSection(sectionName: "Links", properties: props)
    }
    
}

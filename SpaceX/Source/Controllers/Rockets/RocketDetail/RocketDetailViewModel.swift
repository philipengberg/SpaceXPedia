//
//  RocketDetailViewModel.swift
//  SpaceX
//
//  Created by Philip Engberg on 20/08/2018.
//  Copyright © 2018 Simple Sense. All rights reserved.
//

import Foundation
import RxSwift

struct Property {
    let propertyName: String
    let propertyValue: String
}

class RocketDetailViewModel: ValueViewModel<Rocket> {
    
    let numberFormatter = NumberFormatter().setUp {
        $0.numberStyle = .decimal
    }
    
    init(rocketId: String) {
        super.init(target: SpaceXTarget.rocket(id: rocketId))
    }
    
    func rocketProperties(for section: Int) -> [Property] {
        guard let rocket = self.object.value else { return [] }
        
        switch section {
        case 1:
            var props =  [
                Property(propertyName: "Name", propertyValue: rocket.name),
                Property(propertyName: "Diameter", propertyValue: "\(numberFormatter.string(from: NSNumber(value: Int(rocket.diameter.meters)))!) m"),
                Property(propertyName: "Height", propertyValue: "\(numberFormatter.string(from: NSNumber(value: Int(rocket.height.meters)))!) m"),
                Property(propertyName: "Weight", propertyValue: "\(numberFormatter.string(from: NSNumber(value: Int(rocket.mass.kilos)))!) kg"),
                Property(propertyName: "Engines", propertyValue: "\(rocket.numberOfEngines)"),
            ]
            
            if let landingLegs = rocket.landingLegs {
                props.append(Property(propertyName: "Landing legs", propertyValue: "\(landingLegs.number)"))
                props.append(Property(propertyName: "Landing leg material", propertyValue: "\(landingLegs.material)"))
            }
            
            return props
            
        case 2:
            guard let engine = rocket.engine else { return [] }
            var props = [
                Property(propertyName: "Type", propertyValue: engine.type.name),
                Property(propertyName: "Version", propertyValue: engine.version.name),
                Property(propertyName: "Layout", propertyValue: engine.layout.name),
                Property(propertyName: "Propellant 1", propertyValue: engine.propellant1.name),
                Property(propertyName: "Propellant 2", propertyValue: engine.propellant2.name),
            ]
            
            if let thrust = engine.thrust {
                props.append(Property(propertyName: "Thrust", propertyValue: "\(numberFormatter.string(from: NSNumber(value: Int(thrust.kiloNewtons)))!) kN"))
            }
            
            if let seaLevelThrust = engine.seaLevelThrust {
                props.append(Property(propertyName: "Sea level thrust", propertyValue: "\(numberFormatter.string(from: NSNumber(value: Int(seaLevelThrust.kiloNewtons)))!) kN"))
            }
            
            if let vaccumThrust = engine.vaccumThrust {
                props.append(Property(propertyName: "Vaccum thrust", propertyValue: "\(numberFormatter.string(from: NSNumber(value: Int(vaccumThrust.kiloNewtons)))!) kN"))
            }
            
            return props
            
        default: return []
        }
    }
}

extension Rocket.RocketType {
    var image: UIImage? {
        switch self {
        case .falcon1: return #imageLiteral(resourceName: "Falcon1Rocket")
        case .falcon9: return #imageLiteral(resourceName: "Falcon9B5Rocket")
        case .falconHeavy: return #imageLiteral(resourceName: "FalconHeavyRocket")
        default: return nil
        }
    }
}

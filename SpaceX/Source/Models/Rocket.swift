//
//  Rocket.swift
//  SpaceX
//
//  Created by Philip Engberg on 20/08/2018.
//  Copyright © 2018 Simple Sense. All rights reserved.
//

import Foundation
import SwiftyJSON

struct Rocket: Serialization {
    
    enum RocketType: String {
        case falcon1
        case falcon9
        case falconHeavy = "falconheavy"
        case bfr
        case unknown
        
        init(humanReadableString: String) {
            switch humanReadableString.lowercased() {
            case "falcon 1": self = .falcon1
            case "falcon 9": self = .falcon9
            case "falcon heavy": self = .falconHeavy
            case "big falcon heavy": self = .bfr
            default: self = .unknown
            }
        }
    }
    
    let id: String
    let name: String
    let active: Bool
    let type: RocketType
    let version: String
    let numberOfStages: Int
    let diameter: Distance
    let height: Distance
    let mass: Weight
    let numberOfEngines: Int
    let thrustToWeightRatio: Double
    let engine: Rocket.Engine?
    let landingLegs: LandingLegs?
    let firstStage: FirstStage?
    let secondStage: SecondStage?
    
    init?(json: JSON) {
        self.id = json["rocket_id"].string ?? json["id"].stringValue
        self.name = json["rocket_name"].string ?? json["name"].stringValue
        self.active = json["active"].boolValue
        self.type = RocketType(rawValue: json["id"].stringValue) ?? .unknown
        self.version = json["rocket_type"].stringValue
        self.numberOfStages = json["stages"].intValue
        self.diameter = Distance(json: json["diameter"]) ?? .empty
        self.height = Distance(json: json["height"]) ?? .empty
        self.mass = Weight(json: json["mass"]) ?? .empty
        self.numberOfEngines = json["engines"]["number"].intValue
        self.thrustToWeightRatio = json["engines"]["thrust_to_weight"].doubleValue
        self.engine = Rocket.Engine(json: json["engines"])
        self.landingLegs = LandingLegs(json: json["landing_legs"])
        self.firstStage = FirstStage(json: json["first_stage"])
        self.secondStage = SecondStage(json: json["second_stage"])
    }
}

extension Rocket {
    struct Engine: Serialization {
        enum `Type`: String {
            case merlin
            case raptor
            case unknown
            
            var name: String {
                return self.rawValue.capitalized
            }
        }
        
        enum Version: String {
            case oneC = "1C"
            case oneDPlus = "1D+"
            case unknown
            
            var name: String {
                return self.rawValue.capitalized
            }
        }
        
        enum Layout: String {
            case single
            case octaweb
            case unknown
            
            var name: String {
                return self.rawValue.capitalized
            }
        }
        
        enum Propellant: String {
            case liquidOxygen = "liquid oxygen"
            case rp1 = "RP-1 kerosene"
            case liquidMethane = "liquid methane"
            case subcooledLiquidOxygen = "subcooled liquid oxygen"
            case unknown
            
            var name: String {
                return self.rawValue.capitalized
            }
        }
        
        let type: Type
        let version: Version
        let layout: Layout
        let propellant1: Propellant
        let propellant2: Propellant
        let thrust: Thrust?
        let seaLevelThrust: Thrust?
        let vaccumThrust: Thrust?
        
        init?(json: JSON) {
            self.type = Type(rawValue: json["type"].stringValue) ?? .unknown
            self.version = Version(rawValue: json["version"].stringValue) ?? .unknown
            self.layout = Layout(rawValue: json["layout"].stringValue) ?? .unknown
            self.propellant1 = Propellant(rawValue: json["propellant_1"].stringValue) ?? .unknown
            self.propellant2 = Propellant(rawValue: json["propellant_2"].stringValue) ?? .unknown
            self.thrust = Thrust(json: json["thrust"])
            self.seaLevelThrust = Thrust(json: json["thrust_sea_level"])
            self.vaccumThrust = Thrust(json: json["thrust_vacuum"])
        }
    }
}

extension Rocket {
    struct LandingLegs: Serialization {
        let number: Int
        let material: String
        
        init?(json: JSON) {
            guard let number = json["number"].int, number > 0 else { return nil }
            self.number = number
            self.material = json["material"].stringValue.capitalized
        }
    }
}

extension Rocket {
    struct FirstStage: Serialization {
        let cores: [Core]
        
        init?(json: JSON) {
            self.cores = json["cores"].arrayValue.compactMap { Core(json: $0) }
        }
    }
}

extension Rocket {
    struct SecondStage: Serialization {
        let block: Int
        let payloads: [Payload]
        
        init?(json: JSON) {
            self.block = json["block"].intValue
            self.payloads = json["payloads"].arrayValue.compactMap { Payload(json: $0) }
        }
    }
}

extension Rocket {
    
    struct Core: Serialization {
        
        enum LandingType: String {
            case RTLS
            case ASDS
            case ocean = "Ocean"
        }
        
        let coreSerial: String?
        let flightNumber: Int?
        let block: Int?
        let reused: Bool?
        let landingSuccess: Bool?
        let landingType: LandingType?
        let landingVehicle: String?
        
        // Core detail
        let status: String?
        let originalLaunch: Date?
        let reuseCount: Int?
        let details: String?
        let missions: [String]?
        let rtlsLandings: Int?
        let asdsLandings: Int?
        
        init?(json: JSON) {
            guard let serial = json["core_serial"].string else { return nil }
            self.coreSerial = serial
            self.flightNumber = json["flight"].int
            self.block = json["block"].int
            self.reused = json["reused"].bool
            self.landingSuccess = json["land_success"].bool
            self.landingType = LandingType(rawValue: json["landing_type"].stringValue)
            self.landingVehicle = json["landing_vehicle"].string
            
            // Core detail
            self.status = json["status"].string
            self.originalLaunch = DateFormatter.ISO8601.date(from: json["original_launch"].stringValue)
            self.reuseCount = json["reuse_count"].int
            self.details = json["details"].string
            
            if json["missions"].exists() {
                self.missions = json["missions"].arrayValue.compactMap { $0.string }
            } else {
                self.missions = nil
            }
            
            self.rtlsLandings = json["rtls_landings"].int
            self.asdsLandings = json["asds_landings"].int
        }
        
        var blockAndSerialDisplayName: String {
            if let block = self.block, let serial = coreSerial {
                return "B\(block) \(serial)"
            } else {
                return coreSerial ?? ""
            }
        }
    }
}

extension Rocket {
    struct Payload: Serialization {
        
        let payloadId: String
        let reused: Bool
        let capSerial: String?
        let customers: [String]
        let nationality: String?
        let manufacturer: String?
        let payloadType: String
        let payloadMass: Weight?
        let orbit: String
        let orbitParameters: OrbitParameters?
        
        init?(json: JSON) {
            guard let id = json["payload_id"].string else { return nil }
            self.payloadId = id
            self.reused = json["reused"].boolValue
            self.capSerial = json["cap_serial"].string
            self.customers = json["customers"].arrayValue.compactMap { $0.string }
            self.nationality = json["nationality"].string
            self.manufacturer = json["manufacturer"].string
            self.payloadType = json["payload_type"].stringValue
            self.orbit = json["orbit"].stringValue
            self.orbitParameters = OrbitParameters(json: json["orbit_params"])
            
            if let massKg = json["payload_mass_kg"].double, let massLbs = json["payload_mass_lbs"].double {
                self.payloadMass = Weight(kilos: massKg, pounds: massLbs)
            } else {
                self.payloadMass = nil
            }
        }
        
        struct OrbitParameters: Serialization {
            
            enum ReferenceSystem: String {
                case geocentric
                case highlyElliptical = "highly-elliptical"
                case heliocentric
                case unknown
            }
            
            enum Regime: String {
                case geostationary
                case lowEarth = "low-earth"
                case sunSynchronous = "sun-synchronous"
                case highEarth = "high-earth"
                case unknown
            }
            
            let referenceSystem: ReferenceSystem
            let regime: Regime
            let longitude: Double?
            let semiMajorAxisKm: Double?
            let eccentricity: Double?
            let periapsisKm: Double?
            let apoapsisKm: Double?
            let inclinationDeg: Double?
            let periodMin: Double?
            let lifespanYears: Int?
            let epoch: Date?
            let mean_motion: Double?
            let raan: Double?
            
            init?(json: JSON) {
                self.referenceSystem = ReferenceSystem(rawValue: json["reference_system"].stringValue) ?? .unknown
                self.regime = Regime(rawValue: json["regime"].stringValue) ?? .unknown
                self.longitude = json["longitude"].double
                self.semiMajorAxisKm = json["semi_major_axis_km"].double
                self.eccentricity = json["eccentricity"].double
                self.periapsisKm = json["periapsis_km"].double
                self.apoapsisKm = json["apoapsis_km"].double
                self.inclinationDeg = json["inclination_deg"].double
                self.periodMin = json["period_min"].double
                self.lifespanYears = json["lifespan_years"].int
                self.epoch = DateFormatter.ISO8601.date(from: json["epoch"].stringValue)
                self.mean_motion = json["mean_motion"].double
                self.raan = json["raan"].double
            }
        }
    }
}

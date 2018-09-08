//
//  SpaceXAPI.swift
//  SpaceX
//
//  Created by Philip Engberg on 20/08/2018.
//  Copyright © 2018 Simple Sense. All rights reserved.
//

import Foundation
import Moya
import Result
import RxSwift
import SwiftyJSON

class API: MoyaProvider<SpaceXTarget> {
    
    override init(endpointClosure: @escaping EndpointClosure = MoyaProvider.defaultEndpointMapping,
                  requestClosure: @escaping RequestClosure = MoyaProvider<SpaceXTarget>.defaultRequestMapping,
                  stubClosure: @escaping StubClosure = MoyaProvider.neverStub,
                  callbackQueue: DispatchQueue? = nil,
                  manager: Manager = MoyaProvider<SpaceXTarget>.defaultAlamofireManager(),
                  plugins: [PluginType] = [],
                  trackInflights: Bool = false) {
        super.init(endpointClosure: endpointClosure, requestClosure: requestClosure, stubClosure: stubClosure, callbackQueue: callbackQueue, manager: manager, plugins: plugins, trackInflights: trackInflights)
    }
    
    func request(_ token: SpaceXTarget) -> Observable<Response> {
        return super.rx.request(token).asObservable()
    }
}

// swiftlint:disable:next variable_name
let SpaceXAPI = API(plugins: [Logger(), networkActivityIndicator(), credentials()])

private func networkActivityIndicator() -> NetworkActivityPlugin {
    return NetworkActivityPlugin(networkActivityClosure: { (change, target) in
        switch change {
        case .began: UIApplication.shared.isNetworkActivityIndicatorVisible = true
        case .ended: UIApplication.shared.isNetworkActivityIndicatorVisible = false
        }
    })
}

private func credentials() -> CredentialsPlugin {
    return CredentialsPlugin { target -> URLCredential? in
        
        guard let SpaceXTarget = target as? SpaceXTarget else { return nil }
        
        switch SpaceXTarget {
        default:
            return nil
        }
    }
}

// swiftlint:disable:next variable_name
let SpaceXDebugAPI = API(stubClosure: { target -> StubBehavior in
    return StubBehavior.delayed(seconds: 0)
})

//MARK: Plugins

private class Logger: PluginType {
    
    fileprivate func didReceive(_ result: Result<Response, MoyaError>, target: TargetType) {
        
        var version = ""
        if let target = target as? SpaceXTarget {
            version = "/\(target.version)"
        }
        
        switch result {
            
        case .success(let response):
            print("\(response.statusCode): \(target.method.rawValue.uppercased()) - \(version)\(target.path)")
            
            if let responseString = String(data: response.data, encoding: String.Encoding.utf8), response.statusCode >= 400 && response.statusCode < 500 {
                print(responseString)
            }
            
        case .failure(let error):
            switch error {
            case .statusCode(let response):
                print("ERROR: (\(response.statusCode)) \(target.method.rawValue.uppercased()) - \(version)\(target.path)")
            case .underlying(let underlyingError, _):
                let nsError = underlyingError as NSError
                print("ERROR: (\(nsError.code)) \(target.method.rawValue.uppercased()) - \(version)\(target.path)")
            default: break
            }
        }
    }
}

//MARK: Target

enum SpaceXTarget {
    case rockets
    case rocket(id: String)
    case pastLaunches
    case futureLaunches
    case allLaunches
    case launch(flightNumber: Int)
    case launchSite(id: String)
    case roadster
    case ships
    case ship(shipId: String)
}

extension SpaceXTarget: TargetType {
    var headers: [String: String]? {
        let headers: [String: String] = [
            "Accept": "application/json"
        ]
        
        return headers
    }
    
    var baseURL: URL {
        return URL(string: "https://api.spacexdata.com/\(version)")!
    }
    
    var version: String {
        switch self {
        case .ships, .ship: return "v3"
        default: return "v2"
        }
    }
    
    var method: Moya.Method {
        switch self {
        default:
            return .get
        }
    }
    
    var path: String {
        switch self {
        case .rockets:          return "/rockets"
        case .rocket(let id):   return "/rockets/\(id)"
        case .pastLaunches:     return "/launches"
        case .futureLaunches:   return "/launches/upcoming"
        case .allLaunches:      return "/launches/all"
        case .launch:           return "/launches"
        case .launchSite(let id): return "/launchpads/\(id)"
        case .roadster:         return "/info/roadster"
        case .ships:            return "/ships"
        case .ship(let shipId): return "/ships/\(shipId)"
        }
    }
    
    var parameterEncoding: Moya.ParameterEncoding {
        switch self {
        default:
            return URLEncoding.default
        }
    }
    
    var parameters: [String: Any]? {
        switch self {
        case .pastLaunches: return ["sort": "launch_date_utc", "order": "desc"]
        case .launch(let flightNumber): return ["flight_number": flightNumber]
        default:
            return nil
        }
    }
    
    var sampleData: Data {
        switch self {
        default:
            return Data()
        }
    }
    
    var multipartBody: [MultipartFormData]? {
        return nil
    }
    
    var task: Task {
        return .requestParameters(parameters: parameters ?? [:], encoding: parameterEncoding)
    }
}


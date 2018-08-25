//
//  Action+API.swift
//  SpaceX
//
//  Created by Philip Engberg on 20/08/2018.
//  Copyright © 2018 Simple Sense. All rights reserved.
//

import Action
import Foundation
import Moya
import RxSwift
import SwiftyJSON

enum DataError: Swift.Error {
    case unknown
    case noConnection
    case serialization
    case server         //500
    case unauthorized   //401, 403, 405
    case notFound       //404
}

enum DataState {
    case initialLoading
    case error(error: DataError)
    case noData
    case dictData(json: JSONDict)
    case arrayData(json: [JSONDict])
}

extension DataState {
    init(with json: Any) {
        if let response = json as? [JSONDict] {
            if response.count > 0 {
                self = .arrayData(json: response)
            } else {
                self = .noData
            }
        } else if let response = json as? JSONDict {
            self = .dictData(json: response)
        } else {
            self = .noData
        }
    }
}

extension Observable where Element: Any {
    func mapToDataState() -> Observable<DataState> {
        return map { result -> DataState in
            return DataState(with: result)
        }
    }
}

typealias APIAction = Action<API, Any>

extension Action where Input: API, Element: Any { //AKA APIAction
    
    func mapState() -> Observable<DataState> {
        return Observable<DataState>.create { (observer) -> Disposable in
            
            var firstLoad = true
            let compositeDisposable = CompositeDisposable()
            let _ = compositeDisposable.insert(self.executing.subscribe(onNext: { executing in
                if executing && firstLoad {
                    observer.onNext(.initialLoading)
                    firstLoad = false
                }
            }))
            
            let _ = compositeDisposable.insert(self.errors.subscribe(onNext: { error in
                switch error {
                case .notEnabled:
                    return
                default:
                    observer.onNext(.error(error: error.mapDataError()))
                }
            }))
            
            let _ = compositeDisposable.insert(self.elements.subscribe(onNext: { element in
                observer.onNext(DataState(with: element))
            }))
            
            return compositeDisposable
        }
    }
}

extension ActionError {
    func mapDataError() -> DataError {
        var result = DataError.unknown
        
        if let moyaError = self.castUnderlyingError(to: Moya.MoyaError.self) {
            switch moyaError {
            case
            .imageMapping,
            .requestMapping,
            .jsonMapping,
            .stringMapping,
            .objectMapping,
            .encodableMapping,
            .parameterEncoding:
                result = .serialization
                break
            case .statusCode(let response):
                switch response.statusCode {
                case 500:
                    result = .server
                case 401, 403, 405:
                    result = .unauthorized
                case 404:
                    result = .notFound
                default:
                    break
                }
                break
            case .underlying(let error, _):
                if error._domain == NSURLErrorDomain && error._code == NSURLErrorNotConnectedToInternet {
                    //No Internet:  Domain=NSURLErrorDomain Code=-1009
                    result = .noConnection
                } else if error._domain == NSCocoaErrorDomain && error._code == 3840 {
                    //JSON Error: NSCocoaErrorDomain Code=3840
                    result = .serialization
                }
            }
        }
        
        return result
    }
}

extension ActionError {
    
    func castUnderlyingError<T>(to errorType: T.Type) -> T? where T: Swift.Error {
        switch self {
        case .underlyingError(let error):
            // Might be nested within multiple actions
            if let actionError = error as? ActionError {
                if case .underlyingError = actionError {
                    return actionError.castUnderlyingError(to: T.self)
                }
            }
            return error as? T
        default: return nil
        }
    }
    
    func retrieveUnderlyingErrorResponse() -> JSON? {
        guard let underlyingError = castUnderlyingError(to: Moya.MoyaError.self) else { return nil }
        
        switch underlyingError {
        case .statusCode(let response):
            return try? JSON(data: response.data)
        default:
            return nil
        }
    }
    
}

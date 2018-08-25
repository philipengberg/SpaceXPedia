//
//  ModelExtensions.swift
//  SpaceX
//
//  Created by Philip Engberg on 20/08/2018.
//  Copyright © 2018 Simple Sense. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift
import SwiftyJSON

typealias JSONDict = [String: Any]

protocol Serialization {
    init?(json: JSON)
}

extension Observable {
    func mapToModel<T: Serialization>(_ type: T.Type) -> Observable<T> {
        return flatMap { result -> Observable <T> in
            guard
                let json = result as? [String: Any],
                let object = type.init(json: JSON(json))
                else {
                    return Observable<T>.empty()
            }
            
            return Observable<T>.just(object)
        }
    }
    
    func mapToModels<T: Serialization>(_ type: T.Type, key: String? = nil) -> Observable<[T]> {
        return flatMap { result -> Observable <[T]> in
            
            let array: [Any]
            if let key = key {
                guard let response = result as? [String: Any], let value = response[key] as? [Any] else { return Observable<[T]>.empty() }
                array = value
            } else {
                guard let response = result as? [Any] else { return Observable<[T]>.empty() }
                array = response
            }
            
            let objects = array.compactMap { (dict) -> T? in
                return type.init(json: JSON(dict))
            }
            
            return Observable<[T]>.just(objects)
        }
    }
}


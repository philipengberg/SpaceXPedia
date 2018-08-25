//
//  RocketsViewModel.swift
//  SpaceX
//
//  Created by Philip Engberg on 20/08/2018.
//  Copyright © 2018 Simple Sense. All rights reserved.
//

import Foundation
import RxSwift

class RocketsViewModel: ValuesViewModel<Rocket> {
    
    init(api: API) {
        super.init(api: api, target: .rockets)
    }
    
}

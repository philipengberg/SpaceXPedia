//
//  StatsViewModel.swift
//  SpaceX
//
//  Created by Philip Engberg on 31/08/2018.
//  Copyright © 2018 Simple Sense. All rights reserved.
//

import Foundation
import RxSwift

class StatsViewModel: ValuesViewModel<Launch> {

    init(api: API = SpaceXAPI) {
        super.init(api: api, target: .pastLaunches)
    }
}

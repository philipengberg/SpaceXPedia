//
//  RoadsterViewModel.swift
//  SpaceX
//
//  Created by Philip Engberg on 30/08/2018.
//  Copyright © 2018 Simple Sense. All rights reserved.
//

import Foundation
import RxSwift

class RoadsterViewModel: ValueViewModel<Roadster> {
    init(api: API) {
        super.init(api: api, target: .roadster)
    }
}

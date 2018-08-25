//
//  URL+Utility.swift
//  SpaceX
//
//  Created by Philip Engberg on 24/08/2018.
//  Copyright © 2018 Simple Sense. All rights reserved.
//

import Foundation

extension URL {
    init?(string: String?) {
        guard let string = string else { return nil }
        self.init(string: string)
    }
}

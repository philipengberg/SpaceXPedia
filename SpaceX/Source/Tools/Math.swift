//
//  Math.swift
//  SpaceX
//
//  Created by Philip Engberg on 09/09/2018.
//  Copyright © 2018 Simple Sense. All rights reserved.
//

import Foundation
import UIKit

struct Math {
    static func interpolate(startX: Double, startY: Double, endX: Double, endY: Double, newX: Double) -> Double {
        return startY + (newX - startX) * ((endY - startY) / (endX-startX))
    }
    
    static func shiftNumberRange(value: CGFloat, oldMin: CGFloat, oldMax: CGFloat, newMin: CGFloat, newMax: CGFloat) -> CGFloat {
        return (newMax - newMin) / (oldMax - oldMin) * (value - oldMax) + newMax
    }
}

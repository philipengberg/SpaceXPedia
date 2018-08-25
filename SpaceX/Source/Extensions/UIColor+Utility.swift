//
//  UIColor+Utility.swift
//  SpaceX
//
//  Created by Philip Engberg on 20/08/2018.
//  Copyright © 2018 Simple Sense. All rights reserved.
//

import Foundation
import UIKit

struct ColorComponents {
    let red: CGFloat
    let green: CGFloat
    let blue: CGFloat
    let alpha: CGFloat
}

extension UIColor {
    
    var coreImageColor: CoreImage.CIColor {
        return CoreImage.CIColor(color: self)
    }
    
    var components: ColorComponents {
        let color = coreImageColor
        return ColorComponents(red: color.red, green: color.green, blue: color.blue, alpha: color.alpha)
    }
    
    convenience init(red: UInt8, green: UInt8, blue: UInt8) {
        self.init(
            red: CGFloat(red) / 255.0,
            green: CGFloat(green) / 255.0,
            blue: CGFloat(blue) / 255.0,
            alpha: 1)
    }
    
    convenience init(gray: UInt8) {
        self.init(
            red: CGFloat(gray) / 255.0,
            green: CGFloat(gray) / 255.0,
            blue: CGFloat(gray) / 255.0,
            alpha: 1)
    }
    
    convenience init(hex: String, alpha: CGFloat = 1) {
        assert(hex[hex.startIndex] == "#", "Expected hex string of format #RRGGBB")
        
        let scanner = Scanner(string: hex)
        scanner.scanLocation = 1  // skip #
        
        var rgb: UInt32 = 0
        scanner.scanHexInt32(&rgb)
        
        self.init(
            red: CGFloat((rgb   & 0xFF0000) >> 16)/255.0,
            green: CGFloat((rgb & 0xFF00)   >>  8)/255.0,
            blue: CGFloat((rgb  & 0xFF)          )/255.0,
            alpha: alpha)
    }
}

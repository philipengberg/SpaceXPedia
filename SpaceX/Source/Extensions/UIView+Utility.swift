//
//  UIView+Utility.swift
//  SpaceX
//
//  Created by Philip Engberg on 20/08/2018.
//  Copyright © 2018 Simple Sense. All rights reserved.
//

import Foundation
import UIKit

extension UIView {
    internal func addSubviews(_ subviews: [UIView] ) {
        for view in subviews {
            self.addSubview(view)
        }
    }
    
    internal func addLayoutGuides(_ guides: [UILayoutGuide] ) {
        for guide in guides {
            self.addLayoutGuide(guide)
        }
    }
    
    internal func maxY() -> CGFloat {
        return self.frame.maxY
    }
    
    internal func minY() -> CGFloat {
        return self.frame.minY
    }
    
    var width: CGFloat { get { return self.frame.size.width }  set { self.frame.size.width = newValue } }
    var height: CGFloat { get { return self.frame.size.height } set { self.frame.size.height = newValue } }
    var size: CGSize { get { return self.frame.size }        set { self.frame.size = newValue } }
    
    var origin: CGPoint { get { return self.frame.origin }   set { self.frame.origin = newValue } }
    var x: CGFloat { get { return self.frame.origin.x } set { self.frame.origin = CGPoint(x: newValue, y: self.frame.origin.y) } }
    var y: CGFloat { get { return self.frame.origin.y } set { self.frame.origin = CGPoint(x: self.frame.origin.x, y: newValue) } }
    var centerX: CGFloat { get { return self.center.x }       set { self.center = CGPoint(x: newValue, y: self.center.y) } }
    var centerY: CGFloat { get { return self.center.y }       set { self.center = CGPoint(x: self.center.x, y: newValue) } }
    
    var boundsCenter: CGPoint { get { return CGPoint(x: self.bounds.midX, y: self.bounds.midY) } }
    var boundsCenterX: CGFloat { get { return self.bounds.midX } }
    var boundsCenterY: CGFloat { get { return self.bounds.midY } }
    
    var left: CGFloat { get { return self.frame.origin.x }                          set { self.frame.origin.x = newValue } }
    var top: CGFloat { get { return self.frame.origin.y }                          set { self.frame.origin.y = newValue } }
    var right: CGFloat { get { return self.frame.origin.x + self.frame.size.width }  set { self.frame.origin.x = newValue - self.frame.size.width } }
    var bottom: CGFloat { get { return self.frame.origin.y + self.frame.size.height } set { self.frame.origin.y = newValue - self.frame.size.height } }
    
    func roundCorners(_ radius: CGFloat) {
        self.layer.cornerRadius = radius
    }
    
}

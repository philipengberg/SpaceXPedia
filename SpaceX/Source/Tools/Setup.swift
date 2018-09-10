//
//  Setup.swift
//  SpaceX
//
//  Created by Philip Engberg on 20/08/2018.
//  Copyright © 2018 Simple Sense. All rights reserved.
//

import Foundation
import UIKit

public protocol Setup: NSObjectProtocol {}

extension Setup {
    @discardableResult public func setUp(_ block: (Self) -> Void) -> Self {
        block(self)
        return self
    }
}

extension UIView: Setup {}
extension UIGestureRecognizer: Setup {}
extension UICollectionViewLayout: Setup {}
extension UINavigationItem: Setup {}
extension NSMutableParagraphStyle: Setup {}
extension CALayer: Setup {}
extension NumberFormatter: Setup {}
extension DateFormatter: Setup {}
extension DateComponentsFormatter: Setup {}

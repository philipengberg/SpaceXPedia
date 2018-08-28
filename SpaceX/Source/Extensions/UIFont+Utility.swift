//
//  UIFont+Utility.swift
//  SpaceX
//
//  Created by Philip Engberg on 27/08/2018.
//  Copyright © 2018 Simple Sense. All rights reserved.
//

import Foundation
import UIKit

extension UIFont {
    func sizeOfString (_ string: String, constrainedToWidth width: CGFloat, attributes: [NSAttributedStringKey: AnyObject]? = nil) -> CGSize {
        if string.isEmpty {
            return CGSize.zero
        }
        var attr: [NSAttributedStringKey: AnyObject] = [NSAttributedStringKey.font: self]
        
        for (k, v) in attributes ?? [:] {
            attr.updateValue(v, forKey: k)
        }
        
        return NSString(string: string).boundingRect(with: CGSize(width: width, height: CGFloat.greatestFiniteMagnitude),
                                                     options: [.usesLineFragmentOrigin, .usesFontLeading],
                                                     attributes: attr,
                                                     context: nil).size
    }
}

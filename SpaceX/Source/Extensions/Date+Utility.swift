//
//  Date+Utility.swift
//  SpaceX
//
//  Created by Philip Engberg on 26/08/2018.
//  Copyright © 2018 Simple Sense. All rights reserved.
//

import Foundation

extension Date {
    
    func nukeHoursMinutesSeconds() -> Date? {
        return Calendar.current.date(from: Calendar.current.dateComponents([.year, .month, .day], from: self))
    }
    
}

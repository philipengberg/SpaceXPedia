//
//  LaunchTimelineViewModel.swift
//  SpaceX
//
//  Created by Philip Engberg on 26/08/2018.
//  Copyright © 2018 Simple Sense. All rights reserved.
//

import Foundation
import RxSwift
import DateToolsSwift

class LaunchTimelineViewModel: ValuesViewModel<Launch> {
    
    enum RowType {
        case emptyDay
        case emptyMonthStart(Date)
        case launch(Launch)
    }
    
    let dataSource = Variable<[RowType]>([])
    
    init(api: API) {
        super.init(api: api, target: .allLaunches)
        
        object.asObservable().map { launches in launches.enumerated().map({ index, launch -> [RowType] in
            if index == 0 {
                return [.launch(launch)]
            } else {
                let previousLaunch = launches[index - 1]
                guard let previousLaunchDate = previousLaunch.launchDate?.nukeHoursMinutesSeconds() else { return [] }
                guard let launchDate = launch.launchDate?.nukeHoursMinutesSeconds() else { return [] }
                
                let daysDiff = launchDate.days(from: previousLaunchDate)
                
                let daysArray = Array(1..<daysDiff)
                
                let emptyRows = daysArray.map { dayIndex -> RowType in
                    let runningRefDate = previousLaunchDate.add(TimeChunk(seconds: 0, minutes: 0, hours: 0, days: dayIndex, weeks: 0, months: 0, years: 0))
                    if runningRefDate.day == 1 || runningRefDate.isToday {
                        return .emptyMonthStart(runningRefDate)
                    } else {
                        return .emptyDay
                    }
                }
                
//                let daysDiff = launchDate.days(from: previousLaunchDate)
                return emptyRows + [.launch(launch)]
            }
        }).flatMap { $0 }.reversed() }.bind(to: dataSource).disposed(by: bag)
    }
    
}

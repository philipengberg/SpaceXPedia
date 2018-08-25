//
//  LaunchesViewModel.swift
//  SpaceX
//
//  Created by Philip Engberg on 21/08/2018.
//  Copyright © 2018 Simple Sense. All rights reserved.
//

import Foundation
import RxSwift

class LaunchesViewModel: ValuesViewModel<Launch> {
    
    let filteredLaunches = Variable<[Launch]>([])
//    let pastLaunches = Variable<[Launch]>([])
//    let futureLaunches = Variable<[Launch]>([])
    
    let searchText = Variable<String?>(nil)

    override init(api: API = SpaceXAPI, target: SpaceXTarget) {
        super.init(api: api, target: target)
        
        searchText.asObservable().unwrap().map { search in self.object.value.filter { launch in
            launch.missionName.lowercased().contains(search.lowercased()) }
        }.bind(to: filteredLaunches).disposed(by: bag)
        
//        object.asObservable().map { $0.filter { !$0.upcoming } }.map { $0.reversed() }.bind(to: pastLaunches).disposed(by: bag)
//        object.asObservable().map { $0.filter {  $0.upcoming } }.bind(to: futureLaunches).disposed(by: bag)
    }
}

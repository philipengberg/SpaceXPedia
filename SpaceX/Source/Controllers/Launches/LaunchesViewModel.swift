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
    
    enum Scope: Int {
        case past, upcoming
    }
    
    let filteredLaunches = Variable<[Launch]>([])
    
    private let pastLaunches = Variable<[Launch]>([])
    private let futureLaunches = Variable<[Launch]>([])
    
    let scope = Variable<Scope>(.past)
    
    let searchText = Variable<String>("")

    init(api: API = SpaceXAPI) {
        super.init(api: api, target: .allLaunches)
        
        let scopeDataSourceObservable = scope.asObservable().map { [weak self] scope -> [Launch]? in
            switch scope {
            case .upcoming: return self?.futureLaunches.value
            case .past: return self?.pastLaunches.value
            }
        }.unwrap()
        
        Observable.combineLatest(scopeDataSourceObservable, searchText.asObservable()).map { (dataSource, searchText) in
            guard !searchText.isEmpty else { return dataSource }
            return dataSource.filter { $0.searchString.lowercased().contains(searchText.lowercased()) }
        }.bind(to: filteredLaunches).disposed(by: bag)
        
        object.asObservable().map { $0.filter { !$0.upcoming } }.map { $0.reversed() }.bind(to: pastLaunches).disposed(by: bag)
        object.asObservable().map { $0.filter {  $0.upcoming } }.bind(to: futureLaunches).disposed(by: bag)
    }
}

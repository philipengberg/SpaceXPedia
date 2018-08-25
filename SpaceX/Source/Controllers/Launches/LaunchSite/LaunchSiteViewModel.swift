//
//  LaunchSiteViewModel.swift
//  SpaceX
//
//  Created by Philip Engberg on 23/08/2018.
//  Copyright © 2018 Simple Sense. All rights reserved.
//

import Foundation
import RxSwift
import MapKit

class LaunchSiteViewModel: ValueViewModel<LaunchSite> {
    
    let location = Variable<CLLocation?>(nil)
    
    init(launchSiteId: String) {
        super.init(api: SpaceXAPI, target: .launchSite(id: launchSiteId))
        
        object.asObservable().unwrap().map { CLLocation(latitude: $0.location.latitude, longitude: $0.location.longitude) }.bind(to: location).disposed(by: bag)
    }
    
}

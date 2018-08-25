//
//  MapCell.swift
//  SpaceX
//
//  Created by Philip Engberg on 23/08/2018.
//  Copyright © 2018 Simple Sense. All rights reserved.
//

import Foundation
import UIKit
import MapKit

class MapCell: UITableViewCell {
    
    let mapView = MKMapView().setUp {
        $0.mapType = .hybrid
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.addSubviews([mapView])
        
        setNeedsUpdateConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func updateConstraints() {
        
        mapView.snp.updateConstraints { (make) in
            make.left.top.right.equalToSuperview()
            make.height.equalTo(300)
        }
        
        super.updateConstraints()
    }
}

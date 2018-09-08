//
//  ShipDetailView.swift
//  SpaceX
//
//  Created by Philip Engberg on 08/09/2018.
//  Copyright © 2018 Simple Sense. All rights reserved.
//

import UIKit

class ShipDetailView: UIView {
    
    let tableView = UITableView().setUp {
        $0.estimatedRowHeight = 44
    }
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        
        addSubviews([tableView])
        
        setNeedsUpdateConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func updateConstraints() {
        
        tableView.snp.updateConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
        super.updateConstraints()
    }
}

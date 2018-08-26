//
//  LaunchTimelineView.swift
//  SpaceX
//
//  Created by Philip Engberg on 26/08/2018.
//  Copyright © 2018 Simple Sense. All rights reserved.
//

import UIKit

class LaunchTimelineView: UIView {
    
    let tableView = UITableView(frame: .zero).setUp {
        $0.backgroundColor = .clear
    }
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        
        addSubviews([tableView])
        
        backgroundColor = #colorLiteral(red: 0.03137254902, green: 0.3254901961, blue: 0.5254901961, alpha: 1)
        
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

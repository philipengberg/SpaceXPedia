//
//  LaunchesView.swift
//  SpaceX
//
//  Created by Philip Engberg on 21/08/2018.
//  Copyright © 2018 Simple Sense. All rights reserved.
//

import UIKit

class LaunchesView: UIView {
    
    let tableView = UITableView(frame: .zero).setUp {
        $0.backgroundColor = .clear
        $0.keyboardDismissMode = .onDrag
    }
    
    let refreshControl = UIRefreshControl().setUp {
        $0.tintColor = .white
    }
    
    let segmentedControl = UISegmentedControl(items: ["Past", "Upcoming"]).setUp {
        $0.tintColor = .white
    }
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        
        tableView.refreshControl = refreshControl
        
        addSubviews([segmentedControl, tableView])
        
        backgroundColor = #colorLiteral(red: 0.03137254902, green: 0.3254901961, blue: 0.5254901961, alpha: 1)
        
        setNeedsUpdateConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func updateConstraints() {
        
        segmentedControl.snp.updateConstraints { (make) in
            make.top.equalToSuperview().offset(5)
            make.width.equalToSuperview().offset(-30)
            make.centerX.equalToSuperview()
        }
        
        tableView.snp.updateConstraints { (make) in
            make.top.equalTo(segmentedControl.snp.bottom).offset(10)
            make.left.bottom.right.equalToSuperview()
        }
        
        super.updateConstraints()
    }
}

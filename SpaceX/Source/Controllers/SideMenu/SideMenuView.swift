//
//  SideMenuView.swift
//  SpaceX
//
//  Created by Philip Engberg on 09/09/2018.
//  Copyright © 2018 Simple Sense. All rights reserved.
//

import UIKit

class SideMenuView: UIView {
    
    let tableView = UITableView().setUp {
        $0.backgroundColor = .clear
        $0.separatorStyle = .none
    }
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        
        backgroundColor = UIColor(red: 249, green: 249, blue: 249)
        
        addSubviews([tableView])
        
        setNeedsUpdateConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func updateConstraints() {
        
        tableView.snp.updateConstraints { (make) in
            make.top.equalToSuperview().offset(UIApplication.shared.statusBarFrame.height)
            make.left.bottom.right.equalToSuperview()
        }
        
        super.updateConstraints()
    }
}

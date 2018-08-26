//
//  LaunchTimelineDayCell.swift
//  SpaceX
//
//  Created by Philip Engberg on 26/08/2018.
//  Copyright © 2018 Simple Sense. All rights reserved.
//

import Foundation
import UIKit

class LaunchTimelineDayCell: UITableViewCell {
    
    private let circleImageView = UIView().setUp {
        $0.backgroundColor = .white
    }
    
    private let lineView = UIView().setUp {
        $0.backgroundColor = .white
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        backgroundColor = .clear
        
        contentView.addSubviews([circleImageView, lineView])
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        circleImageView.size = CGSize(width: 6, height: 6)
        circleImageView.layer.cornerRadius = 3
        
        lineView.width = 2
        lineView.top = circleImageView.bottom
        lineView.height = contentView.height - circleImageView.height
        lineView.left = 40
        
        circleImageView.centerX = lineView.centerX
    }
}

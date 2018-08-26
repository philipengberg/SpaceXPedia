//
//  LaunchTimelineDayCell.swift
//  SpaceX
//
//  Created by Philip Engberg on 26/08/2018.
//  Copyright © 2018 Simple Sense. All rights reserved.
//

import Foundation
import UIKit

class LaunchTimelineLaunchCell: UITableViewCell {
    
    private let circleImageView = UIView().setUp {
        $0.backgroundColor = .white
    }
    
    private let lineView = UIView().setUp {
        $0.backgroundColor = .white
    }
    
    private let nameLabel = UILabel().setUp {
        $0.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
        $0.textColor = .white
    }
    
    private let dateLabel = UILabel().setUp {
        $0.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        $0.textColor = .white
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        backgroundColor = .clear
        
        contentView.addSubviews([circleImageView, lineView, nameLabel, dateLabel])
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        circleImageView.size = CGSize(width: 24, height: 24)
        circleImageView.layer.cornerRadius = 12
        
        lineView.width = 2
        lineView.top = circleImageView.bottom
        lineView.height = contentView.height - circleImageView.height
        lineView.left = 40
        
        circleImageView.centerX = lineView.centerX
        
        nameLabel.sizeToFit()
        nameLabel.left = 68
        nameLabel.top = circleImageView.top
        
        dateLabel.sizeToFit()
        dateLabel.top = nameLabel.bottom + 4
        dateLabel.left = 68
    }
    
    func configure(with launch: Launch) {
        nameLabel.text = launch.missionName
        dateLabel.text = DateFormatter.launchDateFormatter.string(from: launch.launchDate!)
    }
}

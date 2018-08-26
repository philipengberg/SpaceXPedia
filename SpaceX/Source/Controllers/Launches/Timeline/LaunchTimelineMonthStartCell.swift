//
//  LaunchTimelineDayCell.swift
//  SpaceX
//
//  Created by Philip Engberg on 26/08/2018.
//  Copyright © 2018 Simple Sense. All rights reserved.
//

import Foundation
import UIKit

class LaunchTimelineMonthStartCell: UITableViewCell {
    
    private static let dateFormatter = DateFormatter().setUp {
        $0.dateStyle = .medium
    }
    
    private let circleImageView = UIView().setUp {
        $0.backgroundColor = .white
    }
    
    private let lineView = UIView().setUp {
        $0.backgroundColor = .white
    }
    
    private let dateLabel = UILabel().setUp {
        $0.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        $0.text = "Feb 1 2018".uppercased()
        $0.textColor = .white
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        backgroundColor = .clear
        
        contentView.addSubviews([circleImageView, lineView, dateLabel])
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        circleImageView.size = CGSize(width: 12, height: 12)
        circleImageView.layer.cornerRadius = 6
        
        lineView.width = 2
        lineView.top = circleImageView.bottom
        lineView.height = contentView.height - circleImageView.height
        lineView.left = 40
        
        circleImageView.centerX = lineView.centerX
        
        dateLabel.sizeToFit()
        dateLabel.centerY = circleImageView.centerY
        dateLabel.left = 68
    }
    
    func configure(with date: Date) {
        if date.isToday {
            dateLabel.text = "Today".uppercased()
        } else {
            dateLabel.text = LaunchTimelineMonthStartCell.dateFormatter.string(from: date)
        }
    }
}

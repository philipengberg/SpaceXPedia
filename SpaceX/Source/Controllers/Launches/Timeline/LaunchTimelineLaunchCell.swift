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
    
    private static let descriptionFont = UIFont.systemFont(ofSize: 14, weight: .regular)
    
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
    
    private let descriptionLabel = UILabel().setUp {
        $0.font = LaunchTimelineLaunchCell.descriptionFont
        $0.textColor = .white
        $0.numberOfLines = 0
    }
    
    private let rocketImageView = UIImageView(image: #imageLiteral(resourceName: "rocket-falcon-heavy")).setUp {
        $0.contentMode = .scaleAspectFit
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        backgroundColor = .clear
        
        contentView.addSubviews([circleImageView, lineView, nameLabel, dateLabel, descriptionLabel, rocketImageView])
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private static let rocketWidth: CGFloat = 60
    
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
        dateLabel.left = nameLabel.left
        
        rocketImageView.width = 60
        rocketImageView.height = 295
        rocketImageView.top = 0
        rocketImageView.right = contentView.width - 20
        
        descriptionLabel.left = nameLabel.left
        descriptionLabel.top = dateLabel.bottom + 10
        descriptionLabel.width = rocketImageView.left - descriptionLabel.left - 10
        descriptionLabel.sizeToFit()
    }
    
    func configure(with launch: Launch) {
        nameLabel.text = launch.missionName
        dateLabel.text = DateFormatter.launchDateFormatter.string(from: launch.launchDate!)
        descriptionLabel.text = launch.details ?? "No description"
        rocketImageView.image = launch.rocket.versionAndPayloadSpecificRocketImage
        
        setNeedsLayout()
    }
    
    static func height(for launch: Launch, constrainedTo width: CGFloat) -> CGFloat {
        let constrainWidth = width - rocketWidth - 10 - 68 - 20
        let fallbackHeight: CGFloat = 310
        guard let description = launch.details else { return fallbackHeight }
        return max(fallbackHeight, descriptionFont.sizeOfString(description, constrainedToWidth: constrainWidth).height + 52)
    }
}

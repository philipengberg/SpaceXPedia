//
//  LaunchOverViewCell.swift
//  SpaceX
//
//  Created by Philip Engberg on 21/08/2018.
//  Copyright © 2018 Simple Sense. All rights reserved.
//

import AlamofireImage
import Foundation
import UIKit
import DateToolsSwift

class LaunchOverviewCell: UITableViewCell {
    
    private let backgroundImageView = UIImageView(image: #imageLiteral(resourceName: "launch-background"))
    
    private let actualContentView = UIView()
    
    private let missionPatchImageView = UIImageView()
    
    private let nameLabel = UILabel().setUp {
        $0.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
    }
    
    private let dateIconImageView = UIImageView(image: #imageLiteral(resourceName: "watch-icon")).setUp {
        $0.contentMode = .scaleAspectFit
    }
    
    private let launchDateLabel = UILabel().setUp {
        $0.textColor = .lightTextColor
        $0.font = UIFont.systemFont(ofSize: 14)
    }
    
    private let launchSiteIconImageView = UIImageView(image: #imageLiteral(resourceName: "map-icon")).setUp {
        $0.contentMode = .scaleAspectFit
    }
    
    private let launchSiteLabel = UILabel().setUp {
        $0.textColor = .lightTextColor
        $0.font = UIFont.systemFont(ofSize: 14)
    }
    
    private let vehicleIconImageView = UIImageView(image: #imageLiteral(resourceName: "rocket-icon")).setUp {
        $0.contentMode = .scaleAspectFit
    }
    
    private let vehicleNameLabel = UILabel().setUp {
        $0.textColor = .lightTextColor
        $0.font = UIFont.systemFont(ofSize: 14)
    }
    
    private let countdownLabel = UILabel().setUp {
        $0.textColor = .lightTextColor
        $0.font = UIFont.systemFont(ofSize: 14, weight: .medium)
    }
    
    private var payloadOrbitTagViews = [TagView]()
    private var landingSiteTagViews = [TagView]()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        backgroundColor = .clear
        
        contentView.addSubviews([backgroundImageView, actualContentView])
        actualContentView.addSubviews([missionPatchImageView, nameLabel, dateIconImageView, launchDateLabel, launchSiteIconImageView, launchSiteLabel, vehicleIconImageView, vehicleNameLabel, countdownLabel])
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        backgroundImageView.frame = contentView.bounds.insetBy(dx: 2, dy: 0)
        
        actualContentView.frame = UIEdgeInsetsInsetRect(backgroundImageView.frame, UIEdgeInsets(top: 10, left: 10, bottom: 11, right: 10))
        
        missionPatchImageView.size = CGSize(width: 100, height: 100)
        missionPatchImageView.top = 20
        missionPatchImageView.left = 16
        
        nameLabel.sizeToFit()
        nameLabel.left = missionPatchImageView.right + 14
        nameLabel.top = 16
        
        dateIconImageView.size = CGSize(width: 14, height: 14)
        dateIconImageView.left = nameLabel.left
        dateIconImageView.top = nameLabel.bottom + 4
        
        launchDateLabel.left = dateIconImageView.right + 4
        launchDateLabel.sizeToFit()
        launchDateLabel.width = actualContentView.width - launchDateLabel.left - 10
        launchDateLabel.centerY = dateIconImageView.centerY
        
        launchSiteIconImageView.size = CGSize(width: 14, height: 14)
        launchSiteIconImageView.left = nameLabel.left
        launchSiteIconImageView.top = launchDateLabel.bottom + 4
        
        launchSiteLabel.sizeToFit()
        launchSiteLabel.left = launchSiteIconImageView.right + 4
        launchSiteLabel.centerY = launchSiteIconImageView.centerY
        
        vehicleIconImageView.size = CGSize(width: 14, height: 14)
        vehicleIconImageView.left = nameLabel.left
        vehicleIconImageView.top = launchSiteLabel.bottom + 4
        
        vehicleNameLabel.sizeToFit()
        vehicleNameLabel.left = vehicleIconImageView.right + 4
        vehicleNameLabel.centerY = vehicleIconImageView.centerY
        
        payloadOrbitTagViews.enumerated().forEach { index, tagView in
            tagView.size = tagView.intrinsicContentSize
            tagView.top = round(self.vehicleNameLabel.bottom + 11)
            switch index {
            case 0: tagView.left = nameLabel.left
            default: tagView.left = self.payloadOrbitTagViews[index - 1].right + 4
            }
        }
        
        landingSiteTagViews.enumerated().forEach { index, tagView in
            tagView.size = tagView.intrinsicContentSize
            tagView.top = round(self.vehicleNameLabel.bottom + 34)
            switch index {
            case 0: tagView.left = nameLabel.left
            default: tagView.left = self.landingSiteTagViews[index - 1].right + 4
            }
        }
        
        countdownLabel.sizeToFit()
        countdownLabel.left = missionPatchImageView.left
        countdownLabel.width = missionPatchImageView.width
        countdownLabel.top = missionPatchImageView.bottom + 10
    }
    
    func configure(with launch: Launch) {
        
        nameLabel.text = launch.missionName
        
        if let firsStage = launch.rocket.firstStage {
            vehicleNameLabel.text = firsStage.cores.compactMap { $0.coreSerial }.joined(separator: ", ")
        }
        
        if let launchDate = launch.launchDate {
            launchDateLabel.text = (launch.upcoming ? "\(DateFormatter().shortWeekdaySymbols[Calendar.current.component(.weekday, from: launchDate) - 1]), " : "") + DateFormatter.launchDateFormatter.string(from: launchDate)
            
            if launch.upcoming {
                let lol = DateComponentsFormatter()
                lol.unitsStyle = .full
                lol.maximumUnitCount = 2
                countdownLabel.text = lol.string(from: TimePeriod(beginning: Date(), end: launchDate).duration)
                countdownLabel.isHidden = false
            }
        }
        
        if let missionPatch = launch.links?.missionPatch, let missionPatchUrl = URL(string: missionPatch) {
            missionPatchImageView.af_setImage(withURL: missionPatchUrl)
        }
        
        if let launchSite = launch.site?.siteName {
            launchSiteLabel.text = launchSite
        }
        
        payloadOrbitTagViews.forEach { $0.removeFromSuperview() }
        payloadOrbitTagViews = (launch.rocket.secondStage?.payloads ?? []).map({ (payload) -> TagView in
            let payloadOrbitTagView = TagView()
            payloadOrbitTagView.text = payload.orbit
            payloadOrbitTagView.image = #imageLiteral(resourceName: "orbit-icon")
            payloadOrbitTagView.isHidden = false
            
            switch launch.launchSuccess {
            case .some(let success):
                switch success {
                case true: payloadOrbitTagView.color = .succeededColor
                case false: payloadOrbitTagView.color = .failedColor
                }
            case .none: payloadOrbitTagView.color = .lightTextColor
            }
            
            return payloadOrbitTagView
        })
        actualContentView.addSubviews(payloadOrbitTagViews)
        
        landingSiteTagViews.forEach { $0.removeFromSuperview() }
        landingSiteTagViews = (launch.rocket.firstStage?.cores ?? []).compactMap({ (core) -> TagView? in
            guard let landingVehicle = core.landingVehicle else { return nil }
            let landingSiteTagView = TagView()
            landingSiteTagView.text = landingVehicle
            landingSiteTagView.image = #imageLiteral(resourceName: "landed-booster-icon")
            landingSiteTagView.isHidden = false
            
            switch core.landingSuccess {
            case .some(let success):
                switch success {
                case true: landingSiteTagView.color = .succeededColor
                case false: landingSiteTagView.color = .failedColor
                }
            case .none: landingSiteTagView.color = .lightTextColor
            }
            
            return landingSiteTagView
        })
        actualContentView.addSubviews(landingSiteTagViews)
        
        setNeedsLayout()
    }
    
    private func tagView(with text: String) -> TagView {
        let tagView = TagView()
        tagView.text = text
        return tagView
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        launchDateLabel.text = nil
        launchSiteLabel.text = nil
        
        countdownLabel.isHidden = true
        
        missionPatchImageView.image = nil
        missionPatchImageView.af_cancelImageRequest()
        
    }
}

class TagView: UIView {
    
    private let iconImageView = UIImageView().setUp {
        $0.contentMode = .scaleAspectFit
    }
    
    private let label = UILabel().setUp {
        $0.textColor = .lightGray
        $0.font = UIFont.systemFont(ofSize: 10, weight: .semibold)
    }
    
    var text: String = "" {
        didSet {
            label.text = self.text
            setNeedsLayout()
        }
    }
    
    var image: UIImage? {
        didSet {
            iconImageView.image = image?.withRenderingMode(.alwaysTemplate)
        }
    }
    
    var color: UIColor = .lightGray {
        didSet {
            label.textColor = self.color
            layer.borderColor = self.color.cgColor
            iconImageView.tintColor = color
        }
    }
    
    convenience init(text: String) {
        self.init(frame: .zero)
        self.text = text
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubviews([iconImageView, label])
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        iconImageView.sizeToFit()
        iconImageView.centerY = boundsCenterY
        iconImageView.left = 4
        
        label.sizeToFit()
        label.centerY = boundsCenterY
        label.left = iconImageView.right + 4
        
        layer.cornerRadius = 3
        layer.borderColor = self.color.cgColor
        layer.borderWidth = 1
    }
    
    override var intrinsicContentSize: CGSize {
        return CGSize(width: label.intrinsicContentSize.width + 10 + 12 + 4, height: label.intrinsicContentSize.height + 6)
    }
    
}

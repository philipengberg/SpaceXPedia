//
//  LaunchOverViewCell.swift
//  SpaceX
//
//  Created by Philip Engberg on 21/08/2018.
//  Copyright © 2018 Simple Sense. All rights reserved.
//

import AlamofireImage
import Foundation
import pop
import UIKit
import DateToolsSwift

class LaunchOverviewCell: UITableViewCell {
    
    private let backgroundImageView = UIImageView(image: #imageLiteral(resourceName: "launch-background"))
    
    private let actualContentView = UIView().setUp {
        $0.clipsToBounds = true
    }
    
    private let missionPatchImageView = UIImageView().setUp {
        $0.contentMode = .scaleAspectFit
    }
    
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
        $0.font = UIFont.systemFont(ofSize: 10, weight: .medium)
        $0.textAlignment = .center
    }
    
    private var payloadOrbitTagViews = [TagView]()
    private var landingSiteTagViews = [TagView]()
    
    private let disclosureIndicatorImageView = UIImageView(image: #imageLiteral(resourceName: "disclosure-indicator"))
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        backgroundColor = .clear
        
        contentView.addSubviews([backgroundImageView, actualContentView])
        actualContentView.addSubviews([missionPatchImageView, nameLabel, dateIconImageView, launchDateLabel, launchSiteIconImageView, launchSiteLabel, vehicleIconImageView, vehicleNameLabel, countdownLabel, disclosureIndicatorImageView])
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
        
        disclosureIndicatorImageView.sizeToFit()
        disclosureIndicatorImageView.centerY = actualContentView.boundsCenterY
        disclosureIndicatorImageView.right = actualContentView.width - 20
        
        nameLabel.sizeToFit()
        nameLabel.left = missionPatchImageView.right + 14
        nameLabel.width = actualContentView.width - nameLabel.left - 10
        nameLabel.top = 16
        
        dateIconImageView.size = CGSize(width: 14, height: 14)
        dateIconImageView.left = nameLabel.left
        dateIconImageView.top = nameLabel.bottom + 4
        
        launchDateLabel.left = dateIconImageView.right + 4
        launchDateLabel.sizeToFit()
        launchDateLabel.width = nameLabel.right - launchDateLabel.left - 5
        launchDateLabel.centerY = dateIconImageView.centerY
        
        launchSiteIconImageView.size = CGSize(width: 14, height: 14)
        launchSiteIconImageView.left = nameLabel.left
        launchSiteIconImageView.top = launchDateLabel.bottom + 4
        
        launchSiteLabel.sizeToFit()
        launchSiteLabel.left = launchSiteIconImageView.right + 4
        launchSiteLabel.width = disclosureIndicatorImageView.left - launchSiteLabel.left - 5
        launchSiteLabel.centerY = launchSiteIconImageView.centerY
        
        vehicleIconImageView.size = CGSize(width: 14, height: 14)
        vehicleIconImageView.left = nameLabel.left
        vehicleIconImageView.top = launchSiteLabel.bottom + 4
        
        vehicleNameLabel.sizeToFit()
        vehicleNameLabel.left = vehicleIconImageView.right + 4
        vehicleNameLabel.width = disclosureIndicatorImageView.left - vehicleNameLabel.left - 5
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
    
    func configure(with viewModel: LaunchOverviewCellViewModel) {
        
        nameLabel.text = viewModel.missionName
        vehicleNameLabel.text = viewModel.vehicleName
        launchDateLabel.text = viewModel.launchDataText
        countdownLabel.text = viewModel.countDownText
        launchSiteLabel.text = viewModel.launchSiteName
        
        if let missionPatch = viewModel.launch.links?.missionPatch, let missionPatchUrl = URL(string: missionPatch) {
            missionPatchImageView.af_setImage(withURL: missionPatchUrl)
            missionPatchImageView.alpha = 1
        } else {
            missionPatchImageView.image = #imageLiteral(resourceName: "launch-placeholder")
            missionPatchImageView.alpha = 1
        }
        
        payloadOrbitTagViews.forEach { $0.removeFromSuperview() }
        payloadOrbitTagViews = viewModel.payloads.map({ (payload) -> TagView in
            let payloadOrbitTagView = TagView()
            payloadOrbitTagView.text = payload.orbit
            payloadOrbitTagView.image = #imageLiteral(resourceName: "orbit-icon")
            payloadOrbitTagView.isHidden = false
            
            switch viewModel.launch.launchSuccess {
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
        landingSiteTagViews = viewModel.cores.compactMap({ (core) -> TagView? in
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
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        shrink()
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        expand()
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesCancelled(touches, with: event)
        expand()
    }
    
    func shrink() {
        let shrinkAnimation = POPBasicAnimation(propertyNamed: kPOPLayerScaleXY)
        shrinkAnimation?.toValue = NSValue(cgSize: CGSize(width: 0.95, height: 0.95))
        shrinkAnimation?.duration = 0.1
        layer.pop_add(shrinkAnimation, forKey: "shrink")
    }
    
    func expand() {
        let releaseAnimation = POPSpringAnimation(propertyNamed: kPOPLayerScaleXY)
        releaseAnimation?.toValue = NSValue(cgSize: CGSize(width: 1.0, height: 1.0))
        releaseAnimation?.velocity = NSValue(cgPoint: CGPoint(x: 1, y: 1))
        releaseAnimation?.springBounciness = 20
        layer.pop_add(releaseAnimation, forKey: "shrink")
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

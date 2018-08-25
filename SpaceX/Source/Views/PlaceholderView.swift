//
//  PlaceholderView.swift
//  SpaceX
//
//  Created by Philip Engberg on 20/08/2018.
//  Copyright © 2018 Simple Sense. All rights reserved.
//

import Action
import Foundation
import RxSwift
import UIKit

struct CallToAction {
    let title: String
    let action: CocoaAction?
}

protocol PlaceholderDataType: class {
    var placeholderTitle: String? { get }
    var placeholderTitleFont: UIFont? { get }
    var placeholderSubtitle: String { get }
    var placeholderDescription: String? { get }
    var placeholderImage: UIImage? { get }
    var placeholderCallToAction: CallToAction? { get }
    var placeholderCTAFont: UIFont? { get }
}

extension PlaceholderDataType {
    var placeholderTitle: String? { return nil }
    var placeholderTitleFont: UIFont? { return UIFont.boldSystemFont(ofSize: 24) }
    var placeholderImage: UIImage? { return nil }
    var placeholderDescription: String? { return nil }
    var placeholderCallToAction: CallToAction? { return nil }
    var placeholderCTAFont: UIFont? { return UIFont.boldSystemFont(ofSize: 11) }
}

class PlaceholderView: UIView {
    
    fileprivate let bag = DisposeBag()
    
    fileprivate let containerView = UIView()
    
    let backgroundImageView = UIImageView().setUp {
        $0.contentMode = .scaleAspectFill
        $0.clipsToBounds = true
    }
    
    fileprivate let imageView = UIImageView(image: UIImage())
    
    let titleLabel = UILabel().setUp {
        $0.font = UIFont.boldSystemFont(ofSize: 24)
        $0.numberOfLines = 2
        $0.textAlignment = .center
    }
    
    let subtitleLabel = UILabel().setUp {
        $0.font = UIFont.systemFont(ofSize: 14)
        $0.numberOfLines = 0
        $0.textAlignment = .center
    }
    
    let descriptionLabel = UILabel().setUp {
        $0.font = UIFont.systemFont(ofSize: 11)
        $0.numberOfLines = 0
        $0.textAlignment = .center
    }
    
    fileprivate var callToActionButton = UIButton(type: .system).setUp {
        $0.alpha = 0
        $0.titleLabel?.font = UIFont.boldSystemFont(ofSize: 11)
    }
    
    override init(frame: CGRect) {
        super.init(frame: UIScreen.main.bounds)
        addSubviews([backgroundImageView, containerView])
        containerView.addSubviews([imageView, titleLabel, subtitleLabel, descriptionLabel, callToActionButton])
        backgroundColor = UIColor.clear
        
        titleLabel.adjustsFontSizeToFitWidth = true
        titleLabel.minimumScaleFactor = 0.6
    }
    
    convenience init() {
        self.init(frame: .zero)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func updateConstraints() {
        
        containerView.snp.updateConstraints { (make) in
            make.center.equalToSuperview()
            make.width.lessThanOrEqualToSuperview()
        }
        
        backgroundImageView.snp.updateConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
        imageView.snp.updateConstraints { (make) in
            make.top.equalToSuperview()
            make.centerX.equalToSuperview()
        }
        
        titleLabel.snp.updateConstraints { (make) in
            make.leftMargin.equalTo(40)
            make.rightMargin.equalTo(-40)
            make.top.greaterThanOrEqualTo(imageView.snp.bottom).offset(18)
        }
        
        subtitleLabel.snp.remakeConstraints { (make) in
            if let text = titleLabel.text, !text.isEmpty {
                make.top.equalTo(titleLabel.snp.bottom).offset(6)
            } else {
                make.top.greaterThanOrEqualTo(imageView.snp.bottom).offset(18)
            }
            make.leftMargin.equalTo(40)
            make.rightMargin.equalTo(-40)
            
            if (descriptionLabel.text ?? "").isEmpty && (callToActionButton.titleLabel?.text ?? "").isEmpty {
                make.bottom.equalToSuperview()
            }
        }
        
        descriptionLabel.snp.remakeConstraints { (make) in
            if let text = subtitleLabel.text, !text.isEmpty {
                make.top.equalTo(subtitleLabel.snp.bottom).offset(8)
            } else {
                make.top.equalTo(titleLabel.snp.bottom).offset(8)
            }
            
            make.leftMargin.equalTo(40)
            make.rightMargin.equalTo(-40)
            
            if (callToActionButton.titleLabel?.text ?? "").isEmpty {
                make.bottom.equalToSuperview()
            }
        }
        
        callToActionButton.snp.updateConstraints { (make) in
            if let text = descriptionLabel.text, !text.isEmpty {
                make.top.equalTo(descriptionLabel.snp.bottom).offset(16)
            } else {
                make.top.equalTo(subtitleLabel.snp.bottom).offset(25)
            }
            
            make.bottom.equalToSuperview()
            make.height.equalTo(40)
            make.width.greaterThanOrEqualTo(180)
            make.centerX.equalToSuperview()
        }
        
        super.updateConstraints()
    }
}

extension PlaceholderView {
    
    func configure(subtitle: String, callToAction: CallToAction?, ctaFont: UIFont?, image: UIImage?, title: String? = nil, titleFont: UIFont?, description: String? = nil) {
        imageView.image = image
        titleLabel.font = titleFont
        titleLabel.text = title?.uppercased()
        subtitleLabel.text = subtitle
        descriptionLabel.text = description
        
        callToActionButton.titleLabel?.font = ctaFont
        
        if let callToAction = callToAction {
            callToActionButton.rx.action = callToAction.action
            callToActionButton.setTitle(callToAction.title.uppercased(), for: .normal)
            if callToActionButton.isHidden {
                callToActionButton.alpha = 1.0
            }
            callToActionButton.isHidden = false
        } else {
            callToActionButton.isHidden = true
        }
        
        setNeedsUpdateConstraints()
        setNeedsLayout()
        layoutIfNeeded()
    }
    
    func configure(data: PlaceholderDataType?) {
        guard let data = data else { return }
        
        configure(subtitle: data.placeholderSubtitle,
                  callToAction: data.placeholderCallToAction,
                  ctaFont: data.placeholderCTAFont,
                  image: data.placeholderImage,
                  title: data.placeholderTitle,
                  titleFont: data.placeholderTitleFont,
                  description: data.placeholderDescription)
    }
}

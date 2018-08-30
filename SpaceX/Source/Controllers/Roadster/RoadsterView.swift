//
//  RoadsterView.swift
//  SpaceX
//
//  Created by Philip Engberg on 30/08/2018.
//  Copyright © 2018 Simple Sense. All rights reserved.
//

import UIKit

class RoadsterView: UIView {
    
    private let roadsterImageView = UIImageView(image: #imageLiteral(resourceName: "roadster")).setUp {
        $0.contentMode = .scaleAspectFit
    }
    
    let textLabel = UILabel().setUp {
        $0.numberOfLines = 0
    }
    
    private let updatedLabel = UILabel().setUp {
        $0.font = UIFont.italicSystemFont(ofSize: 14)
        $0.textColor = #colorLiteral(red: 0.337254902, green: 0.431372549, blue: 0.5843137255, alpha: 1)
        $0.textAlignment = .center
        $0.text = "Updated every 10 min"
        $0.alpha = 0.5
    }
    
    let spinner = UIActivityIndicatorView().setUp {
        $0.color = #colorLiteral(red: 0.337254902, green: 0.431372549, blue: 0.5843137255, alpha: 1)
    }
    
    private let gradientLayer = CAGradientLayer()
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        
        gradientLayer.startPoint = CGPoint(x: 0, y: 0)
        gradientLayer.endPoint = CGPoint(x: 1, y: 1)
        gradientLayer.colors = [#colorLiteral(red: 0.0862745098, green: 0.01568627451, blue: 0.1725490196, alpha: 1).cgColor, #colorLiteral(red: 0.003921568627, green: 0.05098039216, blue: 0.09411764706, alpha: 1).cgColor]
        
        self.layer.addSublayer(gradientLayer)
        
        addSubviews([roadsterImageView, textLabel, updatedLabel, spinner])
        
        setNeedsUpdateConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        gradientLayer.frame = bounds
    }
    
    override func updateConstraints() {
        
        roadsterImageView.snp.updateConstraints { (make) in
            make.top.greaterThanOrEqualTo(safeAreaLayoutGuide)
            make.top.lessThanOrEqualTo(safeAreaLayoutGuide).offset(40)
            make.width.equalToSuperview().offset(-100)
            make.centerX.equalToSuperview()
            make.height.lessThanOrEqualTo(roadsterImageView.snp.width)
        }
        
        textLabel.snp.updateConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.lessThanOrEqualTo(roadsterImageView.snp.bottom).offset(20)
            make.width.equalToSuperview().offset(-60)
            make.bottom.equalTo(updatedLabel.snp.top).offset(-20)
        }
        
        updatedLabel.snp.updateConstraints { (make) in
            make.centerX.equalToSuperview()
            make.bottom.greaterThanOrEqualTo(safeAreaLayoutGuide).offset(-20)
            make.bottom.lessThanOrEqualTo(safeAreaLayoutGuide)
        }
        
        spinner.snp.updateConstraints { (make) in
            make.center.equalTo(textLabel)
        }
        
        super.updateConstraints()
    }
}

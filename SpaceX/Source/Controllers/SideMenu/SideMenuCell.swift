//
//  SideMenuCell.swift
//  SpaceX
//
//  Created by Philip Engberg on 09/09/2018.
//  Copyright © 2018 Simple Sense. All rights reserved.
//

import Foundation
import UIKit

class SideMenuCell: UITableViewCell {
    
    private let selectionView = UIView().setUp {
        $0.backgroundColor = UIColor(gray: 243)
    }
    
    private let selectedIndicatorView = UIView().setUp {
        $0.backgroundColor = UIColor(red: 35, green: 111, blue: 255)
    }
    
    private let typeLabel = UILabel()
    
    private let nameLabel = UILabel().setUp {
        $0.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        $0.textColor = UIColor(red: 48, green: 47, blue: 58)
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.addSubviews([selectionView, selectedIndicatorView, typeLabel, nameLabel])
        
        backgroundColor = .clear
        
        setNeedsUpdateConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func updateConstraints() {
        
        selectionView.snp.updateConstraints { (make) in
            make.left.right.equalToSuperview()
            make.centerY.equalToSuperview()
            make.height.equalToSuperview().offset(-8)
        }
        
        selectedIndicatorView.snp.updateConstraints { (make) in
            make.left.equalToSuperview()
            make.bottom.top.equalTo(selectionView)
            make.width.equalTo(4)
        }
        
        typeLabel.snp.updateConstraints { (make) in
            make.left.equalTo(selectedIndicatorView.snp.right).offset(20)
            make.centerY.equalToSuperview()
        }
        
        nameLabel.snp.updateConstraints { (make) in
            make.left.equalTo(typeLabel.snp.right).offset(20)
            make.centerY.equalToSuperview()
        }
        
        super.updateConstraints()
    }
    
    func configure(type: String, name: String, selected: Bool) {
        typeLabel.text = type
        nameLabel.text = name
        
        selectionView.isHidden = !selected
        selectedIndicatorView.isHidden = !selected
        
        nameLabel.font = selected ? UIFont.systemFont(ofSize: 16, weight: .semibold) : UIFont.systemFont(ofSize: 16, weight: .medium)
        
        setNeedsLayout()
    }
    
}

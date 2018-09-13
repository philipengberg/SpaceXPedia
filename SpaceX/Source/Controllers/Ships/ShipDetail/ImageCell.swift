//
//  ImageCell.swift
//  SpaceX
//
//  Created by Philip Engberg on 10/09/2018.
//  Copyright © 2018 Simple Sense. All rights reserved.
//

import AlamofireImage
import Foundation
import UIKit

class ImageCell: UITableViewCell {
    
    private let theImageView = UIImageView().setUp {
        $0.contentMode = .scaleAspectFill
        $0.clipsToBounds = true
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.addSubviews([theImageView])
        
        setNeedsUpdateConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func updateConstraints() {
        
        theImageView.snp.updateConstraints { (make) in
            make.edges.equalToSuperview()
            make.height.greaterThanOrEqualTo(200)
            make.height.lessThanOrEqualTo(250)
        }
        
        super.updateConstraints()
    }
    
    func configure(with image: UIImage?) {
        theImageView.image = image
    }
    
    func configure(with imageUrl: URL?) {
        guard let url = imageUrl else { return }
        theImageView.af_setImage(withURL: url)
    }
    
}

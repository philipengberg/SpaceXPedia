//
//  LaunchVideoCell.swift
//  SpaceX
//
//  Created by Philip Engberg on 22/08/2018.
//  Copyright © 2018 Simple Sense. All rights reserved.
//

import Foundation
import UIKit
import youtube_ios_player_helper

class LaunchVideoCell: UITableViewCell {
    
    private let noVideoYetLabel = UILabel().setUp {
        $0.textColor = .lightTextColor
        $0.font = UIFont.systemFont(ofSize: 14)
        $0.text = "No video yet"
        $0.isHidden = true
        $0.textAlignment = .center
    }
    
    private let playerView = YTPlayerView()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.addSubviews([noVideoYetLabel, playerView])
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        playerView.frame = contentView.bounds
        noVideoYetLabel.frame = contentView.bounds
    }
    
    func configure(with videoId: String) {
//        playerView.loadVideo(byURL: url, startSeconds: 0, suggestedQuality: .auto)
        guard playerView.videoUrl() == nil else { return }
        playerView.load(withVideoId: videoId)
    }
    
    func showEmpty() {
        noVideoYetLabel.isHidden = false
    }
    
}

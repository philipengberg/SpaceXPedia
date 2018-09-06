//
//  StatsView.swift
//  SpaceX
//
//  Created by Philip Engberg on 31/08/2018.
//  Copyright © 2018 Simple Sense. All rights reserved.
//

import UIKit

class StatsView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        
        addSubviews([/* subviews */])
        
        backgroundColor = .white
        
        setNeedsUpdateConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func updateConstraints() {
        
        
        
        super.updateConstraints()
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        var startPoint = -CGFloat.pi/2
        var endPoint = startPoint + 0.1 * 2 * CGFloat.pi
        
        let path = UIBezierPath(arcCenter: CGPoint(x: rect.width / 2, y: rect.height / 2), radius: 100, startAngle: startPoint, endAngle: endPoint, clockwise: true)
        let shape = CAShapeLayer()
        shape.path = path.cgPath
        shape.fillColor = UIColor.clear.cgColor
        shape.strokeColor = #colorLiteral(red: 0.9176470588, green: 0.9176470588, blue: 0.9176470588, alpha: 1).cgColor
        shape.lineCap = kCALineCapRound
        shape.lineWidth = 6
        self.layer.addSublayer(shape)
        
        let path2 = UIBezierPath(arcCenter: CGPoint(x: rect.width / 2, y: rect.height / 2), radius: 100, startAngle: startPoint, endAngle: startPoint + 0.05 * 2 * CGFloat.pi, clockwise: true)
        let shape2 = CAShapeLayer()
        shape2.path = path2.cgPath
        shape2.fillColor = UIColor.clear.cgColor
        shape2.strokeColor = #colorLiteral(red: 0.9529411765, green: 0.5960784314, blue: 0.3137254902, alpha: 1).cgColor
        shape2.lineCap = kCALineCapRound
        shape2.lineWidth = 6
        self.layer.addSublayer(shape2)
        
        startPoint = endPoint + 0.03 * 2 * CGFloat.pi
        endPoint = startPoint + 0.2 * 2 * CGFloat.pi
        
        let path3 = UIBezierPath(arcCenter: CGPoint(x: rect.width / 2, y: rect.height / 2), radius: 100, startAngle: startPoint, endAngle: endPoint, clockwise: true)
        let shape3 = CAShapeLayer()
        shape3.path = path3.cgPath
        shape3.fillColor = UIColor.clear.cgColor
        shape3.strokeColor = #colorLiteral(red: 0.9176470588, green: 0.9176470588, blue: 0.9176470588, alpha: 1).cgColor
        shape3.lineCap = kCALineCapRound
        shape3.lineWidth = 6
        self.layer.addSublayer(shape3)
        
        let path4 = UIBezierPath(arcCenter: CGPoint(x: rect.width / 2, y: rect.height / 2), radius: 100, startAngle: startPoint, endAngle: startPoint + 0.1 * 2 * CGFloat.pi, clockwise: true)
        let shape4 = CAShapeLayer()
        shape4.path = path4.cgPath
        shape4.fillColor = UIColor.clear.cgColor
        shape4.strokeColor = #colorLiteral(red: 0.9607843137, green: 0.4039215686, blue: 0.7176470588, alpha: 1).cgColor
        shape4.lineCap = kCALineCapRound
        shape4.lineWidth = 6
        self.layer.addSublayer(shape4)
    }
}

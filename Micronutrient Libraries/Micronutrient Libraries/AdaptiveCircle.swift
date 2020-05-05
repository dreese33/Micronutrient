//
//  AdaptiveCircle.swift
//  Micronutrient Libraries
//
//  Created by Eric Reese on 5/4/20.
//  Copyright © 2020 ReeseGames. All rights reserved.
//

import UIKit

class AdaptiveCircle: UIView {
    
    private var circleRadius: CGFloat?
    
    init(radius: CGFloat, centerPt: CGPoint, percentComplete: CGFloat, borderWidth: CGFloat = 10, borderColor: CGColor = UIColor.red.cgColor) {
        super.init(frame: CGRect(x: centerPt.x - radius * 2, y: centerPt.y - radius * 2, width: radius * 2, height: radius * 2))
        self.circleRadius = radius
        
        let innerCirclePath = UIBezierPath(arcCenter: centerPt, radius: radius - 10, startAngle: 0.0, endAngle: CGFloat.pi * 2, clockwise: true)
        let innerShapeLayer = CAShapeLayer()
        
        let outerCirclePath = UIBezierPath(arcCenter: centerPt, radius: radius, startAngle: 0.0, endAngle: CGFloat.pi * 2 * percentComplete, clockwise: true)
        let outerCircleLayer = CAShapeLayer()
        
        innerShapeLayer.path = innerCirclePath.cgPath
        innerShapeLayer.fillColor = UIColor.clear.cgColor
        innerShapeLayer.strokeColor = UIColor.black.cgColor
        self.layer.addSublayer(innerShapeLayer)
        
        outerCircleLayer.path = outerCirclePath.cgPath
        outerCircleLayer.fillColor = UIColor.clear.cgColor
        outerCircleLayer.strokeColor = borderColor
        outerCircleLayer.lineWidth = borderWidth
        self.layer.addSublayer(outerCircleLayer)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func setCircleRadius(radius: CGFloat) {
        self.circleRadius = radius
    }
    
    func getCircleRadius() -> CGFloat {
        if let radius = self.circleRadius {
            return radius
        }
        
        return 0.0
    }
}

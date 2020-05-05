//
//  AdaptiveCircle.swift
//  Micronutrient Libraries
//
//  Created by Eric Reese on 5/4/20.
//  Copyright © 2020 ReeseGames. All rights reserved.
//

import UIKit

class AdaptiveCircle: UIView {
    
    private var innerCircle = CAShapeLayer()
    private var outerCircle = CAShapeLayer()
    private var maskLayer = CAShapeLayer()
    
    private var circleRadius: CGFloat?
    private var currentPercentage: CGFloat?
    
    init(radius: CGFloat, centerPt: CGPoint, percentComplete: CGFloat, borderWidth: CGFloat = 10, borderColor: CGColor = UIColor.red.cgColor) {
        
        super.init(frame: CGRect(x: centerPt.x, y: centerPt.y, width: radius * 2, height: radius * 2))
        self.circleRadius = radius
        self.center = centerPt
        
        let modifiedCenter = CGPoint(x: centerPt.x - radius, y: centerPt.y - radius)
        
        let innerCirclePath = UIBezierPath(arcCenter: modifiedCenter, radius: radius - 10, startAngle: 0.0, endAngle: CGFloat.pi * 2, clockwise: true)
        
        let outerCirclePath = UIBezierPath(arcCenter: modifiedCenter, radius: radius, startAngle: 0.0, endAngle: CGFloat.pi * 2 * percentComplete, clockwise: true)
        
        self.innerCircle.path = innerCirclePath.cgPath
        self.innerCircle.fillColor = UIColor.clear.cgColor
        self.innerCircle.strokeColor = UIColor.black.cgColor
        self.innerCircle.lineWidth = 1.5
        self.layer.addSublayer(self.innerCircle)
        
        self.outerCircle.path = outerCirclePath.cgPath
        self.outerCircle.fillColor = UIColor.clear.cgColor
        self.outerCircle.strokeColor = borderColor
        self.outerCircle.lineWidth = borderWidth
        self.outerCircle.lineCap = .round
        self.layer.addSublayer(self.outerCircle)
        
        self.currentPercentage = percentComplete
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func getCircleRadius() -> CGFloat {
        if let radius = self.circleRadius {
            return radius
        }
        
        return -1
    }
    
    func getPercentComplete() -> CGFloat {
        if let percent = self.currentPercentage {
            return percent
        }
        
        return -1
    }
    
    func updateCirclePercent(percent: CGFloat, time: CGFloat) throws {
        if percent < 0 || percent > 1 {
            throw AdaptiveCircleException.PercentOutOfRange(message: "Percentage should be between 0 and 1")
        }
        
        if let rad = self.circleRadius, let per = self.currentPercentage {
            
            CATransaction.begin()
            
            let outerCirclePath = UIBezierPath(arcCenter: CGPoint(x: self.center.x - rad, y: self.center.y - rad), radius: rad, startAngle: 0.0, endAngle: CGFloat.pi * 2 * percent, clockwise: true)
            
            self.outerCircle.path = outerCirclePath.cgPath
            let animation = CABasicAnimation(keyPath: "strokeEnd")
            animation.duration = CFTimeInterval(time)
            animation.fromValue = percent * per
            animation.toValue = 1
            
            self.outerCircle.add(animation, forKey: animation.keyPath)
            CATransaction.commit()

        } else {
            throw AdaptiveCircleException.AdaptiveValuesNotSet(message: "Appropriate values not set in AdaptiveCircle")
        }
        
        self.currentPercentage = percent
    }
}

//
//  GCLoadingView.swift
//  GCLoadingAnimationTwo
//
//  Created by 宫城 on 16/8/15.
//  Copyright © 2016年 宫城. All rights reserved.
//

import UIKit

class GCLoadingView: UIView {

    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */
    enum GCLoadingResult {
        case GCLoadingResultSuccess
        case GCLoadingResultFailure
    }
    
    var loadResult: GCLoadingResult = .GCLoadingResultSuccess
    
//    var beginPointAngle: CGFloat = 0.0
//    var endPointAngle: CGFloat = 0.0
    var roundLayer: CAShapeLayer = CAShapeLayer()
    var pointLayer: CAShapeLayer = CAShapeLayer()
    
    var progress: CGFloat = 0.0 {
        willSet {
            loadingAniamtion(progress)
        }
    }
    
    override func layoutSubviews() {
        self.backgroundColor = UIColor.orangeColor()
        self.layer.addSublayer(self.roundLayer)
        self.layer.addSublayer(self.pointLayer)
        super.layoutSubviews()
    }
    
    func loadingAniamtion(progress: CGFloat) {
        let beginPointAngle = CGFloat(M_PI)*3/2 - CGFloat(M_PI)*3/2*progress
        let endPointAngle = CGFloat(M_PI)*3/2 - CGFloat(M_PI)*7/2*progress
        var radius: CGFloat = 0.0
        if self.frame.size.width >= self.frame.size.height {
            radius = self.frame.size.height/2
        } else {
            radius = self.frame.size.width/2
        }
        let path = UIBezierPath(arcCenter: CGPoint(x: self.frame.size.width/2, y: self.frame.size.height/2), radius: radius, startAngle: beginPointAngle, endAngle: endPointAngle, clockwise: false)
        self.roundLayer.path = path.CGPath
        self.roundLayer.fillColor = UIColor.clearColor().CGColor
        self.roundLayer.strokeColor = UIColor.blackColor().CGColor
        self.roundLayer.lineWidth = 5
        
        if progress == 1.0 {
            if loadResult == .GCLoadingResultSuccess {
                successAnimation()
            } else {
                failureAniamtion()
            }
        }
    }
    
    func successAnimation() {
        print("success")
        
    }
    
    func failureAniamtion() {
        print("failure")
    }
}

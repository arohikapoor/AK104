//
//  PlusButton.swift
//  Final
//
//  Created by Arohi Kapoor on 8/7/16.
//  Copyright © 2016 Arohi Kapoor. All rights reserved.
//

import UIKit

class PlusButton: UIButton {
    var fillColor = UIColor.blueColor()
    var xColor = UIColor.whiteColor()
    var xProportion = CGFloat(0.6)
    var widthProportion = CGFloat(0.08)
 
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        let path = UIBezierPath(ovalInRect: rect)
        fillColor.setFill()
        path.fill()
        
        //set up the width and height variables
        //for the horizontal stroke
        let lineWidth: CGFloat = sqrt(bounds.width*bounds.height) * widthProportion
        
        //create the path
        let plusPath = UIBezierPath()
        
        //set the path's line width to the height of the stroke
        plusPath.lineWidth = lineWidth
        
        //move the initial point of the path
        //to the start of the horizontal stroke
        plusPath.moveToPoint(CGPoint(
            x:bounds.width/2 ,
            y:0))
        
        //add a point to the path at the end of the stroke
        plusPath.addLineToPoint(CGPoint(
            x:bounds.width/2 ,
            y:bounds.height))
        
        //draw the stroke
        //        plusPath.stroke()
        
        //move the initial point of the path
        //to the start of the horizontal stroke
        plusPath.moveToPoint(CGPoint(
            x:0,
            y:bounds.height/2))
        
        //add a point to the path at the end of the stroke
        plusPath.addLineToPoint(CGPoint(
            x:bounds.width,
            y:bounds.height/2))
        
        //set the stroke color
        xColor.setStroke()
        
        //draw the stroke
        plusPath.stroke()
    }


}

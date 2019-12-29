//
//  DragImageView.swift
//  Sonic Rush
//
//  Created by Lyubomir on 27/12/2019.
//  Copyright © 2019 Lyubomir Stanoev. All rights reserved.
//

import UIKit

class DragImageView: UIImageView {
    
    //Global variables for size and starting location
    let w = UIScreen.main.bounds.width
    let h = UIScreen.main.bounds.height
    var startLocation: CGPoint?
    var endLocation: CGPoint?
    
    //set myDelegate as attribute of ReleaseDelegate data type
    var myDelegate: ReleaseDelegate?
    var myDelegateAngle: UpdateAngle?
    var xVelocity: CGFloat = 0
    var yVelocity: CGFloat = 0
    var x: CGFloat = 0
    var y: CGFloat = 0
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        startLocation = touches.first?.location(in: self)
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        //Variables for current location
        let currentLocation = touches.first?.location(in: self)
        let dx = currentLocation!.x - startLocation!.x
        let dy = currentLocation!.y - startLocation!.y
        
        var newCenter = CGPoint(x: self.center.x+dx, y: self.center.y+dy)
        
        //Constraints for Aim object's horizontal movement
        newCenter.x = min(w*0.25, newCenter.x)
        newCenter.x = max(0, newCenter.x)
        
        //Constraints for Aim object's vertical movement
        newCenter.y = min(self.superview!.bounds.height - h*0.3, newCenter.y)
        newCenter.y = max(h*0.3, newCenter.y)
        
        //Update position
        self.center = newCenter
        x = newCenter.x
        y = newCenter.y
        xVelocity = newCenter.x-w*0.08
        yVelocity = newCenter.y-h*0.5
        
        //print("0x: ", newCenter.x-w*0.08," 0y: ",newCenter.y-h*0.5)
}
        override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
            //endLocation = touches.first?.location(in: self)
            
        self.center = CGPoint(x: w*0.08, y:h*0.5)
            //dx = sqrt(pow((endLocation!.x-startLocation!.x),2.0))
            //dy = sqrt(pow((endLocation!.y-startLocation!.y),2.0))
            
        //Call update angle for action
        self.myDelegateAngle?.UpdateAngle(Int(xVelocity), Int(yVelocity), Int(x), Int(y))
            
        //Call delegate for action
        self.myDelegate?.CreateSonic()
            
        
        
    }
    
}

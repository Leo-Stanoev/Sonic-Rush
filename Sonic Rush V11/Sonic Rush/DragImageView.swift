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
    
    //set myDelegate as attribute of ReleaseDelegate data type
    var myDelegateAngle: UpdateAngle?
    var myDelegate: ReleaseDelegate?
    var myDelegateAngle2: UpdateAngle2?
    var myDelegate2: ReleaseDelegate2?
    var xy =  CGPoint(x: 0, y: 0)

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
        let halfx = self.bounds.midX
        newCenter.x = max(halfx, newCenter.x)
        newCenter.x = min(self.superview!.bounds.width - w*0.75, newCenter.x)
        
        //Constraints for Aim object's vertical movement
        newCenter.y = max(h*0.3, newCenter.y)
        newCenter.y = min(self.superview!.bounds.height - h*0.3, newCenter.y)
        
        //Update position
        self.center = newCenter
        xy = newCenter

        
}
        override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
            
        self.center = CGPoint(x: w*0.08, y:h*0.5)
            
        //Call update angle for action
            self.myDelegateAngle?.UpdateAngle(xy)
            
        //Call delegate for action
        self.myDelegate?.CreateSonic()
            
        //Call update angle for action
            self.myDelegateAngle2?.UpdateAngle(xy)
            
        //Call delegate for action
        self.myDelegate2?.CreateSonic()
        
    }
}

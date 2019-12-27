//
//  DragImageView.swift
//  Sonic Rush
//
//  Created by Lyubomir on 27/12/2019.
//  Copyright © 2019 Lyubomir Stanoev. All rights reserved.
//

import UIKit

class DragImageView: UIImageView {
    let w = UIScreen.main.bounds.width
    let h = UIScreen.main.bounds.height
    var startLocation: CGPoint?

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        startLocation = touches.first?.location(in: self)
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        let currentLocation = touches.first?.location(in: self)
        let dx = currentLocation!.x - startLocation!.x
        let dy = currentLocation!.y - startLocation!.y
        
        var newCenter = CGPoint(x: self.center.x+dx, y: self.center.y+dy)
        
        let halfx = self.bounds.midX
        newCenter.x = min(self.superview!.bounds.width - w*0.8, newCenter.x)
        newCenter.x = max(halfx, newCenter.x)
        
        //let halfy = self.bounds.midY
        newCenter.y = min(self.superview!.bounds.height - h*0.3, newCenter.y)
        newCenter.y = max(h*0.3, newCenter.y)
        
        self.center = newCenter
        
}
        override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
            self.center = CGPoint(x: w*0.08, y:h*0.5)

    }
    
}

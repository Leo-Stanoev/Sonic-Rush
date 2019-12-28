//
//  ViewController.swift
//  Sonic Rush
//
//  Created by Lyubomir on 27/12/2019.
//  Copyright © 2019 Lyubomir Stanoev. All rights reserved.
//

import UIKit
//Delegate protocol for ball release of Aim object
protocol ReleaseDelegate {
        func CreateSonic()
}
class ViewController: UIViewController, ReleaseDelegate {
    var dynamicAnimator: UIDynamicAnimator!
    var dynamicItemBehavior: UIDynamicItemBehavior!
    var gravityBehavior: UIGravityBehavior!
    var collisionBehavior: UICollisionBehavior!
    var sonicViewArray: [UIImageView] = []
    var i = 0
    
    @IBOutlet weak var AimRelease: DragImageView!
    
    func CreateSonic() {
         let sonicView = UIImageView(image: nil)
         sonicView.image = UIImage(named: "Sonic.png")
         sonicView.frame = CGRect(x:100, y: 150, width: 55, height: 55)
         self.view.addSubview(sonicView)
        
        sonicViewArray.append(sonicView)
        
        //movement, velocity and bounce
        dynamicAnimator = UIDynamicAnimator(referenceView: self.view)
        dynamicItemBehavior = UIDynamicItemBehavior(items: sonicViewArray)
        dynamicItemBehavior.addLinearVelocity(CGPoint(x: 250, y: 0), for: sonicViewArray[i])
        dynamicItemBehavior.elasticity = 0.5
        dynamicAnimator.addBehavior(dynamicItemBehavior)
        
        //gravity
        //gravityBehavior = UIGravityBehavior(items: sonicViewArray)
        //dynamicAnimator.addBehavior(gravityBehavior)
        
        //collision
        collisionBehavior = UICollisionBehavior(items: sonicViewArray)
        collisionBehavior.translatesReferenceBoundsIntoBoundary = true
        dynamicAnimator.addBehavior(collisionBehavior)
        
        
        i+=1
        
    }
    
    
    
    
    //Create global size variables
    let w = UIScreen.main.bounds.width
    let h = UIScreen.main.bounds.height

    //Link Aim Object to viewController
    @IBOutlet weak var Aim: DragImageView!
    
    override func viewDidLoad() {
        //start Aim object at viewDidLoad
        Aim.center = CGPoint(x:w*0.08, y:h*0.5)
        //Assign Delegate for DragImageView.swift
        AimRelease.myDelegate = self
        
 
        
        
        
    }
}


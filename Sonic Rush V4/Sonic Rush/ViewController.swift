//
//  ViewController.swift
//  Sonic Rush
//
//  Created by Lyubomir on 27/12/2019.
//  Copyright © 2019 Lyubomir Stanoev. All rights reserved.
//

import UIKit
//Delegate protocol for ball release of Aim object
protocol UpdateAngle {
    func UpdateAngle(_ x: Int,_ y: Int,_ spawnX: Int,_ spawnY: Int)
}

protocol ReleaseDelegate {
    func CreateSonic()
}


class ViewController: UIViewController, ReleaseDelegate, UpdateAngle{
    let w = UIScreen.main.bounds.width
    let h = UIScreen.main.bounds.height
    var dynamicAnimator: UIDynamicAnimator!
    var dynamicItemBehavior: UIDynamicItemBehavior!
    var gravityBehavior: UIGravityBehavior!
    var collisionBehavior: UICollisionBehavior!
    var sonicViewArray: [UIImageView] = []
    var i = 0
    var AngleX: Int = 0
    var AngleY: Int = 0
    var spawnX: Int = 0
    var spawnY: Int = 0
    
    @IBOutlet weak var AimRelease: DragImageView!
    
    func UpdateAngle(_ x: Int,_ y: Int,_ spawnX: Int,_ spawnY: Int){
        AngleX = x*3
        AngleY = y*3
        self.spawnX = spawnX
        self.spawnY = spawnY
    }
    
    func CreateSonic() {
         let sonicView = UIImageView(image: nil)
         sonicView.image = UIImage(named: "Sonic.png")
         sonicView.frame = CGRect(x:spawnX-15, y: spawnY-15, width: 55, height: 55)
         view.addSubview(sonicView)
        
        sonicViewArray.append(sonicView)
        
        //movement, velocity and bounce
        dynamicAnimator = UIDynamicAnimator(referenceView: self.view)
        dynamicItemBehavior = UIDynamicItemBehavior(items: sonicViewArray)
        //dynamicItemBehavior.elasticity = 0.5
        
	
        //Velocity
        dynamicItemBehavior.addLinearVelocity(CGPoint(x: AngleX, y: AngleY), for: sonicViewArray[i])
        //gravity
        //ravityBehavior = UIGravityBehavior(items: sonicViewArray)
        //dynamicAnimator.addBehavior(gravityBehavior)
        dynamicAnimator.addBehavior(dynamicItemBehavior)
        //collision
        collisionBehavior = UICollisionBehavior(items: sonicViewArray)
        //collisionBehavior.translatesReferenceBoundsIntoBoundary = true
        
        //Add top collision
        collisionBehavior.addBoundary(withIdentifier: "top" as NSString, from: CGPoint(x:0,y: 0), to: CGPoint(x:w,y:0))
        
        //Add left collision
        collisionBehavior.addBoundary(withIdentifier: "left" as NSString, from: CGPoint(x:0,y: 0), to: CGPoint(x:0,y:h))
        
        //Add bottom collision
        collisionBehavior.addBoundary(withIdentifier: "bottom" as NSString, from: CGPoint(x:0,y: h), to: CGPoint(x:w,y:h))
        dynamicAnimator.addBehavior(collisionBehavior)

        
        i+=1
        
    }

    //Link Aim Object to viewController
    @IBOutlet weak var Aim: DragImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let boundary = UIView(frame: CGRect(x:0, y:0 , width: w*0.35, height: h*0.4))
        boundary.backgroundColor = UIColor.red
        view.addSubview(boundary)
        view.sendSubviewToBack(boundary)
        boundary.center = CGPoint(x:w*0.08, y:h*0.5)
        
        print(boundary.frame.width,boundary.frame.height)
        
        //start Aim object at viewDidLoad
        Aim.center = CGPoint(x:w*0.08, y:h*0.5)
        //Assign Delegate for DragImageView.swift
        AimRelease.myDelegate = self
        AimRelease.myDelegateAngle = self
        
 
    }
}


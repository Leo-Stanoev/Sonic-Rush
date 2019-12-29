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
    func UpdateAngle(_ xy: CGPoint)
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
    var coinsArray: [UIImageView] = []
    var i = 0
    var initialised = 0
    var spawnX: CGFloat = 0
    var spawnY: CGFloat = 0
    var AngleX: CGFloat = 0
    var AngleY: CGFloat = 0
    var gameTimer = Timer()
    var timeLimit = 10
    @IBOutlet weak var Score: UILabel!
    @IBOutlet weak var AimRelease: DragImageView!

    
    func UpdateAngle(_ xy: CGPoint){
        AngleX = (xy.x-w*0.08)*3
        AngleY = (xy.y-h*0.5)*3
        spawnX = xy.x
        spawnY = xy.y
    }
    
    
    
    func CreateSonic() {
         let sonicView = UIImageView(image: nil)
         sonicView.image = UIImage(named: "Sonic.png")
         sonicView.frame = CGRect(x:spawnX-15, y: spawnY-15, width: 55, height: 55)
         view.addSubview(sonicView)
        sonicViewArray.append(sonicView)
        
        //Movement, velocity and bounce
        if(initialised == 0){
        dynamicAnimator = UIDynamicAnimator(referenceView: self.view)
        dynamicItemBehavior = UIDynamicItemBehavior(items: sonicViewArray)
        dynamicAnimator.addBehavior(dynamicItemBehavior)
        }
        initialised=1
        dynamicItemBehavior.addItem(sonicViewArray[i])
        dynamicItemBehavior.addLinearVelocity(CGPoint(x: AngleX, y: AngleY), for: sonicViewArray[i])

        //Bounce
        dynamicItemBehavior.elasticity = 0.5

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
        
        //self.collisionBehavior.action = {
        //    for sonic in self.sonicViewArray{
        //        if sonicView.frame.intersects(){
        //            print("balls collided")
        //        }
        //    }
            
        //    }
        
        i+=1
        
        //gravity
        //gravityBehavior = UIGravityBehavior(items: sonicViewArray)
        //dynamicAnimator.addBehavior(gravityBehavior)
        //dynamicAnimator.removeAllBehaviors()
    }
    
    
    //Link Aim Object to viewController
    @IBOutlet weak var Aim: DragImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Score.center = CGPoint(x:w*0.1, y: 20)
        Score.text = "Time Left: " + String(timeLimit)
        //start Aim object at viewDidLoad
        Aim.center = CGPoint(x:w*0.08, y:h*0.5)
        
        //Assign Delegate for DragImageView.swift
        AimRelease.myDelegate = self
        AimRelease.myDelegateAngle = self
        
        gameTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector:#selector(TimeCountdown), userInfo: nil, repeats: true)

    }
    
    @objc func TimeCountdown(){
        timeLimit -= 1
        Score.text = "Time Left: " + String(timeLimit)
        
        if (timeLimit == 0){
            gameTimer.invalidate()
        }
        
    }
    
}


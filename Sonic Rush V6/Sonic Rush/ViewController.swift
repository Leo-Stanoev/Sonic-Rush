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
    var coinViewArray: [UIImageView] = []
    var i = 0
    var initialised = 0
    var spawnX: CGFloat = 0
    var spawnY: CGFloat = 0
    var AngleX: CGFloat = 0
    var AngleY: CGFloat = 0
    var gameTimer = Timer()
    var timeLimit = 20
    var score = 0

    @IBOutlet weak var Time: UILabel!
    @IBOutlet weak var AimRelease: DragImageView!
    @IBOutlet weak var ScoreLabel: UILabel!
    
    
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
        //dynamicItemBehavior.elasticity = 0.5

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
        
        //Add bottom collision
        let rightBoundary = UIImageView (image: nil)
        rightBoundary.image = UIImage(named: "BoundaryImage.png")
        rightBoundary.frame = CGRect(x:w*1.1, y:0, width: 1, height: h)
        view.addSubview(rightBoundary)
        
        self.collisionBehavior.action = {
           for coin in self.coinViewArray{
            if sonicView.frame.intersects(coin.frame){
                self.score += 1
                self.ScoreLabel.text = String(self.score)
                coin.removeFromSuperview()
                coin.frame = CGRect(x:0, y: 0, width: 0, height: 0)
                self.createCoin()
              }
            }
            for sonic in self.sonicViewArray{
            if sonic.frame.intersects(rightBoundary.frame){
                sonic.frame = CGRect(x:self.w*2, y: self.h*2, width: 1, height: 1)
                self.dynamicItemBehavior.removeItem(sonic)
                self.collisionBehavior.removeItem(sonic)
            }
        }
    }
        
        i+=1
        
        //gravity
        //gravityBehavior = UIGravityBehavior(items: sonicViewArray)
        //dynamicAnimator.addBehavior(gravityBehavior)
        //dynamicAnimator.removeAllBehaviors()
        

    }
    
    func createCoin(){
        
         let coinView = UIImageView(image: nil)
         coinView.image = UIImage(named: "Coin1.png")
         coinView.frame = CGRect(x:700, y: Int(arc4random_uniform(300)+50), width: 55, height: 55)
         view.addSubview(coinView)
         coinViewArray.append(coinView)
    }
    
    
    
    
    
    //Link Aim Object to viewController
    @IBOutlet weak var Aim: DragImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Time.center = CGPoint(x:w*0.1, y: 20)
        Time.text = "Time Left: " + String(timeLimit)
        //start Aim object at viewDidLoad
        Aim.center = CGPoint(x:w*0.08, y:h*0.5)
                createCoin()
        //Assign Delegate for DragImageView.swift
        AimRelease.myDelegate = self
        AimRelease.myDelegateAngle = self
        
        gameTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector:#selector(TimeCountdown), userInfo: nil, repeats: true)
        
    }
    
    @objc func TimeCountdown(){
        timeLimit -= 1
        Time.text = "Time Left: " + String(timeLimit)
        
        if (timeLimit == 0){
            //Aim.isUserInteractionEnabled = false
            gameTimer.invalidate()
        }
        
    }
    
}


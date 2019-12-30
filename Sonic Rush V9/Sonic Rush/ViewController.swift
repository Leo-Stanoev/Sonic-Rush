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
    var timeLimit = 15
    var score = 0
    var coinPosArray: [CGFloat] = []
    var coinPosArrayInit = false
    var randomPos = 0
    var liveCoinPos: [Int] = []
    var coinPos = 0
    var launches = 0

    @IBOutlet weak var Time: UILabel!
    @IBOutlet weak var AimRelease: DragImageView!
    @IBOutlet weak var ScoreLabel: UILabel!
    
    
    
    func UpdateAngle(_ xy: CGPoint){
        AngleX = (xy.x-w*0.08)*4
        AngleY = (xy.y-h*0.5)*4
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
        
        //check collision of sonic
        self.collisionBehavior.action = {
           for coin in self.coinViewArray{
            
            if sonicView.frame.intersects(coin.frame){
                self.score += 1
                self.ScoreLabel.text = String(self.score)
                coin.removeFromSuperview()
                coin.frame = CGRect(x:0, y: 0, width: 0, height: 0)
                self.coinViewArray.remove(at: self.coinPos)

                self.liveCoinPos.remove(at: self.coinPos)

              }
            self.coinPos += 1
            }
            self.coinPos = 0
        }
        i+=1
        //gravity
        //gravityBehavior = UIGravityBehavior(items: sonicViewArray)
        //dynamicAnimator.addBehavior(gravityBehavior)

    }
    
    func createCoin(){
        
        //Initialise position array once
        if coinPosArrayInit == false{
        coinPosArray = [h*0.03,/*h*0.22,*/h*0.41,/*h*0.60,*/h*0.79]
            coinPosArrayInit = true
        }
        
        repeat {
            //dont spawn any coins if maximum is reached
            if liveCoinPos.count == 3{
                return;
            }

            print("going strong")

            self.randomPos = Int(arc4random_uniform(3))
        } while self.liveCoinPos.contains(self.randomPos)
        
        
        let coinView = UIImageView(image: nil)
        let coinName = "Coin" + String(arc4random_uniform(8)+1) + ".png" //choose a random coin to create
        coinView.image = UIImage(named: coinName)
        coinView.frame = CGRect(x:w*0.85, y: coinPosArray[randomPos], width: 55, height: 55)
        print(randomPos)
        
        //append and print liveCoinPos Array
        liveCoinPos.append(randomPos)
        print(liveCoinPos)
        
        view.addSubview(coinView)
        coinViewArray.append(coinView)
        launches += 1
    }
    
    //Link Aim Object to viewController
    @IBOutlet weak var Aim: DragImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //coinPosArray = [Int(h*0.03),Int(h*0.22),Int(h*0.41),Int(h*0.60),Int(h*0.79)]
        
        Time.center = CGPoint(x:w*0.1, y: 20)
        ScoreLabel.center = CGPoint(x:w*0.5, y: 20)
        Time.text = "Time Left: " + String(timeLimit)
        //start Aim object at viewDidLoad
        Aim.center = CGPoint(x:w*0.08, y:h*0.5)
                createCoin()
        //Assign Delegate for DragImageView.swift
        AimRelease.myDelegate = self
        AimRelease.myDelegateAngle = self
        
        gameTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector:#selector(TimeCountdown), userInfo: nil, repeats: true)
        
    }
    
    func gameOver(){
        let gameOver = UIImageView(image: nil)
        gameOver.image = UIImage(named: "GameOver.png")
        gameOver.frame = CGRect(x: 0, y: 0, width: w, height: h)
        view.addSubview(gameOver)
        
        let finalCoins = UIImageView(image: nil)
        finalCoins.image = UIImage(named: "Coin6.png")
        finalCoins.frame = CGRect(x: w*0.25, y: h*0.4, width: 55, height: 55)
        view.addSubview(finalCoins)
        
        let finalCoinsLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 75, height: 40))
        finalCoinsLabel.center = CGPoint(x: w*0.37, y: h*0.47)
        finalCoinsLabel.textAlignment = .center
        finalCoinsLabel.font = UIFont.systemFont(ofSize: 32)
        finalCoinsLabel.text = "x  " + String(score)
        self.view.addSubview(finalCoinsLabel)
        
        let finalLaunches = UIImageView(image: nil)
        finalLaunches.image = UIImage(named: "Sonic.png")
        finalLaunches.frame = CGRect(x: w*0.07, y: h*0.4, width: 55, height: 55)
        view.addSubview(finalLaunches)
        
        let finalLaunchesLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 75, height: 40))
        finalLaunchesLabel.center = CGPoint(x: w*0.19, y: h*0.47)
        finalLaunchesLabel.textAlignment = .center
        finalLaunchesLabel.font = UIFont.systemFont(ofSize: 32)
        finalLaunchesLabel.text = "x  " + String(score)
        self.view.addSubview(finalLaunchesLabel)
        
        let replayButton = UIButton(frame: CGRect(x: w*0.04, y: h*0.75, width: 150, height: 50))
        replayButton.setImage(UIImage(named: "Replay.png"), for: .normal)
          replayButton.setTitle("Replay", for: .normal)
          replayButton.addTarget(self, action: #selector(replayButtonAction), for: .touchUpInside)
          self.view.addSubview(replayButton)
        
        let nextLevelButton = UIButton(frame: CGRect(x: w*0.27, y: h*0.75, width: 150, height: 50))
        nextLevelButton.setImage(UIImage(named: "NextLevel.png"), for: .normal)
          nextLevelButton.setTitle("Replay", for: .normal)
          nextLevelButton.addTarget(self, action: #selector(nextLevelButtonAction), for: .touchUpInside)
          self.view.addSubview(nextLevelButton)
        

        }

        @objc func replayButtonAction(sender: UIButton!) {
            print("Replay")
        }
    
        @objc func nextLevelButtonAction(sender: UIButton!) {
            print("Next Level")
        }
    
    @objc func TimeCountdown(){
        timeLimit -= 1
        Time.text = "Time Left: " + String(timeLimit)
        
        if timeLimit % 2 == 0{
        createCoin()
        }
        if (timeLimit == 0){
            gameOver()
            Aim.isUserInteractionEnabled = false
            Aim.removeFromSuperview()
            ScoreLabel.removeFromSuperview()
            Time.removeFromSuperview()
            gameTimer.invalidate()
        }
        
    }
    
}


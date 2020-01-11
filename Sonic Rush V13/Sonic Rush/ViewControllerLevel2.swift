//
//  ViewControllerLevel2.swift
//  Sonic Rush
//
//  Created by Bob on 08/01/2020.
//  Copyright © 2020 Lyubomir Stanoev. All rights reserved.
//

import UIKit
import AVFoundation
//Delegate protocol for ball release of Aim object
protocol UpdateAngle2 {
    func UpdateAngle(_ xy: CGPoint)
}

protocol ReleaseDelegate2 {
    func CreateSonic()
}

class ViewControllerLevel2: UIViewController, ReleaseDelegate2, UpdateAngle2{

        var player: AVAudioPlayer!
        var player2: AVAudioPlayer!
        let w = UIScreen.main.bounds.width
        let h = UIScreen.main.bounds.height
        var dynamicAnimator: UIDynamicAnimator!
        var dynamicItemBehavior: UIDynamicItemBehavior!
        var gravityBehavior: UIGravityBehavior!
        var collisionBehavior: UICollisionBehavior!
        var snapBehavior:UISnapBehavior!
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
        var obstacle: UIView?
        var randomObstaclePosX: CGFloat = 0
        var randomObstaclePosY: CGFloat = 0

    @IBOutlet weak var Time: UILabel!
    @IBOutlet weak var AimRelease: DragImageView!
    @IBOutlet weak var ScoreLabel: UILabel!
        
        func UpdateAngle(_ xy: CGPoint){
            AngleX = (xy.x-w*0.08)*4.5
            AngleY = (xy.y-h*0.5)*4.5
            spawnX = xy.x
            spawnY = xy.y
        }
    
    func PlayCoin(){
            player = try? AVAudioPlayer(contentsOf: URL.init(fileURLWithPath: Bundle.main.path(forResource: "CoinSound", ofType: "wav")!))
            //player.prepareToPlay()
    }
    
    func PlayBGMusic(){
        player2 = try? AVAudioPlayer(contentsOf: URL.init(fileURLWithPath: Bundle.main.path(forResource: "BGMusic", ofType: "wav")!))
        player2.volume = 0.3
        player2.play()
    }
        
        func CreateObstacle(){
            randomObstaclePosX = CGFloat.random(in: 0.5..<0.6)
            randomObstaclePosY = CGFloat.random(in: 0.4..<0.6)
            let obsframe = CGRect(x:w*randomObstaclePosX,y:h*randomObstaclePosY,width: w*0.2,height: h*0.25)
            obstacle = UIView(frame: obsframe)
            obstacle?.center = CGPoint(x:w*randomObstaclePosX,y:h*randomObstaclePosY)
            obstacle?.layer.borderColor = UIColor.black.cgColor
            obstacle?.layer.borderWidth = 7
            self.view.addSubview(obstacle!)
            snapBehavior = UISnapBehavior(item: obstacle!, snapTo: CGPoint(x: w*randomObstaclePosX, y: h*randomObstaclePosY))
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
            dynamicAnimator.addBehavior(snapBehavior)
            }
            initialised=1
            dynamicItemBehavior.addItem(sonicViewArray[i])
            dynamicItemBehavior.addLinearVelocity(CGPoint(x: AngleX, y: AngleY), for: sonicViewArray[i])

            //Bounce
            dynamicItemBehavior.elasticity = 1

            //collision
            collisionBehavior = UICollisionBehavior(items: sonicViewArray)
            
            //obstacle collision
            collisionBehavior.addItem(obstacle!)
            
            //Add top collision
            collisionBehavior.addBoundary(withIdentifier: "top" as NSString, from: CGPoint(x:0,y: 0), to: CGPoint(x:w,y:0))
            
            //Add left collision
            collisionBehavior.addBoundary(withIdentifier: "left" as NSString, from: CGPoint(x:0,y: 0), to: CGPoint(x:0,y:h))
            
            //Add bottom collision
            collisionBehavior.addBoundary(withIdentifier: "bottom" as NSString, from: CGPoint(x:0,y: h), to: CGPoint(x:w,y:h))
            dynamicAnimator.addBehavior(collisionBehavior)

            //Add right boundary to stop objects
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
                    self.player.play()
                    AudioServicesPlaySystemSound(kSystemSoundID_Vibrate)
                  }
                self.coinPos += 1
                UIView.animate(withDuration: 1, animations: ({sonicView.transform = CGAffineTransform.init(rotationAngle: 2)}))
                }
                self.coinPos = 0
            }
            
            i+=1
            
            //gravity
            //gravityBehavior = UIGravityBehavior(items: sonicViewArray)
            //dynamicAnimator.addBehavior(gravityBehavior)

            launches += 1
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

                //print("going strong")

                self.randomPos = Int(arc4random_uniform(3))
            } while self.liveCoinPos.contains(self.randomPos)
            
            
            let coinView = UIImageView(image: nil)
            let coinName = "Coin" + String(arc4random_uniform(8)+1) + ".png" //choose a random coin to create
            coinView.image = UIImage(named: coinName)
            coinView.frame = CGRect(x:w*0.85, y: coinPosArray[randomPos], width: 55, height: 55)
            //print(randomPos)
            
            //append and print liveCoinPos Array
            liveCoinPos.append(randomPos)
            //print(liveCoinPos)
            
            view.addSubview(coinView)
            coinViewArray.append(coinView)
        }
    
        //Link Aim Object to viewController
    @IBOutlet weak var Aim: DragImageView!
    override func viewDidLoad() {
            super.viewDidLoad()
        
        let levelLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 75, height: 40))
        levelLabel.center = CGPoint(x: w*0.25, y: 20)
        levelLabel.textAlignment = .center
        levelLabel.font = UIFont.systemFont(ofSize: 17)
        levelLabel.text = "Level 2"
        self.view.addSubview(levelLabel)
        
            PlayBGMusic()
            PlayCoin()
            CreateObstacle()
            Time.center = CGPoint(x:w*0.1, y: 20)
            ScoreLabel.center = CGPoint(x:w*0.5, y: 20)
            Time.text = "Time Left: " + String(timeLimit)
            //start Aim object at viewDidLoad
            Aim.center = CGPoint(x:w*0.08, y:h*0.5)
                    createCoin()
            Aim.isUserInteractionEnabled = true
            //Assign Delegate for DragImageView.swift
            AimRelease.myDelegate2 = self
            AimRelease.myDelegateAngle2 = self
            
            gameTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector:#selector(TimeCountdown), userInfo: nil, repeats: true)
            
        }
        
        func end(){
            player.stop()
            player2.setVolume(0, fadeDuration: 1)
            let endViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "endGame") as! EndViewController
            endViewController.score = self.score
            endViewController.launches = self.launches
            endViewController.CurrentLevel = "two"
            endViewController.NextLevel = "three"
            self.present(endViewController,animated:true,completion: nil)
            
            
        }

        @objc func TimeCountdown(){
            timeLimit -= 1
            Time.text = "Time Left: " + String(timeLimit)
            
            if timeLimit % 1 == 0{
            createCoin()
            //print("coin created")
            }
            if (timeLimit == 0){
                gameTimer.invalidate()

                end()
            }
        }
    }
	

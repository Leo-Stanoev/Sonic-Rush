//
//  EndViewController.swift
//  Sonic Rush
//
//  Created by Bob on 31/12/2019.
//  Copyright © 2019 Lyubomir Stanoev. All rights reserved.
//

import UIKit

class EndViewController: UIViewController {
    let w = UIScreen.main.bounds.width
    let h = UIScreen.main.bounds.height
    var score = 0
    var launches = 0
    
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
    finalLaunchesLabel.text = "x  " + String(launches)
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
            
            //self.dismiss(animated: true, completion: nil)
            //self.presentingViewController?.dismiss(animated:true,completion: nil)
            
            let gvc = UIStoryboard(name: "Main", bundle:nil).instantiateViewController(identifier: "game") as! ViewController
            self.present(gvc, animated:true,completion: nil)
            
        }
    
        @objc func nextLevelButtonAction(sender: UIButton!) {
            print("Next Level")
        }
    
    
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        gameOver()
        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

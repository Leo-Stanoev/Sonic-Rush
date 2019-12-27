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
    
    
    @IBOutlet weak var AimRelease: DragImageView!
    
    func CreateSonic() {
         let sonicView = UIImageView(image: nil)
         sonicView.image = UIImage(named: "Sonic.png")
         sonicView.frame = CGRect(x:100, y: 150, width: 65, height: 65)
         self.view.addSubview(sonicView)
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


//
//  ViewController.swift
//  Sonic Rush
//
//  Created by Lyubomir on 27/12/2019.
//  Copyright © 2019 Lyubomir Stanoev. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    let w = UIScreen.main.bounds.width
    let h = UIScreen.main.bounds.height
    
    @IBOutlet weak var Aim: DragImageView!
    override func viewDidLoad() {
        Aim.center = CGPoint(x:w*0.08, y:h*0.5)
    }
}


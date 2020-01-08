//
//  StartViewController.swift
//  Sonic Rush
//
//  Created by Bob on 31/12/2019.
//  Copyright © 2019 Lyubomir Stanoev. All rights reserved.
//

import UIKit

class StartViewController: UIViewController {

    var x = false
    
    func startGame(){
        
    let gvc = UIStoryboard(name: "Main", bundle:nil).instantiateViewController(identifier: "game") as! ViewController
    self.present(gvc, animated:true,completion: nil)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        while x == true{
        startGame()
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
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

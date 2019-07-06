//
//  PreGameViewController.swift
//  DuckRacer
//
//  Created by Gerardo Gallegos on 10/12/17.
//  Copyright © 2017 Gerardo Gallegos. All rights reserved.
//

import UIKit
import SwiftySound
import Firebase

class PreGameViewController: UIViewController {

    var diff: Int!
    var isTwoPlayer: Bool!
    var scoreLimit: Int = 10
    
    @IBOutlet weak var sliderOutlet: UISlider!
    @IBOutlet weak var lapCounter: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        print("PreGame Page: .\(isTwoPlayer), .\(diff)")

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func backButton(_ sender: Any) {
        if isTwoPlayer{
            self.performSegue(withIdentifier: "backToFirst", sender: nil)
        }else {
            self.performSegue(withIdentifier: "backToDiff", sender: nil)
        }
    }
    
    @IBAction func scoreSlider(_ sender: Any) {
        let currentValue = Int(sliderOutlet.value)
        
        scoreLimit = currentValue
        
        lapCounter.text = "\(scoreLimit) Laps"
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toGameSegue"{
            if let destination = segue.destination as? ViewController {
                destination.isTwoPlayer = self.isTwoPlayer
                destination.scoreLimit = self.scoreLimit
                destination.diff = self.diff
            }
        }else if segue.identifier == "backToDiff"{
            if let destination = segue.destination as? DifficultyViewController {
                destination.isTwoPlayer = self.isTwoPlayer
                print("backtodiff")
            }
        }
    }
}

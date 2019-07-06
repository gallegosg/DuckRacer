//
//  OptionsViewController.swift
//  DuckRacer
//
//  Created by Gerardo Gallegos on 10/17/17.
//  Copyright © 2017 Gerardo Gallegos. All rights reserved.
//

import UIKit
import SwiftySound
import Firebase

class OptionsViewController: UIViewController {

    @IBOutlet weak var soundSwitch: UISwitch!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        soundSwitch.isOn = UserDefaults.standard.bool(forKey: "soundSwitchState")
        // Do any additional setup after loading the view.
    }

    @IBAction func soundSwitchAction(_ sender: Any) {
        UserDefaults.standard.set(soundSwitch.isOn, forKey: "soundSwitchState")
        
        if soundSwitch.isOn {
            print("sound is on")
            Sound.enabled = true
            Sound.play(file: "DuckRacerSound", fileExtension: ".aif", numberOfLoops: -1)
            
        } else {
            print("sound is off")
            Sound.enabled = false
            
        }
    }
    
}

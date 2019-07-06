//
//  FirstViewController.swift
//  DuckRacer
//
//  Created by Gerardo Gallegos on 10/11/17.
//  Copyright © 2017 Gerardo Gallegos. All rights reserved.
//

import UIKit
import SwiftySound
import Firebase

class FirstViewController: UIViewController {
    
    var isTwoPlayer: Bool = true

    override func viewDidLoad() {
        super.viewDidLoad()


        // Do any additional setup after loading the view.
    }

    @IBAction func onePlayerButton(_ sender: Any) {
        isTwoPlayer = false
    }
    
    @IBAction func twoPlayerButton(_ sender: Any) {
        isTwoPlayer = true
    }

    @IBAction func quack(_ sender: Any) {
        Sound.play(file: "quack.wav")
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "onePlayerSegue"{
            if let destination = segue.destination as? DifficultyViewController {
                destination.isTwoPlayer = self.isTwoPlayer
            }
        }else if segue.identifier == "preGameSegue" {
            if let destination = segue.destination as? PreGameViewController {
                destination.isTwoPlayer = self.isTwoPlayer
            }
        }
    }
}

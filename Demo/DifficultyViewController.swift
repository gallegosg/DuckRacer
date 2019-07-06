//
//  DifficultyViewController.swift
//  DuckRacer
//
//  Created by Gerardo Gallegos on 10/12/17.
//  Copyright © 2017 Gerardo Gallegos. All rights reserved.
//

import UIKit
import SwiftySound
import Firebase

class DifficultyViewController: UIViewController {

    var isTwoPlayer: Bool!
    var diff: Int!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        print("Diff Page: .\(isTwoPlayer), .\(diff)")
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func easyAction(_ sender: Any) {
        diff = 1
    }
    
    @IBAction func hardAction(_ sender: Any) {
        diff = 2
    }
    @IBAction func insaneAction(_ sender: Any) {
        diff = 3
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "easySegue" || segue.identifier == "hardSegue" || segue.identifier == "insaneSegue"{
            if let destination = segue.destination as? PreGameViewController {
                destination.isTwoPlayer = self.isTwoPlayer
                destination.diff = self.diff
            }
        }
    }
    
    
}

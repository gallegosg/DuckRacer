//
//  ViewController.swift
//  Duck Racer
//
//  Created by Gerardo Gallegos on 12/17/16.
//  Copyright © 2016 Gerardo Gallegos. All rights reserved.
//
//
//  Duck = Pekins
//  Fox = Mallard




//correct score limit
//

import UIKit
import SwiftySound
import GoogleMobileAds
import Firebase

class ViewController: UIViewController, GADInterstitialDelegate {
    
    //google admob
    var interstitial: GADInterstitial!

    @IBOutlet weak var duckCount: UILabel!
    @IBOutlet weak var foxCount: UILabel!
    
    @IBOutlet weak var foxButton: UIButton!
    @IBOutlet weak var duckButton: UIButton!
    
    @IBOutlet weak var scoreLabel: UILabel!

    @IBOutlet weak var playAgainOutlet: UIButton!
    @IBOutlet weak var startOverOutlet: UIButton!

    @IBOutlet weak var timerLabel: UILabel!
    @IBOutlet weak var startGameOutlet: UIButton!
    
    //create image view
    let duckView = UIImageView(image: UIImage(named: "Duck1.png")!)
    
    let foxView = UIImageView(image: UIImage(named: "Duck2.png")!)
    
    let finishView = UIImageView(image: UIImage(named: "finish.png")!)

    
    //variables
    var foxC: Int = 0
    var duckC: Int = 0
    var x1: Int = 286
    var y1: Int = 217
    var x2: Int = 286
    var y2: Int = 355
    
    var edgeWidth:Int!
    var edgeHeight:Int!
    
    var screenWidth:Int  = Int(UIScreen.main.bounds.width)
    var screenHeight:Int = Int(UIScreen.main.bounds.height)
    
    var screenRatio: Int!
    var screenRatioH: Int!
    
    var tcount = 3
    var timer = Timer()
    
    var cpuTimer = Timer()
    
    var scoreLimit = 10
    
    var isTwoPlayer: Bool!
    var diff: Int!
    
    
    //viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
        interstitial = createAndLoadInterstitial()

        //GOOGLE ADS
        //interstitial = GADInterstitial(adUnitID: "ca-app-pub-6937210582976662/6485839035")
        //let request = GADRequest()
        //request.testDevices = [ kGADSimulatorID, "041d6da59580f2493337b3844055eb8a" ];  //  device ID for testing
        //interstitial.load(request)
        
        /*
        bannerView = GADBannerView(adSize: kGADAdSizeSmartBannerPortrait)
        bannerView.delegate = self
        self.view.addSubview(bannerView)
        //banner adUnitId "ca-app-pub-6937210582976662/1177923684"
        bannerView.rootViewController = self
        bannerView.load(GADRequest())
        ///////////////////////
        */
        
       
        //rotate fox button
        foxButton.transform = CGAffineTransform(rotationAngle: CGFloat.pi)
  
        
        //change x and y corrdinates
        edgeWidth = screenWidth - 80
        
        //screen ratio for width
        screenRatio = edgeWidth / 5
        
 
        //screen ratio detect
        if UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiom.pad {
            screenRatioH = screenHeight / 10//10 for ipad
        } else {
            screenRatioH = screenHeight / 8 //8 for iphone
        }

        //starting positions
        x1 = edgeWidth
        x2 = edgeWidth
        
        
        y1 = (screenHeight / 2) - screenRatioH
        y2 = (screenHeight / 2) + screenRatioH
        
        
        //load images & re orientate
        duckView.transform = CGAffineTransform(rotationAngle: -CGFloat.pi/2)

        self.duckView.frame = CGRect(x: self.x1, y: self.y1, width: 68, height: 68)
        self.view.addSubview(self.duckView)
        
        foxView.transform = CGAffineTransform(rotationAngle: -CGFloat.pi/2)

        self.foxView.frame = CGRect(x: self.x2, y: self.y2, width: 68, height: 68)
        self.view.addSubview(self.foxView)
        
        //draw finishline
        self.finishView.frame = CGRect(x: edgeWidth, y: (screenHeight/2), width: 136, height: 30)//136x60
        self.view.addSubview(self.finishView)
        
        
        scoreLabel.text = (" ")
        
        timerLabel.text = ""

        
        preGameClean()
        startGame()
        
        //Sound.play(file: "DuckRacerSound", fileExtension: "aif", numberOfLoops: -1)
        
        print("Game Page: .\(isTwoPlayer), .\(diff)")
    }//
    
    
    //GOOGLE ADMOB///////////////////////////////////////////////
    
    func displayAd() {
        
        if self.interstitial.isReady {
            self.interstitial.present(fromRootViewController: self)
            
        } else {
            print("Ad wasn't ready")
            
        }
        
        
    }
    func createAndLoadInterstitial() -> GADInterstitial {
        let interstitial = GADInterstitial(adUnitID: "ca-app-pub-6937210582976662/6485839035")
        interstitial.delegate = self
        interstitial.load(GADRequest())
        return interstitial
    }
    func interstitialDidDismissScreen(_ ad: GADInterstitial) {
        interstitial = createAndLoadInterstitial()
    }
    
    //determine if ads should be shown, show ads when rand is not 1
    func rollForAds() {
        let rand = random(lo: 0, hi: 3)
        
            if (rand != 1) {
                self.displayAd()
                //ads are shown
                print("yes ad \(rand)")
                
            }else {
                //no ads
                print("no ad \(rand)")
            }
        }
    
    /* BANNER VIEW AD
    func adViewDidReceiveAd(_ bannerView: GADBannerView) {
        view.addSubview(bannerView)
        print("adViewDidReceiveAd")

    }

    
    /// Tells the delegate an ad request failed.
    func adView(_ bannerView: GADBannerView, didFailToReceiveAdWithError error: GADRequestError) {
        print("adView:didFailToReceiveAdWithError: \(error.localizedDescription)")
    }
 */
   //////////////////////////////////////////////////////////////
    
    func random(lo: Int, hi: Int) -> Int {
        return lo + Int(arc4random_uniform(UInt32(hi - lo + 1)))
    }
    
    @objc func updateTimer(){

        if(tcount > 0){
            
            timerLabel.text = String(tcount)
            tcount -= 1
            
        }else if (tcount == 0){
            timerLabel.text = "Go!"
            tcount -= 1
        
            if isTwoPlayer{
                
            //un freeze butons
            foxButton.isEnabled = true
            duckButton.isEnabled = true
                
            }else {
                
                var cpuSpeed: Double!
                if diff == 1{
                    cpuSpeed = 0.18
                }else if diff == 2{
                    cpuSpeed = 0.093
                }else{
                    cpuSpeed = 0.075
                }
                //start cpu duck and only unfreeze player
                cpuTimer = Timer.scheduledTimer(timeInterval: cpuSpeed, target: self, selector: #selector(ViewController.cpuDuck), userInfo: nil, repeats: true)
                
                
                duckButton.isEnabled = true
            }
            
        }else {
            
            timerLabel.isHidden = true
        }
    }

    //called at very begining removes everything off screen
    func preGameClean() {
        timerLabel.isHidden = false
        timerLabel.text = ""
        
        startOverOutlet.isEnabled = true
        startOverOutlet.isHidden = false
        
        duckButton.setTitle("Pekin", for: .normal)

        
        //freeze butons
        foxButton.isEnabled = false
        duckButton.isEnabled = false
        
        startOverOutlet.isHidden = false
        startOverOutlet.isEnabled = true
        
        duckCount.isHidden = true
        foxCount.isHidden = true
    }

    func startGame() {
        //start timer
        //set up timer
        tcount = 3

        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: (#selector(ViewController.updateTimer)), userInfo: nil, repeats: true)
        
        updateTimer()
        
        if !isTwoPlayer {
            duckCount.text = "You: 0"
        }
        
        duckCount.isHidden = false
        foxCount.isHidden = false
        
        startOverOutlet.isEnabled = false
        startOverOutlet.isHidden = true
        
        startGameOutlet.isHidden = true
        startGameOutlet.isEnabled = false
    }

    
    
    //plus one button press
    @IBAction func buttonPress(_ sender: AnyObject) {
        
        
        
        //detect edge of screen(sort of)
        if(x1 == edgeWidth && y1 > 10){
            
            y1 -= screenRatioH
            duckView.transform = CGAffineTransform(rotationAngle: -CGFloat.pi/2)

        } else if(x1 > 30 && y1 < 20){
            
            x1 -= screenRatio
            duckView.transform = CGAffineTransform(rotationAngle: CGFloat.pi)

        }else if(x1 <= 30 && y1 < (screenHeight - 150)){
            
            y1 += screenRatioH
            duckView.transform = CGAffineTransform(rotationAngle: CGFloat.pi/2)
            
        }else {
            
            x1 += screenRatio
            duckView.transform = CGAffineTransform(rotationAngle: 0)
            
        }
        
        //animate and draw images
         UIView.animate(withDuration: 0.2, animations: ({
            self.duckView.frame = CGRect(x: self.x1, y: self.y1, width: 68, height: 68)
            self.view.addSubview(self.duckView)
        }))
        
        collDetectDuck()

        keepScore()
        
    }//
    
    //fox button
    @IBAction func foxButtonPress(_ sender: Any) {
        
        //detect edge of screen(sort of)
        if(x2 < edgeWidth && y2 <= 10){
            
            x2 += screenRatio
            foxView.transform = CGAffineTransform(rotationAngle: CGFloat.pi)
            
        } else if(x2 == edgeWidth && y2 < (screenHeight - 150)){
            
            y2 += screenRatioH
            foxView.transform = CGAffineTransform(rotationAngle: -CGFloat.pi/2)
            
        }else if(x2 > 10 && y2 > (screenHeight - 150)){
            
            x2 -= screenRatio
            foxView.transform = CGAffineTransform(rotationAngle: 0)
            
        }else {
            
            y2 -= screenRatioH
            foxView.transform = CGAffineTransform(rotationAngle: CGFloat.pi/2)
            
        }
        
        //animate and draw images
        UIView.animate(withDuration: 0.2, animations: ({
            self.foxView.frame = CGRect(x: self.x2, y: self.y2, width: 68, height: 68)
            self.view.addSubview(self.foxView)
        }))
        
        //call collision detection
        collDetectFox()

        keepScore()
    }//
   
    
    
    //collsion detetcion Fox
    func collDetectFox(){
        
        if (foxView.frame.intersects(finishView.frame)){
            foxC += 1
            //playSound()
            foxCount.text = "Mallard: " + String(foxC)
            Sound.play(file: "quack.wav")
        }
 
    }//
    
    //collsion detetcion Duck
    func collDetectDuck(){
        
        if (duckView.frame.intersects(finishView.frame)){
            duckC += 1
            
            if isTwoPlayer{
                duckCount.text = "Pekin: \(duckC)"
            } else {
                duckCount.text = "You: \(duckC)"
            }
            Sound.play(file: "quack.wav")

        }
        
    }//
    
 
    
    //reset everything
    @IBAction func playAgainReset(_ sender: Any) {
        foxC = 0
        duckC = 0
        
        x1 = edgeWidth
        y1 = (screenHeight / 2) - screenRatioH
        x2 = edgeWidth
        y2 = (screenHeight / 2) + screenRatioH
        
        //reset labels
        foxCount.text = "Mallard: " + String(foxC)
        duckCount.text = "Pekin: " + String(duckC)

        //re enable buttons
        foxButton.isEnabled = true
        duckButton.isEnabled = true
        
        //play again button
        playAgainOutlet.setTitle("Play Again", for: .normal)
        playAgainOutlet.isHidden = true
        playAgainOutlet.isEnabled = false
        
        startGameOutlet.isHidden = false
        startGameOutlet.isEnabled = true
        
        scoreLabel.text = (" ")

        
        //re orientate duck
        duckView.transform = CGAffineTransform(rotationAngle: -CGFloat.pi/2)
        
        //draw duck
        self.duckView.frame = CGRect(x: self.x1, y: self.y1, width: 68, height: 68)
        self.view.addSubview(self.duckView)
        
        //re orientate fox
        foxView.transform = CGAffineTransform(rotationAngle: -CGFloat.pi/2)
        
        //re draw fox
        self.foxView.frame = CGRect(x: self.x2, y: self.y2, width: 68, height: 68)
        self.view.addSubview(self.foxView)
        
        timer.fire()
        
        preGameClean()
        rollForAds()
        
    }
    
    @IBAction func startGameAction(_ sender: Any) {
        startGame()
    }
    
  //keep score and end game
    func keepScore(){
        if(foxC == scoreLimit || duckC == scoreLimit){
            
            //disable butons when game is over
            foxButton.isEnabled = false
            duckButton.isEnabled = false
            
            //show play again button
            playAgainOutlet.isHidden = false
            playAgainOutlet.isEnabled = true
            
            //show start over
            startOverOutlet.isEnabled = true
            startOverOutlet.isHidden = false
            
            
            timer.invalidate()
            
            cpuTimer.invalidate()
            
            //display winner when score is achieved
            if(foxC == scoreLimit){
                
                //single player lose message
                if !isTwoPlayer{
                    scoreLabel.text = ("Game Over! \n You Lose!")

                    
                    Sound.play(file: "lose.wav")
                } else {
                    //two player message
                    scoreLabel.text = ("Game Over! \n Mallard Wins!")

                    Sound.play(file: "victory.wav")

                }

            }else if(duckC == scoreLimit){
                
                //two player winner message
                if isTwoPlayer{
                    scoreLabel.text = ("Game Over! \n Pekins Wins!")
                }else {
                    
                    //single player win message
                    scoreLabel.text = ("Game Over! \n You Win!")

                }
                
                Sound.play(file: "victory.wav")
                
            }
    }
}
    
    @objc func cpuDuck(){
            self.foxButtonPress(UIControlEvents.touchUpInside)
    }

    /// Tells the delegate an ad request succeeded.
    func interstitialDidReceiveAd(_ ad: GADInterstitial) {
        print("interstitialDidReceiveAd")
    }
    
    /// Tells the delegate an ad request failed.
    func interstitial(_ ad: GADInterstitial, didFailToReceiveAdWithError error: GADRequestError) {
        print("interstitial:didFailToReceiveAdWithError: \(error.localizedDescription)")
    }

}

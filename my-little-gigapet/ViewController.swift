//
//  ViewController.swift
//  my-little-gigapet
//
//  Created by Cortell Shaw on 5/28/16.
//  Copyright © 2016 TwoFiveDev. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {
    
    @IBOutlet weak var monsterImg: MonsterImg!
    @IBOutlet weak var heart: DragImg!
    @IBOutlet weak var foodImg: DragImg!
    
    
    @IBOutlet weak var penalty1img: UIImageView!
    @IBOutlet weak var penalty2img: UIImageView!
    @IBOutlet weak var penalty3img: UIImageView!
    
        let DIM_ALPHA: CGFloat = 0.2
        let OPAQUE: CGFloat = 1.0
        let MAX_PENALTIES = 3
        var currentPenalties = 0
        var timer = NSTimer!()
        var monsterHappy = false
        var currentItem: UInt32 = 0
    
    var musicPlayer: AVAudioPlayer!
    var sfxBite: AVAudioPlayer!
    var sfxHeart: AVAudioPlayer!
    var sfxDeath: AVAudioPlayer!
    var sfxSkull: AVAudioPlayer!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
     
        
        foodImg.dropTarget = monsterImg
        heart.dropTarget = monsterImg
        
        penalty1img.alpha = DIM_ALPHA
        penalty2img.alpha = DIM_ALPHA
        penalty3img.alpha = DIM_ALPHA
        
     
        NSNotificationCenter.defaultCenter().addObserver(self, selector:(#selector(ViewController.itemDroppedOnCharacter(_:))), name: "onTargetDropped", object: nil)
        
        do {
            let resourcePath = NSBundle.mainBundle().pathForResource("cave-music", ofType: "mp3")!
            let url = NSURL(fileURLWithPath: resourcePath)
            try musicPlayer = AVAudioPlayer(contentsOfURL: url)
            
            try sfxBite = AVAudioPlayer(contentsOfURL: NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("bite", ofType: "wav")!))
            
            try sfxHeart = AVAudioPlayer(contentsOfURL: NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("heart", ofType: "wav")!))
            
            try sfxDeath = AVAudioPlayer(contentsOfURL: NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("death", ofType: "wav")!))
            
            try sfxSkull = AVAudioPlayer(contentsOfURL: NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("skull", ofType: "wav")!))
            
            musicPlayer.prepareToPlay()
            musicPlayer.play()
            
            sfxBite.prepareToPlay()
            sfxHeart.prepareToPlay()
            sfxDeath.prepareToPlay()
            sfxSkull.prepareToPlay()
            
        } catch let err as NSError {
            print(err.debugDescription)
        
        }
        
        startTimer()
    }
      func itemDroppedOnCharacter(notif: AnyObject){
        monsterHappy = true
        startTimer()
        
        foodImg.alpha = DIM_ALPHA
        foodImg.userInteractionEnabled = false
        heart.alpha = DIM_ALPHA
        heart.userInteractionEnabled = false
        
        if currentItem == 0 {
            sfxHeart.play()
        } else {
            sfxBite.play()
        }
    
    }
    
    
    
    func startTimer(){
        if timer != nil {
            timer.invalidate()
        }
        
        timer = NSTimer.scheduledTimerWithTimeInterval(3.0, target: self, selector: #selector(ViewController.changeGameState), userInfo: nil, repeats: true)
    
    }
    
    func changeGameState(){
        
        if !monsterHappy {
        
        currentPenalties += 1
            
            sfxSkull.play()
        
        if currentPenalties == 1 {
            penalty1img.alpha = OPAQUE
            penalty2img.alpha = DIM_ALPHA
        
        } else if currentPenalties == 2 {
            penalty2img.alpha = OPAQUE
            penalty3img.alpha = DIM_ALPHA
        
        } else if currentPenalties >= 3 {
            penalty3img.alpha = OPAQUE
        } else {
            penalty1img.alpha = DIM_ALPHA
            penalty2img.alpha = DIM_ALPHA
            penalty3img.alpha = DIM_ALPHA
        }
        
        if currentPenalties >= MAX_PENALTIES{
            gameOver()
        }
    

        
        }
        
        let rand = arc4random_uniform(2) // 0 or 1
        
        if rand == 0 {
            foodImg.alpha = DIM_ALPHA
            foodImg.userInteractionEnabled = false
            
            heart.alpha = OPAQUE
            heart.userInteractionEnabled = true
        } else {
            heart.alpha = DIM_ALPHA
            heart.userInteractionEnabled = false
            
            foodImg.alpha = OPAQUE
            foodImg.userInteractionEnabled = true
        
        }
        
        currentItem = rand
        monsterHappy = false
        
    }
    
    func gameOver(){
          timer.invalidate()
          monsterImg.playDeathAnimation()
        sfxDeath.play()
    
    }
      
  

}


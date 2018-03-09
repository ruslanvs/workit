//
//  ViewController.swift
//  workit
//
//  Created by Ruslan Suvorov on 3/8/18.
//  Copyright © 2018 Ruslan Suvorov. All rights reserved.
//

import UIKit
import CoreMotion
import AVFoundation

class ViewController: UIViewController {
    @IBOutlet weak var countLabel: UILabel!
    @IBOutlet weak var squatButton: UIButton!
    @IBOutlet weak var jumpButton: UIButton!
    @IBOutlet weak var buttonStack: UIStackView!
    @IBOutlet weak var resetButton: UIButton!
    
    let synth = AVSpeechSynthesizer()
    var myUtterance = AVSpeechUtterance(string: "")
    
    var motionManager = CMMotionManager()
    let opQueue = OperationQueue()
    
    var messagebank = [ "You're doing great!", "Keep it up!", "You rock!", "Feel the burn!!", "Peanut Butter Jelly", "Bear House"]
    
    var count = 0
    var squatmode = false
    var jumpmode = false
    
    @IBAction func squatButtonPressed(_ sender: UIButton) {
        DispatchQueue.main.async(execute: {
            self.countLabel.font = self.countLabel.font.withSize(250)
            self.squatButton.isHidden = true
            self.jumpButton.isHidden = true})
        squatmode = true
        var start = false
        var current = 0.00
        
        motionManager.deviceMotionUpdateInterval = 0.024
        // start reading
        motionManager.startDeviceMotionUpdates(to: opQueue) {
            (data: CMDeviceMotion?, error: Error?) in
            
            if let mydata = data {
                let pitch = self.degrees(mydata.attitude.pitch)
                
                if (pitch > 75 )  ||  (pitch < -75){
                    start = true
                    current = pitch
                }
                if(start == true){
                    if(current < -75 && pitch > -45 ){
                        self.count += 1
                        start = false
                        DispatchQueue.main.async(execute: {
                            self.countLabel.text = String(self.count)
                            if Int(arc4random_uniform(6)) == 0 {
                                let randphrase = self.messagebank[Int(arc4random_uniform(UInt32(self.messagebank.count)))]
                                self.myUtterance = AVSpeechUtterance(string: randphrase)
                            }
                            else {
                                self.myUtterance = AVSpeechUtterance(string: self.countLabel.text!)
                                
                            }
                            self.myUtterance.rate = 0.3
                            self.synth.speak(self.myUtterance)
                        })
                    }
                    if(current > 75 && pitch < 45 ){
                        self.count += 1
                        start = false
                        DispatchQueue.main.async(execute: {
                            self.countLabel.text = String(self.count)
                            if Int(arc4random_uniform(6)) == 0 {
                                let randphrase = self.messagebank[Int(arc4random_uniform(UInt32(self.messagebank.count)))]
                                self.myUtterance = AVSpeechUtterance(string: randphrase)
                            }
                            else {
                                self.myUtterance = AVSpeechUtterance(string: self.countLabel.text!)
                                
                            }
                            self.myUtterance.rate = 0.3
                            self.synth.speak(self.myUtterance)
                        })
                    }
                }
            }
        }

    }
    
    @IBAction func jumpButtonPressed(_ sender: UIButton){
        DispatchQueue.main.async(execute: {
            self.countLabel.font = self.countLabel.font.withSize(250)
            self.squatButton.isHidden = true
            self.jumpButton.isHidden = true})
        jumpmode = true
        // set read speed
        motionManager.deviceMotionUpdateInterval = 0.024
        // start reading
        motionManager.startDeviceMotionUpdates(to: opQueue) {
            (data: CMDeviceMotion?, error: Error?) in
            
            if let mydata = data {
                if mydata.userAcceleration.y > 4{
                    if self.jumpmode == true {
                        self.count += 1
                        print (self.count)
                        DispatchQueue.main.async(execute: {
                            self.countLabel.text = String(self.count)
                            if Int(arc4random_uniform(6)) == 0 {
                                let randphrase = self.messagebank[Int(arc4random_uniform(UInt32(self.messagebank.count)))]
                                self.myUtterance = AVSpeechUtterance(string: randphrase)
                                self.myUtterance.rate = 0.5
                            }
                            else {
                                self.myUtterance = AVSpeechUtterance(string: self.countLabel.text!)
                                self.myUtterance.rate = 0.6
                            }
                            
                            self.synth.speak(self.myUtterance)
                            
                        })
                    }
                }
            }
        }
    }
    
    @IBAction func resetButtonPressed(_ sender: UIButton) {
        self.countLabel.text = "0"
        count = 0
        squatmode = false
        jumpmode = false
        squatButton.isHidden = false
        jumpButton.isHidden = false
        countLabel.font = countLabel.font.withSize(120)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        squatButton.layer.cornerRadius = 5
        jumpButton.layer.cornerRadius = 5
        resetButton.layer.cornerRadius = 5
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    func degrees(_ radians: Double) -> Double {
        return 180/Double.pi * radians
    }
    
}

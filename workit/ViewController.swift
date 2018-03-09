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
    
    let synth = AVSpeechSynthesizer()
    var myUtterance = AVSpeechUtterance(string: "")
    
    var motionManager = CMMotionManager()
    let opQueue = OperationQueue()
    
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
                            if self.count % 5 == 0 {
                                self.myUtterance = AVSpeechUtterance(string: "You like what you see?")
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
                            if self.count % 5 == 0 {
                                self.myUtterance = AVSpeechUtterance(string: "You like what you see?")
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
                            if self.count % 5 == 0 {
                                self.myUtterance = AVSpeechUtterance(string: "Keep going, get that green belt!")
                            }
                            else {
                                self.myUtterance = AVSpeechUtterance(string: self.countLabel.text!)
                                
                            }
                            self.myUtterance.rate = 0.6
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
        
//        if motionManager.isDeviceMotionAvailable {
//            print("We can detect device motion")
//            startReadingMotionData()
//        }
//        else {
//            print("We cannot detect device motion")
//        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
//    func startReadingMotionData() {
//        // set read speed
//        motionManager.deviceMotionUpdateInterval = 1
//        // start reading
//        motionManager.startDeviceMotionUpdates(to: opQueue) {
//            (data: CMDeviceMotion?, error: Error?) in
//
//            if let mydata = data {
//                print("mydata", mydata.gravity)
//                                print("pitch raw", mydata.attitude.pitch)
//                                print("pitch", self.degrees(mydata.attitude.pitch))
//            }
//        }
//    }
    
    
    func degrees(_ radians: Double) -> Double {
        return 180/Double.pi * radians
    }
    
}

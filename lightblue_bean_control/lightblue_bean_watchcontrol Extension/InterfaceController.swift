//
//  InterfaceController.swift
//  test2 WatchKit Extension
//
//  Created by 秦暐峻 on 2015/10/1.
//  Copyright © 2015年 秦暐峻. All rights reserved.
//

import WatchKit
import Foundation
import WatchConnectivity
import CoreLocation
import UIKit



class InterfaceController: WKInterfaceController, WCSessionDelegate{
    
    
    @IBOutlet var conLabel: WKInterfaceLabel!
    private var counter = 0
    
    private let session : WCSession? = WCSession.isSupported() ? WCSession.defaultSession() : nil
    
    override init() {
        super.init()
        
        session?.delegate = self
        session?.activateSession()
    }
    
    @IBOutlet var location: WKInterfaceLabel!
    @IBAction func start1() {
        let applicationData = ["counterValue" : 1]
        
        // The paired iPhone has to be connected via Bluetooth.
        if let session = session where session.reachable {
            session.sendMessage(applicationData,
                replyHandler: { replyData in
                    // handle reply from iPhone app here
                    print(replyData)
                }, errorHandler: { error in
                    // catch any errors here
                    print(error)
            })
        } else {
            // when the iPhone is not connected via Bluetooth
        }
        
    }
    var start = false
    @IBOutlet var startb: WKInterfaceButton!
    
    
    
    @IBAction func startbtn() {
        
        if(start==false){
            start = true
            self.startb.setTitle("取消")
        }
        else{
            start = false
            self.startb.setTitle("開始")
        }
        let applicationData = ["counterValue" : 1]
        
        // The paired iPhone has to be connected via Bluetooth.
        if let session = session where session.reachable {
            session.sendMessage(applicationData,
                replyHandler: { replyData in
                    // handle reply from iPhone app here
                    print(replyData)
                }, errorHandler: { error in
                    // catch any errors here
                    print(error)
            })
        } else {
            // when the iPhone is not connected via Bluetooth
        }
        
    

        
    }
    
    
    
    
    override func awakeWithContext(context: AnyObject?) {
        super.awakeWithContext(context)
        if WCSession.isSupported() {
            let wcsession = WCSession.defaultSession()
            wcsession.delegate = self
            wcsession.activateSession()
            wcsession.sendMessage(["update": "list"], replyHandler: { (dict) -> Void in
                print("InterfaceController session response: \(dict)")
                }, errorHandler: { (error) -> Void in
                    print("InterfaceController session error: \(error)")
            })
        }
    }
    
    override func willActivate() {
        super.willActivate()
    }
    
    override func didDeactivate() {
        super.didDeactivate()
    }
    
    
    func session(session: WCSession, didReceiveMessage message: [String : AnyObject], replyHandler: ([String : AnyObject]) -> Void) {
        dispatch_async(dispatch_get_main_queue()) {
           if let counterValue = message["counterValue"] as? Int {
                WKInterfaceDevice().playHaptic(.Stop)
                NSLog("receive")
                let myString = String(counterValue)
                
            }
                /*if let counterValue = message["counterValue"] as? String{
                WKInterfaceDevice().playHaptic(.Success)
                NSLog("receive")
                self.conLabel.setText(counterValue)
                }*/
            else if let counterValue = message["counterValue"] as? String{
                if counterValue == "success"{
                    self.willActivate()
                    self.awakeWithContext("success")
                    WKInterfaceDevice().playHaptic(.Success)
                    NSLog(counterValue)
                    self.conLabel.setText(counterValue)
                }
                else if counterValue == "failure"{
                    WKInterfaceDevice().playHaptic(.Failure)
                    NSLog(counterValue)
                }
                else if counterValue == "retry"{
                    WKInterfaceDevice().playHaptic(.Retry)
                    NSLog(counterValue)
                }
                else if counterValue == "start"{
                    WKInterfaceDevice().playHaptic(.Start)
                    NSLog(counterValue)
                }
                else if counterValue == "stop"{
                    WKInterfaceDevice().playHaptic(.Stop)
                    NSLog(counterValue)
                }
                else if counterValue == "click"{
                    WKInterfaceDevice().playHaptic(.Click)
                    NSLog(counterValue)
                }
                else if counterValue == "turnright"{
                    WKInterfaceDevice().playHaptic(.Failure)
                    NSLog(counterValue)
                    self.conLabel.setText("請向右轉")
                }
                else if counterValue == "turnleft"{
                    WKInterfaceDevice().playHaptic(.Failure)
                    NSLog(counterValue)
                    self.conLabel.setText("請向左轉")
                }
                else if counterValue == "gostraight"{
                    NSLog(counterValue)
                    self.conLabel.setText("請繼續直行")
                    
                }
                else if counterValue == "notification"{
                    WKInterfaceDevice().playHaptic(.Notification)
                    NSLog(counterValue)
                }
                else if counterValue == "directionup"{
                    WKInterfaceDevice().playHaptic(.DirectionUp)
                    NSLog(counterValue)
                }
                else if counterValue == "directiondown"{
                    WKInterfaceDevice().playHaptic(.DirectionDown)
                    NSLog(counterValue)
                }
                else{
                    let myString = String(counterValue)
                    WKInterfaceDevice().playHaptic(.Failure)
                    self.location.setText(myString)
                    
                    //NSLog(counterValue)
                }
                //self.conLabel.setText(counterValue)
            }
            
        }
    }
    
    

    
    
    
}


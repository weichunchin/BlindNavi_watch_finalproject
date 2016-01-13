//
//  ViewController.swift
//  lightblue_bean_control
//
//  Created by copper on 6/2/15.
//  Copyright (c) 2015 sulphate. All rights reserved.
//

import UIKit
import AVFoundation
import WatchConnectivity
import CoreLocation

@available(iOS 9.0, *)
class ViewController: UIViewController, PTDBeanManagerDelegate, PTDBeanDelegate, UIPickerViewDataSource, UIPickerViewDelegate,CLLocationManagerDelegate{

    let locationManager = CLLocationManager()
    @IBAction func turnright(sender: AnyObject) {
        let applicationData = ["counterValue" : "turnright"]
        NSLog("success")
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
    @IBAction func turnleft(sender: AnyObject) {
        let applicationData = ["counterValue" : "turnleft"]
        NSLog("success")
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
    @IBAction func gostraight(sender: AnyObject) {
        let applicationData = ["counterValue" : "gostraight"]
        NSLog("success")
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
    let region = CLBeaconRegion(proximityUUID: NSUUID(UUIDString: "2a782241-52f4-4194-bf93-f7de85f0d38c")!, identifier: "Estimotes")
    
    let colors = [
        5: UIColor(red: 84/255, green: 77/255, blue: 160/255, alpha: 1),
        6: UIColor(red: 142/255, green: 212/255, blue: 220/255, alpha: 1),
        27327: UIColor(red: 162/255, green: 213/255, blue: 181/255, alpha: 1)
    ]
    
    @IBAction func button1(sender: AnyObject) {
        
        let applicationData = ["counterValue" : "success"]
        NSLog("success")
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
    private var counterData = [Int]()
    var test = 1
    
    private var conditionData = [String]()
    var test2 = "success"

    
    
    
    

    
    
    @IBOutlet weak var degree: UILabel!
    
    var beanManager = PTDBeanManager()
    var connectedBean: PTDBean?
    
    // Define the name of your LightBlue Bean
    var beanName = ""
    
    var statusTimer: NSTimer?
    var connectTimer: NSTimer?
    
    var soundURL: NSURL?
    var soundID:SystemSoundID = 0
    
    @IBOutlet weak var statusDrawer: UIView!
    //@IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    
    @IBOutlet weak var beanLabel: UILabel!
    @IBOutlet weak var batteryLevel: UILabel!
    @IBOutlet weak var beanPicker: UIPickerView!
    
    @IBOutlet weak var ambientTemp: UILabel!
    @IBOutlet weak var lastDiscovered: UILabel!
    

       let MAXVOLT: Float = 3.53
    let MINVOLT: Float = 1.95
    
    private let session: WCSession? = WCSession.isSupported() ? WCSession.defaultSession() : nil
    
    
    
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        configureWCSession()
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        
        configureWCSession()
    }
    
    private func configureWCSession() {
        session?.delegate = self;
        session?.activateSession()
    }
    
    override func viewDidLoad() {
        
        
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        locationManager.delegate = self
        if (CLLocationManager.authorizationStatus() != CLAuthorizationStatus.AuthorizedWhenInUse) {
            locationManager.requestWhenInUseAuthorization()
        }
        locationManager.startRangingBeaconsInRegion(region)
        
        
        if (!timer.valid) {
            
            // 每3秒報一次
//            timer = NSTimer.scheduledTimerWithTimeInterval(3, target: self, selector: "tts_timer", userInfo: nil, repeats: true)
//            
            
            }
          
        
        // init labels
        let newBounds = CGRect(x: 0, y: 40, width: UIScreen.mainScreen().bounds.size.width, height: 40)
        self.statusDrawer.bounds = newBounds
        self.statusDrawer.backgroundColor = UIColor.whiteColor()
        
        if (beanName == "") {
            beanName = "RemoteBean"
        }
        
        
        beanManager.delegate = self
        beanPicker.delegate = self
        
        self.beanLabel.text = beanName
        self.beanLabel.textColor = UIColor.redColor()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func locationManager(manager: CLLocationManager, didRangeBeacons beacons: [CLBeacon], inRegion region: CLBeaconRegion) {
        let knownBeacons = beacons.filter{ $0.proximity != CLProximity.Unknown }
        if (knownBeacons.count > 0) {
            let closestBeacon = knownBeacons[0] as CLBeacon
            
            let applicationData = ["counterValue" : closestBeacon.minor.integerValue]
            let mystring = String(closestBeacon.minor.integerValue)
            NSLog(mystring)
            // The paired iPhone has to be connected via Bluetooth.
   /*         if let session = session where session.reachable {
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
*/
        }
    }
    
    @IBAction func success(sender: AnyObject) {
        
        let applicationData = ["counterValue" : "success"]
        NSLog("success")
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
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return 2
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String! {
        var name: NSString?
        if (row == 0) {
            name = "RemoteBean"
        } else if (row == 1) {
            name = "RemotePlus"
        }
        return name as! String
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if (row == 0) {
            beanName = "RemoteBean"
        } else if (row == 1) {
            beanName = "RemotePlus"
        }
        self.beanLabel.text = beanName
        // dealloc the old bean
        var dcError: NSError?
        if (connectedBean != nil) {
            self.beanManager.disconnectBean(connectedBean!, error: &dcError)
            connectedBean = nil
        }
        if (dcError != nil) {
            printStatusLabel("Error disconnecting \(beanName)")
        } else {
            // Perform a rescan on a reselection of picker view
            startScanBeans()
        }
    }
    
    func beanManagerDidUpdateState(beanManager: PTDBeanManager!) {
        if (beanManager.state == BeanManagerState.PoweredOn) {
            startScanBeans()
        } else if (beanManager.state == BeanManagerState.PoweredOff) {
            printStatusLabel("Device Powered off")
        } else if (beanManager.state == BeanManagerState.Unauthorized) {
            printStatusLabel("Device Unauthorized")
        } else if (beanManager.state == BeanManagerState.Unknown) {
            printStatusLabel("Device state unknown")
        } else if (beanManager.state == BeanManagerState.Resetting) {
            printStatusLabel("Device Resetting")
        } else if (beanManager.state == BeanManagerState.Unsupported) {
            printStatusLabel("Device Unsupported")
        }
    }
    
    func BeanManager(beanManager: PTDBeanManager!, didDiscoverBean bean: PTDBean!, error: NSError!) {
        if (error == nil) {
            var connectError: NSError?
            NSLog("Found bean: \(bean.name)")
            // Connect only to defined bean
            if (bean.name == beanName) {
                NSLog("Bean Match: \(bean.name)")
                beanManager.connectToBean(bean, error: &connectError)
                if (connectError == nil) {
                    printStatusLabel("Connecting to Bean: \(bean.name)")
                    beanManager.stopScanningForBeans_error(&connectError)
                }
            }
        }
    }
    
    func BeanManager(beanManager: PTDBeanManager!, didConnectToBean bean: PTDBean!, error: NSError!) {
        printStatusLabel("Connected to \(bean.name)")
        connectedBean = bean
        connectedBean!.delegate = self
        blink(1, color: UIColor.greenColor())
        populateInfo()
        
    }
    
    func BeanManager(beanManager: PTDBeanManager!, didDisconnectBean bean: PTDBean!, error: NSError!) {
        printStatusLabel("Disconnected from Bean \(bean.name)")
        connectedBean = nil
           }
    
    func startScanBeans() {
        var scanError: NSError?
        beanManager.startScanningForBeans_error(&scanError)
        blink(1, color: UIColor.yellowColor())
        if (scanError != nil) {
            printStatusLabel("Error starting scan")
        } else {
            printStatusLabel("Re-scanning for \(beanName)")

            let selector: Selector = "stopScanBeans"
            if (self.connectTimer != nil) {
                self.connectTimer!.invalidate()
            }
            self.connectTimer = NSTimer.scheduledTimerWithTimeInterval(NSTimeInterval(120.0), target: self, selector: selector, userInfo: nil, repeats: false)
            
        }
    }
    
    func stopScanBeans() {
        self.beanLabel.text = beanName
        if (connectedBean==nil) {
            showAlert("Cannot find \(beanName) after 2 minutes. Refresh to try again.")
            self.beanLabel.textColor = UIColor.redColor()
        }
        var dcError: NSError?
        beanManager.stopScanningForBeans_error(&dcError)
    }
    
    
    
    @IBAction func showBeanName(sender: AnyObject) {
        // Perform a rescan on a reselection of picker view
        var scanError: NSError?
        NSLog("Current Selected: \(beanPicker.selectedRowInComponent(0))")
        if (beanPicker.selectedRowInComponent(0) == 0) {
            beanName = "RemoteBean"
        } else {
            beanName = "RemotePlus"
        }
        if (connectedBean != nil && connectedBean!.name == beanName) {
            printStatusLabel(connectedBean!.name)
            populateInfo()
        } else {
            printStatusLabel("No connected Bean!")
            startScanBeans()
        }
    }
   
    
    func populateInfo() {
        self.beanLabel.text = beanName
        
        if (connectedBean != nil && connectedBean!.name == beanName) {
            
            blink(0.3, color: UIColor.blueColor())
            self.beanLabel.textColor = UIColor.blackColor()
            
            connectedBean!.readBatteryVoltage()
            connectedBean!.readTemperature()
            
            let dateFormatter = NSDateFormatter()
            dateFormatter.dateStyle = .MediumStyle
            dateFormatter.timeStyle = .MediumStyle
            
            self.lastDiscovered.text = dateFormatter.stringFromDate(connectedBean!.lastDiscovered)
        } else {
            self.beanLabel.textColor = UIColor.redColor()
        }
    }
    
    func bean(bean: PTDBean!, didUpdateTemperature degrees_celsius: NSNumber!) {
        self.ambientTemp.text = "\(degrees_celsius.stringValue) Celcius"
    }
    
    func beanDidUpdateBatteryVoltage(bean: PTDBean!, error: NSError!) {
        let level = self.getBatteryLevel()
        self.batteryLevel.text = "\(level)% @ \(bean!.batteryVoltage.stringValue) Volts"
    }
    
    // Status Label functions
    
    func printStatusLabel(title: String) {
        self.statusLabel.text = title
        openStatusLabel()
    }
    
    func openStatusLabel() {
        UIView.animateWithDuration(1, animations: { () -> Void in
                let newBounds = CGRect(x: 0, y: 0, width: UIScreen.mainScreen().bounds.size.width, height: 40)
                self.statusDrawer.bounds = newBounds
                self.statusDrawer.backgroundColor = UIColor.lightGrayColor()
            }, completion: {(complete: Bool) in
                let selector: Selector = "closeStatusLabel"
                if (self.statusTimer != nil) {
                    self.statusTimer!.invalidate()
                }
                self.statusTimer = NSTimer.scheduledTimerWithTimeInterval(NSTimeInterval(5.0), target: self, selector: selector, userInfo: nil, repeats: false)
        })
    }

    func closeStatusLabel() {
        UIView.animateWithDuration(1, animations: { () -> Void in
                let newBounds = CGRect(x: 0, y: 40, width: UIScreen.mainScreen().bounds.size.width, height: 40)
                self.statusDrawer.bounds = newBounds
                self.statusDrawer.backgroundColor = UIColor.whiteColor()
            }
        )
    }
    
    func blink(time: Double, color: UIColor) {
        if (connectedBean != nil) {
            connectedBean!.setLedColor(color)
            clearLEDTimer(time)
        }
    }
    
    func clearLEDTimer(time: Double) {
        let selector: Selector = "clearLED"
        NSTimer.scheduledTimerWithTimeInterval(time, target: self, selector: selector, userInfo: nil, repeats: false)
    }
    
    func clearLED() {
        if (connectedBean != nil) {
            connectedBean!.setLedColor(UIColor.blackColor())
        }
    }
    
    func getBatteryLevel() -> Int {
        if (connectedBean != nil) {
            let currentVolt = connectedBean!.batteryVoltage.floatValue
            if ( currentVolt > MAXVOLT) {
                return 100
            } else {
                let value = (connectedBean!.batteryVoltage.floatValue - MINVOLT) / (MAXVOLT - MINVOLT) * 100
                return Int(value)
            }
        } else {
            return 0
        }
    }
    
    func showAlert(message: String) {
        let alert = UIAlertController(title: "Bean Alert", message: message, preferredStyle: UIAlertControllerStyle.Alert)
        let okResponse = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil)
        alert.addAction(okResponse)
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    
    struct Data_block {
        var degree : Int16 = 0
        var btn : Int16 = 0
        var eol : Int16 = 0
        var xxxx : Int16 = 0
        
    }
    func vibrate() {
        let soundID = SystemSoundID(kSystemSoundID_Vibrate)
        
        //使用AudioServicesPlaySystemSound播放
        AudioServicesPlaySystemSound(soundID)
    }
    var flag_btn_pre: Int16 = 0x3030
    var left_max = 0
    var right_max = 0
    var middle =  0
    //var d1 = Data_block()
    var degree_temp : Int = 0
    var degree_enter : Int = 0
    var audioPlayer = AVAudioPlayer()
    var flag_enter = false // start and cancel
    var flag_dir = 0 // 0:straught, 1:right , 2:left
    var timer:NSTimer = NSTimer()
    
    var flag_pre = 0
    var flag_cur = 0  // status

    let synth = AVSpeechSynthesizer()
    var myUtterance = AVSpeechUtterance(string: "")

    var left_cnt = 0
    var right_cnt = 0
    var go_cnt = 0
    
  
    @IBAction func Enter(sender: UIButton) {
   
    
    
        if (flag_enter == false){ //flase to true
            tts1("開始上路，請繼續直行")
            flag_enter = true;
            sender.setTitle("取消", forState: .Normal)
            timer = NSTimer.scheduledTimerWithTimeInterval(3, target: self, selector: "tts_timer", userInfo: nil, repeats: true)
        }
        else {
            tts1("取消")
            flag_enter = false;
            sender.setTitle("開始", forState: .Normal)
            //time voice cancel
            timer.invalidate()
        }
        
        //tts("goStraight")
        self.degreeWant.text = self.degree.text
        degree_enter = degree_temp
        self.show.text = "請繼續直行"
        
        
    }
    
    //
    func btn_action(){
        
        
        if (flag_enter == false){ //flase to true
            tts1("開始上路，請繼續直行")
            flag_enter = true;
            //sender.setTitle("取消", forState: .Normal)
            timer = NSTimer.scheduledTimerWithTimeInterval(3, target: self, selector: "tts_timer", userInfo: nil, repeats: true)
        }
        else {
            tts1("取消")
            flag_enter = false;
            //sender.setTitle("開始", forState: .Normal)
            //time voice cancel
            timer.invalidate()
        }
        
        //tts("goStraight")
        self.degreeWant.text = self.degree.text
        degree_enter = degree_temp
        self.show.text = "請繼續直行"
        
        
    }
    
    
    //
    
    @IBOutlet weak var text: UITextField!
    
    
    @IBOutlet weak var degreeWant: UILabel!
    
    @IBOutlet weak var show: UILabel!
    
    
    func tts1(content:String){
       
        do {
            try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback)
        } catch _ {
        }
        do {
            try AVAudioSession.sharedInstance().setActive(true)
        } catch _ {
        }

        //var mySpeechSynthesizer:AVSpeechSynthesizer = AVSpeechSynthesizer()
        //var myString:String = content
        let mySpeechUtterance:AVSpeechUtterance = AVSpeechUtterance(string: content)
        
        print("\(mySpeechUtterance.speechString)")
        print("My string - \(content)")
        
        synth.speakUtterance(mySpeechUtterance)
        

        
    }
    
    
    
    func tts(content:String) {
        
        
        var alertSound = NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource(content, ofType: "wav")!)
        print(alertSound)
        
        do {
            // Removed deprecated use of AVAudioSessionDelegate protocol
            try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback)
        } catch _ {
        }
        do {
            try AVAudioSession.sharedInstance().setActive(true)
        } catch _ {
        }
        
        var error:NSError?
        do {
            audioPlayer = try AVAudioPlayer(contentsOfURL: alertSound)
        } catch var error1 as NSError {
            error = error1
            
        }
        audioPlayer.prepareToPlay()
        audioPlayer.play()
        
        
        
    }

    
    func tts_timer(){
        
        if (flag_enter == true) {
        
            if (flag_dir == 0){tts1("go straight")}
            else if (flag_dir == 1) {tts1("turn left")
                let applicationData = ["counterValue" : "turnleft"]
                NSLog("turnleft")
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
            else {tts1("turn right")
                let applicationData = ["counterValue" : "turnright"]
                NSLog("turnright")
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
        }
    }
    
    var first = 0
    
    
    
    
    func bean(bean: PTDBean!, serialDataReceived data: NSData!) {
        
        var d1 = Data_block()
        //data.getBytes(&temp, length: 2)
        
        data.getBytes(&d1, length: 6)
        degree_temp = Int(d1.degree)
        if (first == 0) {
            flag_btn_pre = d1.btn
            first = 1
        }
        //btn status change
        if (d1.btn != flag_btn_pre){
                
                btn_action()
                flag_btn_pre = d1.btn
                
            }
        
        
        NSLog("mytest: %d", degree_temp)
        degree.text = String(degree_temp)
        
        
        

        if (flag_enter == true ) {
            
            var dir_dif = degree_temp - degree_enter
            if ( (dir_dif < 0 && abs(dir_dif) < 180 ) || (dir_dif > 0 && abs(dir_dif) > 180)  ) {
        
                if (dir_dif > 0 && abs(dir_dif) > 180)  { dir_dif = 360 - dir_dif }
                
                if (abs(dir_dif) <= 30) {
                    flag_dir = 0 ;
                    if (flag_dir != flag_pre) {
                        tts1("請繼續直行") ;
                        flag_pre = flag_dir
                        show.text = "請繼續直行"
                        print("請繼續直行")
                        let applicationData = ["counterValue" : "gostraight"]
                        NSLog("gostraight")
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
                }
                
                else {
                    flag_dir = 2 ;
                    if (flag_dir != flag_pre) {
                        tts1("請向右修正") ;
                        flag_pre = flag_dir
                        show.text = "請向右修正"
                        print("請向右修正")
                        let applicationData = ["counterValue" : "turnright"]
                        NSLog("turnright")
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
                        vibrate()
                    }

                }
            }

            else {
                
                if (dir_dif < 0 && abs(dir_dif) > 180)  { dir_dif = 360 - dir_dif }
                
                if (abs(dir_dif) <= 30) {
                    flag_dir = 0 ;
                    if (flag_dir != flag_pre) {
                        tts1("請繼續直行") ;
                        flag_pre = flag_dir
                        show.text = "請繼續直行"
                        print("請繼續直行")
                        let applicationData = ["counterValue" : "gostraight"]
                        NSLog("gostraight")
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
                }
                
                else {
                    
                    flag_dir = 1 ;
                    if (flag_dir != flag_pre) {
                        tts1("請向左修正") ;
                        flag_pre = flag_dir
                        show.text = "請向左修正"
                        print("請向左修正")
                        let applicationData = ["counterValue" : "turnleft"]
                        NSLog("turnleft")
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

                        vibrate()

                    }

                   }

            }
    
        }

    }
}

@available(iOS 9.0, *)
extension ViewController: WCSessionDelegate {
    
    @available(iOS 9.0, *)
    func session(session: WCSession, didReceiveMessage message: [String : AnyObject], replyHandler: ([String : AnyObject]) -> Void) {
        
        //Use this to update the UI instantaneously (otherwise, takes a little while)
        dispatch_async(dispatch_get_main_queue()) {
            if let counterValue = message["counterValue"] as? Int {
                if(counterValue==1){
                    self.btn_action()}
                else if(counterValue==0){
                    
                }
                
            }
        }
    }
}

// MARK: Table View Data Source




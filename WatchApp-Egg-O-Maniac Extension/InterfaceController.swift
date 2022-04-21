//
//  InterfaceController.swift
//  WatchApp-Egg-O-Maniac Extension
//
//  Created by Maxence Gama on 25/02/2021.
//

import WatchKit
import Foundation
import UserNotifications
import Foundation


class InterfaceController: WKInterfaceController {
    
    @IBOutlet var titleLabel: WKInterfaceLabel!
    var timerIsRunning = false
    
    override func awake(withContext context: Any?) {
    }
    
    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
    }
    
    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
    }
    
    @IBAction func softBtn() {
        print("clicked")
        WKInterfaceDevice.current().play(.click)
        let Tduration = 10
        UserDefaults.standard.setValue(Tduration, forKey: "timerduration")
        print("Tduration", (UserDefaults.standard.object(forKey: "timerduration") as! Double))
        pushController(withName: "pushToTimer", context: nil)
    }
    @IBAction func mediumBtn() {
        print("clicked")
        WKInterfaceDevice.current().play(.click)
        let Tduration = 420
        UserDefaults.standard.setValue(Tduration, forKey: "timerduration")
        print("Tduration", (UserDefaults.standard.object(forKey: "timerduration") as! Double))
        pushController(withName: "pushToTimer", context: nil)
    }
    @IBAction func hardBtn() {
        print("clicked")
        WKInterfaceDevice.current().play(.click)
        let Tduration = 720
        UserDefaults.standard.setValue(Tduration, forKey: "timerduration")
        print("Tduration", (UserDefaults.standard.object(forKey: "timerduration") as! Double))
        pushController(withName: "pushToTimer", context: nil)
    }
    
}


class TimerInterfaceController: WKInterfaceController {
    
    
    @IBOutlet var WKTimer: WKInterfaceTimer!
    @IBOutlet var PlayPauseButton: WKInterfaceButton!
    @IBOutlet var stopButton: WKInterfaceButton!
    
    var NotificationController: NotificationController!
    
    override func awake(withContext context: Any?) {
        
    }
    
    var myTimer: Timer?
    var isPaused = false
    var isStopped = false
    var isPlaying = false
    var elapsedTime : TimeInterval = 0.0
    var startTime = NSDate()
    var duration: TimeInterval = (UserDefaults.standard.object(forKey: "timerduration") as! Double)


    override func willActivate(){
        super.willActivate()
        if !isPlaying {
            DispatchQueue.main.asyncAfter(deadline: .now()) { [self] in
                myTimer = Timer.scheduledTimer(timeInterval: duration, target: self, selector: #selector(timerDone), userInfo: nil, repeats: false)
                WKTimer.setDate(NSDate(timeIntervalSinceNow: duration ) as Date)
                WKTimer.start()
                isPlaying = true
            }
        } else {
            UNUserNotificationCenter.removeAllPendingNotificationRequests(UNUserNotificationCenter.current())()
        }
    }

    @objc func timerDone(){
        print("timer done")
        WKInterfaceDevice.current().play(.notification)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.popToRootController()
        }
    }
    
    @IBAction func stopBtn() {
        if isStopped {
            WKInterfaceDevice.current().play(.directionDown)
            elapsedTime = 0.0
            myTimer = Timer.scheduledTimer(timeInterval: duration, target: self, selector: #selector(timerDone), userInfo: nil, repeats: false)
            WKTimer.setDate(NSDate(timeIntervalSinceNow: duration ) as Date)
            WKTimer.start()
            let attributedText = NSMutableAttributedString(string: "Arrêter".localized(), attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 15)])
            stopButton.setAttributedTitle(attributedText)
            isStopped = false
            isPaused = false
        } else {
            WKInterfaceDevice.current().play(.retry)
            isPaused = false
            isStopped = true
            WKTimer.setDate(NSDate(timeIntervalSinceNow: 0.0 ) as Date)
            WKTimer.stop()
            
            let attributedText = NSMutableAttributedString(string: "Recommencer".localized(), attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 15)])
            stopButton.setAttributedTitle(attributedText)
            PlayPauseButton.setTitle("Pause")
            WKTimer.setTextColor(.white)

            myTimer!.invalidate()
            isPlaying = false        }
    }
    @IBAction func playPauseBtn() {
        if !isStopped {
            if isPaused {
                WKInterfaceDevice.current().play(.click)
                isPaused = false
                isStopped = false
                myTimer = Timer.scheduledTimer(timeInterval: duration - elapsedTime, target: self, selector: #selector(timerDone), userInfo: nil, repeats: false)
                WKTimer.setDate(NSDate(timeIntervalSinceNow: duration - elapsedTime) as Date)
                WKTimer.start()
                startTime = NSDate()
                PlayPauseButton.setTitle("Pause")
                WKTimer.setTextColor(.white)
              }
            else {
                WKInterfaceDevice.current().play(.click)
                isPaused = true

                let paused = NSDate()
                elapsedTime += paused.timeIntervalSince(startTime as Date)

                WKTimer.stop()

                myTimer!.invalidate()

                PlayPauseButton.setTitle("Reprendre".localized())
                WKTimer.setTextColor(.gray)
            }
        }
    }
}

extension String {
    func localized() -> String {
        return NSLocalizedString(self,
                                 tableName: "Localizable",
                                 bundle: .main,
                                 value: self,
                                 comment: self)
    }
}

//
//  ViewController.swift
//  Egg-O-Maniac
//
//  Created by Maxence Gama on 07/10/2020.
//
//  password to disable ads: Utvu-G95O-K7hf
//  ads test-code : Uk4f-Rg1P-Hu7c

/*
                                      _____                         __  __
                                     / ____|                       |  \/  |
                                    | |  __  __ _ _ __ ___   __ _  | \  / | __ ___  _____ _ __   ___ ___
                                    | | |_ |/ _` | '_ ` _ \ / _` | | |\/| |/ _` \ \/ / _ \ '_ \ / __/ _ \
                                    | |__| | (_| | | | | | | (_| | | |  | | (_| |>  <  __/ | | | (_|  __/
                                     \_____|\__,_|_| |_| |_|\__,_| |_|  |_|\__,_/_/\_\___|_| |_|\___\___|

                             //------------------------------------------------------------------------------\\
                            //================================================================================\\
                           |||                                                                                |||
                           |||     ______                    ____         __  __             _                |||
                           |||    |  ____|                  / __ \       |  \/  |           (_)               |||
                           |||    | |__   __ _  __ _ ______| |  | |______| \  / | __ _ _ __  _  __ _  ___     |||
                           |||    |  __| / _` |/ _` |______| |  | |______| |\/| |/ _` | '_ \| |/ _` |/ __|    |||
                           |||    | |___| (_| | (_| |      | |__| |      | |  | | (_| | | | | | (_| | (__     |||
                           |||    |______\__, |\__, |       \____/       |_|  |_|\__,_|_| |_|_|\__,_|\___|    |||
                           |||            __/ | __/ |                                                         |||
                           |||           |___/ |___/                                                          |||
                           |||                                                                                |||
                           |||                                                                                |||
                            \\================================================================================//
                             \\--------------------------------©Gama--Maxence--------------------------------//

*/

import UIKit
import AVFoundation
import CoreData
import Firebase
import GoogleMobileAds
import NotificationBannerSwift
import SwiftEntryKit
import HealthKit
import Lottie
import IntentsUI

public class ViewController: UIViewController, GADBannerViewDelegate {
      
    // MARK: -Initialization
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        let IntroViewDidSeen = true
        print("IntroViewDidSeen: ", IntroViewDidSeen)
        UserDefaults.standard.setValue(IntroViewDidSeen, forKey: "IntroViewDidSeen")
        
        let introDidSeen = UserDefaults.standard.object(forKey: "IntroViewDidSeen") as? Bool
        print(introDidSeen!)
        if introDidSeen == nil || introDidSeen! == false {
            presentIntroVC()
        }
        
        lanceur = Lanceur(layer: self)
        lanceur.setup(frame: view.frame)
        view.layer.addSublayer(lanceur)
        setEggButtonsEnable(isEnabled: true)
        updateBackgroundColor()
        
        resetPlacements()
        removeSavedDate()
        
        view.addSubview(settingsButton)
        view.addSubview(infoButton)
        view.addSubview(titleLabel)
        view.addSubview(eggSatckView)
        eggSatckView.addArrangedSubview(softEggView)
        eggSatckView.addArrangedSubview(mediumEggView)
        eggSatckView.addArrangedSubview(hardEggView)
        softEggView.addSubview(softButton)
        mediumEggView.addSubview(mediumButton)
        hardEggView.addSubview(hardButton)
        softEggView.addSubview(softEggImageForBtn)
        mediumEggView.addSubview(mediumEggImageForBtn)
        hardEggView.addSubview(hardEggImageForBtn)
        view.addSubview(sizeButton)
        view.addSubview(tempButton)
        view.addSubview(bannerAd)
        view.addSubview(progressView)
        view.addSubview(stopButton)
        view.addSubview(animationContainer)
        
        animationView = .init(name: "egg_boiled")
        animationView!.translatesAutoresizingMaskIntoConstraints = false
        animationView!.contentMode = .scaleAspectFit
        animationView!.loopMode = .loop
        animationView!.animationSpeed = 1
        animationView!.frame = animationContainer.bounds
        
        animationContainer.addSubview(animationView!)
        
        setUpLayout()
        
        NotificationCenter.default.addObserver(self, selector: #selector(applicationDidEnterBackground(noti:)), name: UIApplication.didEnterBackgroundNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(applicationWillEnterForeground(noti:)), name: UIApplication.didBecomeActiveNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(applicationwillResignActive(noti:)), name: UIApplication.willResignActiveNotification, object: nil)
        NotificationCenter.default.addObserver(forName: UIApplication.userDidTakeScreenshotNotification, object: nil, queue: OperationQueue.main) { notification in
            print("Sreenshot taken")
        }
        NotificationCenter.default.addObserver(self, selector: #selector(disconnectPaxiSocket(_ :)), name: Notification.Name(rawValue: "deleteAddsNotif"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleWatchKitNotification(notification:)), name: NSNotification.Name(rawValue: "WatchKitSaysHello"), object: nil)
        
        //let resetADS = false
        //UserDefaults.standard.setValue(resetADS, forKey: "isAddDelted")
        
        if (UserDefaults.standard.object( forKey: "isAddDelted") as? Bool != nil) == true {
            print("Ads Disabled")
        } else {
            print("Ads Enabled")
            setUpAds()
        }
        
        sendNotificationsReminder()
    }
    /*
    func sendNotificationsReminder() {
        print("notification activated")
        var dateComponents = DateComponents()
        let date = Date() // now
        let cal = Calendar.current
        let day = cal.ordinality(of: .day, in: .year, for: date)
        dateComponents.hour = 9
        dateComponents.minute = 0
        dateComponents.day = day! + 3
        
        let content = UNMutableNotificationContent()
        content.sound = UNNotificationSound(named: UNNotificationSoundName(rawValue: "Cool-alarm-tone-notification-sound.mp3"))
        
        content.title = "Une envie d'oeuf ?".localized() //traduction a faire
        content.body = "Pourquoi ne pas vous faire de bons oeufs !!!".localized() //traduction a faire
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
        
        let request = UNNotificationRequest(identifier: "remindNotif", content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request) { (error: Error?) in
            if let error = error {
                print("Error: \(error.localizedDescription)")
            }
        }
    }*/
    
    func sendNotificationsReminder() {
        
        let content = UNMutableNotificationContent()
        content.title = "Une envie d'oeuf ?".localized() //traduction a faire
        content.body = "Pourquoi ne pas vous faire de bons oeufs !!!".localized() //traduction a faire
        content.sound = .default
        content.categoryIdentifier = "EOM-N-Cat"
        content.badge = 1
        
        let currentDate = Date()
        var dateComponent = DateComponents()
        dateComponent.day = 3
        let futureDate = Calendar.current.date(byAdding: dateComponent, to: currentDate)!
        
//        let targetDate = Date().addingTimeInterval(futureDate))// 3days => 4320
        let trigger = UNCalendarNotificationTrigger(dateMatching: Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: futureDate), repeats: false)
        
        let request = UNNotificationRequest(identifier: "reminderNotification", content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
        UNUserNotificationCenter.current().add(request) { (error: Error?) in
            if let error = error {
                print("Error: \(error.localizedDescription)")
            }
        }
        print("reminder updated\nNew reminder at \(futureDate)")
    }
    
    func setUpAds(){
        bannerAd.adUnitID = "ca-app-pub-3940256099942544/2934735716" //banner-(ca-app-pub-1041974861753876/6735271495)  \\//for-test-(ca-app-pub-3940256099942544/2934735716)
        bannerAd.rootViewController = self
        bannerAd.load(DFPRequest())
        bannerAd.delegate = self
    }
 
    @objc func handleWatchKitNotification(notification: NSNotification) {
        if (notification.object as? [String : String]) != nil {
            print("received")
            appDelegate?.scheduleNotification(timeInterval: 1)
        }
    }
    
    func presentIntroVC() {
        Timer.scheduledTimer(withTimeInterval: 0.1, repeats: false) { [self] (t) in
//            guard let ivc = storyboard?.instantiateViewController(identifier: "IntroViewHost_vc") as? IntroViewHost else {
//                return
//            }
            guard let ivc = storyboard?.instantiateViewController(identifier: "intro_vc") as? IntroUIViewHost else {
                return
            }
            self.present(ivc, animated: true)
            let IntroViewDidSeen = true
            print(IntroViewDidSeen)
            UserDefaults.standard.setValue(IntroViewDidSeen, forKey: "IntroViewDidSeen")
        }
    }
    
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewIsVisible = true
        print("viewIsVisible : \(viewIsVisible)")
        updateBackgroundColor()
        if self.isPlaying {
            UIView.animate(withDuration: 1.0, delay: 1, animations: {
                self.animationContainer.alpha = 1
                self.animationView!.play()
            })
        } else {
            self.animationContainer.alpha = 0
        }
        if !self.isPlaying {
            self.titleLabel.text = self.titleLabelDefaultContent
            self.titleLabel.textColor = self.setTitleColor
            self.titleLabel.alpha = 1
        }
        /*if UserDefaults.standard.object(forKey: "isPlaying") as? Bool != nil {
            if UserDefaults.standard.object(forKey: "isPlaying") as? Bool == false {
                DispatchQueue.main.async {
                    self.resetAfterTimer()
                }
            }
        }*/
        
        if UIApplication.shared.applicationIconBadgeNumber > 0 {
            UIApplication.shared.applicationIconBadgeNumber = -1
            UNUserNotificationCenter.current().removeDeliveredNotifications(withIdentifiers: ["reminderNotification"])
        }
        
    }
    
    /*public override var preferredStatusBarStyle: UIStatusBarStyle {
        let newRow = UserDefaults.standard.object(forKey: "row") as? Int
        
        if UserDefaults.standard.object(forKey: "row") as? Int != nil {
            if newRow! == 8 {
                print("dark status bar")
                return .darkContent
            } else {
                print("default status bar")
                return .default
            }
        } else {
            print("default status bar")
            return .default
        }
    }*/
    
    // MARK: -All variables
    
    let eggTimes = ["À la coque": 300, "Mollet": 420, "Dur": 720] //300, 420, 720
    var EggTimer = Timer()
    var ProgressBarTimer = Timer()
    var LauchTimer = Timer()
    var totalTime = 0
    var secondsPassed = 0
    var softMoved = false
    var mediumMoved = false
    var hardMoved = false
    var lanceur: Lanceur!
    var countFired: CGFloat = 0
    var setTitleColor: UIColor = .darkGray
    var sizeChoosen = false
    var size = ""
    var isPlaying = false
    var viewIsVisible = false
    var appIsActive = true
    var playLayerAlpha = 1.0
    
    public var firstColor: UIColor = UIColor.clear
    public var secondColor: UIColor = UIColor.clear
    
    var appDelegate = UIApplication.shared.delegate as? AppDelegate
    var myApp: UIApplication!
    
    static let healthStore: HKHealthStore = HKHealthStore()
    
    var audioPlayer: AVAudioPlayer?
    
    var animationView: AnimationView?
    
    static let blurEffect: UIBlurEffect = UIBlurEffect(style: .systemUltraThinMaterialLight)
    let blurView: UIVisualEffectView = UIVisualEffectView(effect: blurEffect)
    /*
    public override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        if self.traitCollection.userInterfaceStyle == .dark {
            ViewController.blurEffect = UIBlurEffect(style: .systemUltraThinMaterialDark)
        } else {
            ViewController.blurEffect = UIBlurEffect(style: .systemUltraThinMaterialLight)
        }
    }
    */
    
    // MARK: -Text Content Variables
    var titleLabelDefaultContent = "Quelle cuisson voulez-vous ?".localized()
    static var softButtonDefaultContent = "À la coque".localized()
    static var mediumButtonDefaultContent = "Mollet".localized()
    static var hardButtonDefaultContent = "Dur".localized()
    static var sizeButtonDefaultContent = "Choisir la taille".localized()
    static var stopButtonDefaultContent = "Arrêter".localized()
    static var tempButtonDefaultContent = "Température".localized()
    
    // MARK: -Background Lists
    /*
    let backgroundColorsList = [UIColor(hexString: "#84caef", alpha: 1),//default
                                UIColor(hexString: "#00ffd5", alpha: 1),//cyan
                                UIColor(hexString: "#a22709", alpha: 1),//rouge
                                UIColor(hexString: "#67B75E", alpha: 1),//vert
                                UIColor(hexString: "#F8BB00", alpha: 1),//jaune
                                UIColor(hexString: "#BE5FCE", alpha: 1),//violet
                                UIColor(hexString: "#fdbcb4", alpha: 1),//saumon
                                UIColor(hexString: "#979797", alpha: 1),//gris
                                UIColor(hexString: "#FFFFFA", alpha: 1)]//blanc
    
    let buttonsColorsList = [UIColor(hexString: "#456576", alpha: 1),//default
                             UIColor(hexString: "#007562", alpha: 1),//cyan
                             UIColor(hexString: "#440000", alpha: 1),//rouge
                             UIColor(hexString: "#0c4023", alpha: 1),//vert
                             UIColor(hexString: "#785710", alpha: 1),//jaune
                             UIColor(hexString: "#41184a", alpha: 1),//violet
                             UIColor(hexString: "#992f19", alpha: 1),//saumon
                             UIColor(hexString: "#303030", alpha: 1),//gris
                             UIColor(hexString: "#a29c9f", alpha: 1)]//blanc
    
    let backButtonsColorsList = [UIColor(hexString: "#6fc1ed", alpha: 1),//default
                                 UIColor(hexString: "#00dcb8", alpha: 1),//cyan
                                 UIColor(hexString: "#971e07", alpha: 1),//rouge
                                 UIColor(hexString: "#409E5E", alpha: 1),//vert
                                 UIColor(hexString: "#E6A518", alpha: 1),//jaune
                                 UIColor(hexString: "#B645CE", alpha: 1),//violet
                                 UIColor(hexString: "#fbaa99", alpha: 1),//saumon
                                 UIColor(hexString: "#838383", alpha: 1),//gris
                                 UIColor(hexString: "#E6E6E6", alpha: 1)]//blanc
    */
    
    func setAlphaView(isShown: CGFloat) {
        softEggView.alpha = isShown
        mediumEggView.alpha = isShown
        hardEggView.alpha = isShown
        sizeButton.alpha = isShown
        tempButton.alpha = isShown
    }
    
    func setEggButtonsEnable(isEnabled: Bool) {
        softButton.isEnabled = isEnabled
        mediumButton.isEnabled = isEnabled
        hardButton.isEnabled = isEnabled
        sizeButton.isEnabled = isEnabled
        tempButton.isEnabled = isEnabled
    }
    
    // MARK: -Test Hardness
    func testHardness(hardness: String) {
        if hardness == "À la coque"{
            softMoved = true
        } else if hardness == "Mollet"{
            mediumMoved = true
        } else if hardness == "Dur"{
            hardMoved = true
        }
        //print("s:", softMoved, "m:", mediumMoved, "h:", hardMoved)
        testTemp()
        
        if sizeChoosen {
            print("hardness:", hardness)
            checkSize(cuisson: hardness)
        } else {
            setUpTimerAndPlacement()
        }
    }
    
    func testTemp() {
        if UserDefaults.standard.object(forKey: "eggTemp") as? Float != nil {
            let absTemp =  UserDefaults.standard.object(forKey: "eggTemp") as? Float
            
            if absTemp! < 0 {
                totalTime += 60
            } else if absTemp! >= 0 && absTemp! < 10 {
                totalTime += 40
            } else if absTemp! >= 10 && absTemp! < 20 {
                totalTime += 20
            } else if absTemp! >= 20 && absTemp! < 25 {
                
            } else if absTemp! >= 25 && absTemp! < 30 {
                totalTime -= 5
            } else if absTemp! >= 30 && absTemp! < 40 {
                totalTime -= 10
            } else if absTemp! >= 40 && absTemp! < 50 {
                totalTime -= 20
            } else if absTemp! >= 45 {
                totalTime -= 30
            }
        }
    }
    
    // MARK: -Check Size
    func checkSize(cuisson: String) {
        print("size to check:", size)
        
        if cuisson == "À la coque" {
            if size == "small" {
                totalTime -= 10
            } else if size == "large" {
                totalTime += 10
            }
        } else if cuisson == "Mollet" {
            if size == "small" {
                totalTime -= 20
            } else if size == "large" {
                totalTime += 20
            }
        } else if cuisson == "Dur" {
            if size == "small" {
                totalTime -= 30
            } else if size == "large" {
                totalTime += 30
            }
        }

        print("total", totalTime)
        
        setUpTimerAndPlacement()
    }
    
    func eggSizeChoosed(overlayClosed: String) {
        print("overlayClosed:", overlayClosed)
        
        if overlayClosed == "small" {
            size = "small"
            
            let attributedText = NSMutableAttributedString(string: "Petit".localized(), attributes: [NSAttributedString.Key.font: UIFont(name: "Comfortaa-Bold", size: 18 ) as Any])
            
            sizeButton.setAttributedTitle(attributedText, for: .normal)
        } else if overlayClosed == "large" {
            size = "large"
            
            let attributedText = NSMutableAttributedString(string: "Gros".localized(), attributes: [NSAttributedString.Key.font: UIFont(name: "Comfortaa-Bold", size: 18 ) as Any])
            
            sizeButton.setAttributedTitle(attributedText, for: .normal)
        } else if overlayClosed == "medium" {
            size = "medium"
            
            let attributedText = NSMutableAttributedString(string: "Moyen".localized(), attributes: [NSAttributedString.Key.font: UIFont(name: "Comfortaa-Bold", size: 18 ) as Any])
            
            sizeButton.setAttributedTitle(attributedText, for: .normal)
        } else if overlayClosed == "dismiss" {
            self.titleLabel.text = titleLabelDefaultContent
            self.titleLabel.textColor = .darkGray
        }
        sizeChoosen = true
        print("size:", size)
    }
    
    // MARK: -Choose Video Player
    
    func choosVideoPlayerColor() {
        UIView.animate(withDuration: 1.0, delay: 1, animations: {
            self.animationContainer.alpha = 1
            self.animationView!.play()
        })
        /*
        let newRow = UserDefaults.standard.object(forKey: "row") as? Int
        
        if UserDefaults.standard.object(forKey: "row") as? Int != nil {
            if newRow! == 0 {
                player.playVideoWithFileName("Egg_Boil_blue")
//                playBGvideo(videoName: "Egg_Boil_blue")
            } else if newRow! == 1 {
                player.playVideoWithFileName("Egg_Boil_cyan")
            } else if newRow! == 2 {
                player.playVideoWithFileName("Egg_Boil_red")
            } else if newRow! == 3 {
                player.playVideoWithFileName("Egg_Boil_green")
            } else if newRow! == 4 {
                player.playVideoWithFileName("Egg_Boil_yellow")
            } else if newRow! == 5 {
                player.playVideoWithFileName("Egg_Boil_purple")
            } else if newRow! == 6 {
                player.playVideoWithFileName("Egg_Boil_salmon")
            } else if newRow! == 7 {
                player.playVideoWithFileName("EggBoil_gray")
            } else if newRow! == 8 {
                player.playVideoWithFileName("EggBoil_white")
            }
        } else {
            player.playVideoWithFileName("Egg_Boil_blue")
//            playBGvideo(videoName: "Egg_Boil_blue")
        }*/
    }
    
    /*
    func playBGvideo(videoName: String) {
        let path = Bundle.main.path(forResource: videoName, ofType: ".mp4")
        player = AVPlayer(url: URL(fileURLWithPath: path!))
        player!.actionAtItemEnd = AVPlayer.ActionAtItemEnd.none
        let playerLayer = AVPlayerLayer(player: player)
        playerLayer.frame = CGRect(origin: CGPoint(x: (view.frame.width-300)/2, y: view.frame.width/8.1),
                                   size: CGSize(width: 300, height: 300))
        
        playerLayer.videoGravity = AVLayerVideoGravity.resizeAspectFill
        self.view.layer.insertSublayer(playerLayer, at: 0)
        NotificationCenter.default.addObserver(self, selector: #selector(playerEnded), name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: player!.currentItem)
        player!.seek(to: CMTime.zero)
        player!.play()
        self.player?.isMuted = true
    }
    @objc func playerEnded() {
        player!.seek(to: CMTime.zero)
    }*/

    // MARK: -Setup Placement and Timers
    
    private func setUpTimerAndPlacement() {
        
        titleLabel.alpha = 0
        
        choosVideoPlayerColor()
        
        setEggButtonsEnable(isEnabled: false)
        setAlphaView(isShown: 0)
        countFired = 0
        setTimers(countFired: CGFloat(countFired))
        
        UIView.animate(withDuration: 0, animations: {
            self.progressView.frame.origin.y += 70
            self.stopButton.frame.origin.y -=  80
        })
        
        UIView.animate(withDuration: 0.4, delay: 0.3, options: .curveEaseInOut, animations: {
            self.progressView.frame.origin.y -= 70
            self.progressView.alpha = 1
            }, completion: nil)
        
        self.stopButton.isEnabled = true
        UIView.animate(withDuration: 0.2, delay: 1,  usingSpringWithDamping: 0.6, initialSpringVelocity: 1, options: .curveEaseInOut, animations: {
            self.stopButton.frame.origin.y +=  80
            self.stopButton.alpha = 1
        }, completion: nil)
        
        let generator = UIImpactFeedbackGenerator(style: .heavy)
        generator.prepare()
        generator.impactOccurred()
        
        setEggButtonsEnable(isEnabled: false)
        
        let timersEnded = false
        print("timersEnded:", timersEnded)
        UserDefaults.standard.set(timersEnded, forKey: "timersEnded")
    }
    
    
    func setTimers(countFired: CGFloat) {
        if !isPlaying {
            self.progressView.progress = 0
            self.progressView.timerText = String(self.totalTime)
            LauchTimer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { [self] t in
                self.progressView.progress += 0.1
    //            count -= totalTime/20
                if self.progressView.progress >= 1 {
                    self.LauchTimer.invalidate()
                    
                    let generator = UINotificationFeedbackGenerator()
                    generator.notificationOccurred(.warning)
                    
                    PB_EGG_Timer(countFired: countFired)
                }
            }
        } else {
            let generator = UIImpactFeedbackGenerator(style: .medium)
            generator.prepare()
            generator.impactOccurred()
            
            PB_EGG_Timer(countFired: countFired)
        }
        self.isPlaying = true
        UserDefaults.standard.set(self.isPlaying, forKey: "isPlaying")
    }
    
    func PB_EGG_Timer(countFired: CGFloat) {
        
        print("countFired : \(countFired)")
        self.ProgressBarTimer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { (timer) in
            self.countFired += 0.1
        
            self.progressView.progress = max((CGFloat(self.totalTime) - self.countFired) / (CGFloat(self.totalTime)), 0)
            self.progressView.timerText = String(self.totalTime - self.secondsPassed)
        
            if self.progressView.progress == 0 {
                self.ProgressBarTimer.invalidate()
            }
        }
        self.EggTimer = Timer.scheduledTimer(timeInterval: 1.0, target:self, selector: #selector(self.updateTimer), userInfo: nil, repeats: true)
    }
    
    // MARK: -Backgound Fetch-----------------------------------------------------------------------------------------------------------------------------
    
    var diffHrs = 0
    var diffMins = 0
    var diffSecs = 0
    
    @objc func disconnectPaxiSocket(_ noti: Notification) {
        bannerAd.removeFromSuperview()
    }
    
    @objc func applicationwillResignActive(noti: Notification) {
        print("became out of screen")
        if isPlaying {
            blurView.frame = self.view.bounds
            blurView.alpha = 1
            self.view.addSubview(blurView)
        }
    }
    
    @objc func applicationDidEnterBackground(noti: Notification) {
        print("applicationDidEnterBackground")
        appIsActive = false
        if UserDefaults.standard.object(forKey: "isPlaying") as? Bool != nil {
            if UserDefaults.standard.object(forKey: "isPlaying") as? Bool == true {
                self.ProgressBarTimer.invalidate()
                self.EggTimer.invalidate()
                let savedTime = Date()
                print("savedTime : \(savedTime)")
                UserDefaults.standard.setValue(savedTime, forKey: "savedTime")
                
                if (totalTime-secondsPassed) != 0 {
                    appDelegate?.scheduleNotification(timeInterval: (totalTime-secondsPassed))
                    print("notification in \(totalTime-secondsPassed)s")
                }
                
                animationView!.stop()
            }
        }
    }
    
    @objc func applicationWillEnterForeground(noti: Notification) {
        print("applicationWillEnterForeground")
        appIsActive = true
        if isPlaying {
            UIView.animate(withDuration: 0.2, animations: { [self] in
                blurView.alpha = 0
            }) { (succes: Bool) in
                if succes {
                    self.blurView.removeFromSuperview()
                }
            }
        }
        if UIApplication.shared.applicationIconBadgeNumber > 0 {
            UIApplication.shared.applicationIconBadgeNumber = 0
        }
        if let savedDate = UserDefaults.standard.object(forKey: "savedTime") as? Date {
            print("savedDate : \(savedDate) seconds")
            (diffHrs, diffMins, diffSecs) = ViewController.getTimeDifference(startDate: savedDate)
            
            self.refresh(hours: diffHrs, mins: diffMins, secs: diffSecs)
        }
    }
    
    static func getTimeDifference(startDate: Date) -> (Int, Int, Int) {
       let calendar = Calendar.current
       let components = calendar.dateComponents([.hour, .minute, .second], from: startDate, to: Date())
       print(components.hour!, components.minute!, components.second!)
       return(components.hour!, components.minute!, components.second!)
    }
    
    func refresh (hours: Int, mins: Int, secs: Int) {
        print("old secondsPassed: \(secondsPassed)")
        secondsPassed += hours*3600 + mins*60 + secs
        print("new secondsPassed:", secondsPassed)
        
        if secondsPassed > totalTime {
            print("timer ended")
            self.resetAfterTimer()
            self.writeHealthData()
            self.animationContainer.alpha = 0
            UNUserNotificationCenter.removeAllPendingNotificationRequests(UNUserNotificationCenter.current())()
        } else if secondsPassed < totalTime {
            countFired = CGFloat(secondsPassed)
            setTimers(countFired: CGFloat(secondsPassed))
            UNUserNotificationCenter.removeAllPendingNotificationRequests(UNUserNotificationCenter.current())()
            
            UIView.animate(withDuration: 1.0, delay: 1, animations: {
                self.animationContainer.alpha = 1
                self.animationView!.play()
            })
        }
    }
    
    func removeSavedDate() {
        if (UserDefaults.standard.object(forKey: "savedTime") as? Date) != nil {
            UserDefaults.standard.removeObject(forKey: "savedTime")
        }
    }
    
    public override func viewDidDisappear(_ animated: Bool) {
        viewIsVisible = false
        print("viewIsVisible : \(viewIsVisible)")
    }
    
    // MARK: -Update Timer
    
    @objc func updateTimer() {
        if secondsPassed < totalTime {
            secondsPassed += 1
            print("SecPassed : \(secondsPassed)")
        } else if viewIsVisible == true {
            print("view is visible")
            
            var numberOfRep = 0
            Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { timer in
                numberOfRep += 1
                
                let generator = UIImpactFeedbackGenerator(style: .heavy)
                generator.prepare()
                generator.impactOccurred()

                if numberOfRep == 20 {
                    timer.invalidate()
                }
            }
            
            resetPlacements()
            writeHealthData()
            
            let Nbanner = GrowingNotificationBanner(title: "Données Santé ajoutées avec succès".localized(),
                                                    subtitle: "Vous pouvez directement les consulter dans l'application Santé.".localized(),
                                                    leftView: nil,
                                                    rightView: nil,
                                                    style: .info,
                                                    colors: nil)
            
            Nbanner.autoDismiss = false
            Nbanner.dismissOnSwipeUp = true
            Nbanner.dismissOnTap = true
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: { [self] in
                Nbanner.show()
//                playSound()
                DispatchQueue.main.asyncAfter(deadline: .now() + 5, execute: {
                    Nbanner.dismiss()
                })
            })
            
            EggTimer.invalidate()
            titleLabel.text = "C'est cuit !".localized()
            titleLabel.textColor = .red
            
            softButton.isEnabled = false
            mediumButton.isEnabled = false
            hardButton.isEnabled  = false
            lanceur.lancerConfettis()
            
            Timer.scheduledTimer(withTimeInterval: 5, repeats: false) { (t) in
                UIView.animate(withDuration: 0.3, animations: {
                    self.titleLabel.alpha = 0
                    self.lanceur.emitterCells?.removeAll()
                }) { (succes: Bool) in
                    if succes {
                        if !self.isPlaying {
                            UIView.animate(withDuration: 0.5, animations: { [self] in
                                self.titleLabel.text = self.titleLabelDefaultContent
                                self.titleLabel.textColor = self.setTitleColor
                                self.titleLabel.alpha = 1
                                self.softButton.isEnabled = true
                                self.mediumButton.isEnabled = true
                                self.hardButton.isEnabled  = true
                            })
                        }
                    }
                }
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1, execute: { [self] in
                playSound()
            })
            
        } else if viewIsVisible == false {
            print("view is not visible")
            EggTimer.invalidate()
            ProgressBarTimer.invalidate()
            resetAfterTimer()
            
            handleShowPopUp()
            
            writeHealthData()
            
            /*
            let Nbanner = GrowingNotificationBanner(title: "C'est cuit !",
                                             subtitle: "Ça y est vos oeufs sont prêts. Votre minuteur est terminé.",
                                             leftView: nil,
                                             rightView: nil,
                                             style: .info,
                                             colors: nil)
            Nbanner.autoDismiss = false
            Nbanner.dismissOnSwipeUp = true
            Nbanner.dismissOnTap = true
            
            Nbanner.show()*/
            
            var numberOfRep = 0
            Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { timer in
                numberOfRep += 1
                
                let generator = UIImpactFeedbackGenerator(style: .heavy)
                generator.prepare()
                generator.impactOccurred()

                if numberOfRep == 20 {
                    timer.invalidate()
                }
            }
            
//            DispatchQueue.main.asyncAfter(deadline: .now() + 5, execute: {
//                //Nbanner.dismiss()
//            })
            
        }
    }

    func playSound() {
        
        guard let soundPath = Bundle.main.path(forResource: "Cool-alarm-tone-notification-sound", ofType: ".mp3") else { return }
        let url = URL(fileURLWithPath: soundPath)
        
        do {
//            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
            try AVAudioSession.sharedInstance().setCategory(AVAudioSession.Category.playback, mode: .measurement, options: AVAudioSession.CategoryOptions.mixWithOthers)
            try AVAudioSession.sharedInstance().setActive(true)
            
            audioPlayer = try AVAudioPlayer(contentsOf: url)

            guard let adplayer = audioPlayer else { return }

            adplayer.play()

        } catch let error {
            print(error.localizedDescription)
        }
    }
    
    func writeHealthData() {
        
        let nutriments = [12, 0.3, 2.6, 3.6, 1.6, 9.8]
        let dietaries = [HKQuantityTypeIdentifier.dietaryProtein, HKQuantityTypeIdentifier.dietarySugar, HKQuantityTypeIdentifier.dietaryFatSaturated, HKQuantityTypeIdentifier.dietaryFatMonounsaturated, HKQuantityTypeIdentifier.dietaryFatPolyunsaturated, HKQuantityTypeIdentifier.dietaryFatTotal]
        let today = NSDate()
        
        
        for i in 0...nutriments.count-1 {
            if let type = HKSampleType.quantityType(forIdentifier: dietaries[i]) {
                
                let quantity = HKQuantity(unit: HKUnit.gram(), doubleValue: Double(nutriments[i]))
                
                let sample = HKQuantitySample(type: type, quantity: quantity, start: today as Date, end: today as Date)
                
                HealthData.saveHealthData([sample]) { (success, error) in
                    if let error = error {
                        print("didAddNewData error:", error.localizedDescription)
                    }
                    if success {
                        print("Successfully saved a new sample!", sample)
                    } else {
                        print("Error: Could not save new sample.", sample)
                    }
                }
            }
        }
        
    }
    
    class func saveHealthData(_ data: [HKObject], completion: @escaping (_ success: Bool, _ error: Error?) -> Void) {
        healthStore.save(data, withCompletion: completion)
    }
    
    // MARK: -Reset Placement
    
    private func resetPlacements() {
        removeSavedDate()
        stopButton.isEnabled = false
        
        let attributedText = NSMutableAttributedString(string: ViewController.sizeButtonDefaultContent, attributes: [NSAttributedString.Key.font: UIFont(name: "Comfortaa-Bold", size: 18 ) as Any])
        
        sizeButton.setAttributedTitle(attributedText, for: .normal)

        titleLabel.alpha = 1
        
        isPlaying = false
        UserDefaults.standard.set(isPlaying, forKey: "isPlaying")
        UserDefaults.standard.setValue(20.0, forKey: "eggTemp")
        
        print("is playing", isPlaying)
        
        setEggButtonsEnable(isEnabled: true)
        
        size = ""
        
        progressView.alpha = 0;
        stopButton.alpha = 0
        setAlphaView(isShown: 1.0)
        animationContainer.alpha = 0
    }
    
    public func resetAfterTimer() {
        removeSavedDate()
        
        let attributedText = NSMutableAttributedString(string: ViewController.sizeButtonDefaultContent, attributes: [NSAttributedString.Key.font: UIFont(name: "Comfortaa-Bold", size: 18 ) as Any])
        
        UserDefaults.standard.setValue(20.0, forKey: "eggTemp")
        
        sizeButton.setAttributedTitle(attributedText, for: .normal)
        titleLabel.text = titleLabelDefaultContent
        titleLabel.textColor = self.setTitleColor
        
        titleLabel.alpha = 1
        animationView!.stop()
        isPlaying = false
        UserDefaults.standard.set(isPlaying, forKey: "isPlaying")
        size = ""
        setEggButtonsEnable(isEnabled: true)
        progressView.alpha = 0
        setAlphaView(isShown: 1.0)
        stopButton.alpha = 0
        stopButton.isEnabled = false
        
        let Nbanner = GrowingNotificationBanner(title: "Données Santé ajoutées avec succès".localized(),
                                                subtitle: "Vous pouvez directement les consulter dans l'application Santé.".localized(),
                                                leftView: nil,
                                                rightView: nil,
                                                style: .info,
                                                colors: nil)
        
        Nbanner.autoDismiss = false
        Nbanner.dismissOnSwipeUp = true
        Nbanner.dismissOnTap = true
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: {
            Nbanner.show()
            DispatchQueue.main.asyncAfter(deadline: .now() + 5, execute: {
                Nbanner.dismiss()
            })
        })
    }
    
    
    // MARK: -Show Miracle To Choose Size
    
    @objc func showMiracle() {
        let slideVC = OverlayFirtView()
        slideVC.modalPresentationStyle = .custom
        slideVC.transitioningDelegate = self
        slideVC.delegate = self
        self.present(slideVC, animated: true, completion: nil)
    }
    
    @objc func showTMiracle() {
        let slideVC = OverlayTempView()
        slideVC.modalPresentationStyle = .custom
        slideVC.transitioningDelegate = self
        self.present(slideVC, animated: true, completion: nil)
    }
    
    // MARK: -Update Background Color
    public func updateBackgroundColor() {
        //let reset = 0
        //UserDefaults.standard.setValue(reset, forKey: "row")
        
        let newRow = UserDefaults.standard.object(forKey: "row") as? Int
        
        if UserDefaults.standard.object(forKey: "row") as? Int != nil {
            view.backgroundColor = ColorList.backgroundColorsList[newRow!]
            
            setTitleColor = .black
            titleLabel.textColor = setTitleColor
            
            softButton.setTitleColor(ColorList.buttonsColorsList[newRow!], for: .normal)
            mediumButton.setTitleColor(ColorList.buttonsColorsList[newRow!], for: .normal)
            hardButton.setTitleColor(ColorList.buttonsColorsList[newRow!], for: .normal)
            
            if newRow! == 0 {
                sizeButton.backgroundColor = ColorList.backButtonsColorsList[0]
                sizeButton.setTitleColor(ColorList.buttonsColorsList[0], for: .normal)
                tempButton.backgroundColor = ColorList.backButtonsColorsList[0]
                tempButton.setTitleColor(ColorList.buttonsColorsList[0], for: .normal)
            } else {
                sizeButton.backgroundColor = ColorList.backButtonsColorsList[newRow!]
                sizeButton.setTitleColor(ColorList.buttonsColorsList[newRow!], for: .normal)
                tempButton.backgroundColor = ColorList.backButtonsColorsList[newRow!]
                tempButton.setTitleColor(ColorList.buttonsColorsList[newRow!], for: .normal)
            }
            
        } else {
            view.backgroundColor = ColorList.backgroundColorsList[0]
            sizeButton.backgroundColor = ColorList.backButtonsColorsList[0]
            sizeButton.setTitleColor(ColorList.buttonsColorsList[0], for: .normal)
            tempButton.backgroundColor = ColorList.backButtonsColorsList[0]
            tempButton.setTitleColor(ColorList.buttonsColorsList[0], for: .normal)
            setTitleColor = .black
            titleLabel.textColor = setTitleColor
            
            softButton.setTitleColor(ColorList.buttonsColorsList[0], for: .normal)
            mediumButton.setTitleColor(ColorList.buttonsColorsList[0], for: .normal)
            hardButton.setTitleColor(ColorList.buttonsColorsList[0], for: .normal)
        }
    }
    
    // MARK: -Popup intialization
    
    func setupAttributes() -> EKAttributes {
        var attributes = EKAttributes.centerFloat
        attributes.displayDuration = .infinity
        attributes.screenBackground = .color(color: .init(light: UIColor(white: 100.0/255.0, alpha: 0.3), dark: UIColor(white: 50.0/255.0, alpha: 0.3)))
        attributes.shadow = .active(
            with: .init(
                color: .black,
                opacity: 0.3,
                radius: 8
            )
        )
        
        attributes.entryBackground = .color(color: EKColor(red: 121, green: 213, blue: 100))
        attributes.roundCorners = .all(radius: 25)
        
        attributes.screenInteraction = .dismiss
        attributes.entryInteraction = .absorbTouches
        attributes.scroll = .enabled(
            swipeable: true,
            pullbackAnimation: .jolt
        )
        
        attributes.entranceAnimation = .init(
            translate: .init(
                duration: 0.7,
                spring: .init(damping: 1, initialVelocity: 0)
            ),
            scale: .init(
                from: 1.05,
                to: 1,
                duration: 0.4,
                spring: .init(damping: 1, initialVelocity: 0)
            )
        )
        
        attributes.exitAnimation = .init(
            translate: .init(duration: 0.2)
        )
        attributes.popBehavior = .animated(
            animation: .init(
                translate: .init(duration: 0.2)
            )
        )
        
        attributes.positionConstraints.verticalOffset = 10
        attributes.statusBar = .dark
        return attributes
    }
    
    func setupMessage() -> EKPopUpMessage {
        
        let image = UIImage(named: "ic_done")!.withRenderingMode(.alwaysTemplate)
        let title = "C'est cuit !".localized()
        let description =
        """
        Ça y est vos oeufs sont prêts.
        Votre minuteur est terminé.
        """.localized()
        
        let themeImage = EKPopUpMessage.ThemeImage(image: EKProperty.ImageContent(image: image, size: CGSize(width: 60, height: 60), tint: .white, contentMode: .scaleAspectFit))
        
        let titleLabel = EKProperty.LabelContent(text: title, style: .init(font: UIFont.systemFont(ofSize: 24),
                                                                      color: .white,
                                                                      alignment: .center))
        
        let descriptionLabel = EKProperty.LabelContent(
            text: description,
            style: .init(
                font: UIFont.systemFont(ofSize: 16),
                color: .white,
                alignment: .center
            )
        )
        
        let button = EKProperty.ButtonContent(
            label: .init(
                text: "Fermer".localized(),
                style: .init(
                    font: UIFont.systemFont(ofSize: 16),
                    color: .black
                )
            ),
            backgroundColor: .init(UIColor(hexString: "#BBF2FF", alpha: 1)),
            highlightedBackgroundColor: .clear
        )
        
        let message = EKPopUpMessage(themeImage: themeImage, title: titleLabel, description: descriptionLabel, button: button) {
            SwiftEntryKit.dismiss()
        }
        return message
    }
    
    @objc func handleShowPopUp() {
        SwiftEntryKit.display(entry: MyPopUpView(with: setupMessage()), using: setupAttributes())
    }
    
    
    
    
    // MARK: -Layout Setup----------------------------------------------------------------------------------------------------------------------------
    

    let settingsButton: UIButton = {
        let settingsBtn = UIButton(type: UIButton.ButtonType.custom) as UIButton
        let bgImage = UIImage(systemName: "gearshape") as UIImage?
        settingsBtn.setBackgroundImage(bgImage, for: .normal)
        settingsBtn.tintColor = .black
        settingsBtn.contentMode = .scaleAspectFit
        settingsBtn.addTarget(self, action: #selector(settingsBtnTouched), for: .touchUpInside)
        settingsBtn.translatesAutoresizingMaskIntoConstraints = false
        return settingsBtn
    }()
    
    let infoButton: UIButton = {
        let infoBtn = UIButton(type: UIButton.ButtonType.custom) as UIButton
        let bgImage = UIImage(systemName: "text.book.closed") as UIImage?
        infoBtn.setBackgroundImage(bgImage, for: .normal)
        infoBtn.tintColor = .black
        infoBtn.contentMode = .scaleAspectFit
        infoBtn.addTarget(self, action: #selector(infoBtnTouched), for: .touchUpInside)
        infoBtn.translatesAutoresizingMaskIntoConstraints = false
        return infoBtn
    }()
    
    let titleLabel: UILabel = {
        let titleLabel =  UILabel()
        
        titleLabel.font = UIFont(name: "Comfortaa", size: 25)
        titleLabel.text = "Quelle cuisson voulez vous ?"
        titleLabel.textColor = .black
        titleLabel.dropShadow()
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        return titleLabel
    }()
    
    let eggSatckView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .fill
        stackView.distribution = .fillEqually
        stackView.contentMode = .scaleAspectFit
        stackView.spacing = 10
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    let softButton: UIButton = {
        let button = UIButton(type: UIButton.ButtonType.custom) as UIButton
        
        let attributedText = NSMutableAttributedString(string: softButtonDefaultContent, attributes: [NSAttributedString.Key.font: UIFont(name: "Comfortaa", size: 20) as Any])
        
        button.contentVerticalAlignment = .top
        button.setTitleColor(.systemBlue, for: .normal)
        button.setAttributedTitle(attributedText, for: .normal)
        button.addTarget(self, action: #selector(softEggTouched), for: .touchUpInside)
        button.contentMode = .scaleToFill
        button.translatesAutoresizingMaskIntoConstraints = false
        button.titleLabel?.numberOfLines = 2
        button.titleLabel?.textAlignment = .center
        button.dropShadow(.black, opacity: 0.5, width: 0, height: 5, radius: 3)
        return button
    }()
    let mediumButton: UIButton = {
        let button = UIButton(type: UIButton.ButtonType.custom) as UIButton
        
        let attributedText = NSMutableAttributedString(string: mediumButtonDefaultContent, attributes: [NSAttributedString.Key.font: UIFont(name: "Comfortaa", size: 20) as Any])
        
        button.contentVerticalAlignment = .top
        button.setTitleColor(.systemBlue, for: .normal)
        button.setAttributedTitle(attributedText, for: .normal)
        button.addTarget(self, action: #selector(meduimEggTouched), for: .touchUpInside)
        button.contentMode = .scaleToFill
        button.translatesAutoresizingMaskIntoConstraints = false
        button.titleLabel?.numberOfLines = 2
        button.titleLabel?.textAlignment = .center
        button.dropShadow(.black, opacity: 0.5, width: 0, height: 5, radius: 3)
        return button
    }()
    let hardButton: UIButton = {
        let button = UIButton(type: UIButton.ButtonType.custom) as UIButton
        
        let attributedText = NSMutableAttributedString(string: hardButtonDefaultContent, attributes: [NSAttributedString.Key.font: UIFont(name: "Comfortaa", size: 20) as Any])
        
        button.contentVerticalAlignment = .top
        button.setTitleColor(.systemBlue, for: .normal)
        button.setAttributedTitle(attributedText, for: .normal)
        button.addTarget(self, action: #selector(hardEggTouched), for: .touchUpInside)
        button.contentMode = .scaleToFill
        button.translatesAutoresizingMaskIntoConstraints = false
        button.titleLabel?.numberOfLines = 2
        button.titleLabel?.textAlignment = .center
        button.dropShadow(.black, opacity: 0.5, width: 0, height: 5, radius: 3)
        return button
    }()
    
    let softEggImageForBtn: UIImageView = {
        let softEggImageForBtn = UIImageView(image: #imageLiteral(resourceName: "soft_egg"))
        softEggImageForBtn.contentMode = .scaleAspectFit
        softEggImageForBtn.translatesAutoresizingMaskIntoConstraints = false
        softEggImageForBtn.dropShadow()
        return softEggImageForBtn
    }()
    let mediumEggImageForBtn: UIImageView = {
        let mediumEggImageForBtn = UIImageView(image: #imageLiteral(resourceName: "medium_egg"))
        mediumEggImageForBtn.contentMode = .scaleAspectFit
        mediumEggImageForBtn.translatesAutoresizingMaskIntoConstraints = false
        mediumEggImageForBtn.dropShadow()
        return mediumEggImageForBtn
    }()
    let hardEggImageForBtn: UIImageView = {
        let hardEggImageForBtn = UIImageView(image: #imageLiteral(resourceName: "hard_egg"))
        hardEggImageForBtn.contentMode = .scaleAspectFit
        hardEggImageForBtn.translatesAutoresizingMaskIntoConstraints = false
        hardEggImageForBtn.dropShadow()
        return hardEggImageForBtn
    }()
    
    let softEggView: UIView = {
        let softEggView = UIView()
        return softEggView
    }()
    let mediumEggView: UIView = {
        let mediumEggView = UIView()
        return mediumEggView
    }()
    let hardEggView: UIView = {
        let hardEggView = UIView()
        return hardEggView
    }()
    
    let sizeButton: UIButton = {
        let sizeBtn = UIButton(type: UIButton.ButtonType.custom) as UIButton
        
        let attributedText = NSMutableAttributedString(string: sizeButtonDefaultContent, attributes: [NSAttributedString.Key.font: UIFont(name: "Comfortaa-Bold", size: 18 ) as Any])
        
        sizeBtn.setAttributedTitle(attributedText, for: .normal)
        sizeBtn.setTitleColor(.systemBlue, for: .normal)
        sizeBtn.addTarget(self, action: #selector(sizeButtonTouched), for: .touchUpInside)
        sizeBtn.backgroundColor = .lightGray
        sizeBtn.layer.cornerRadius = 20.0
        sizeBtn.dropShadow(.black, opacity: 0.3, width: 0, height: 2, radius: 2)
        sizeBtn.translatesAutoresizingMaskIntoConstraints = false
        return sizeBtn
    }()
    
    let tempButton: UIButton = {
        let button = UIButton(type: UIButton.ButtonType.custom) as UIButton
        
        let attributedText = NSMutableAttributedString(string: tempButtonDefaultContent, attributes: [NSAttributedString.Key.font: UIFont(name: "Comfortaa-Bold", size: 18 ) as Any])
        
        button.setAttributedTitle(attributedText, for: .normal)
        button.setTitleColor(.systemBlue, for: .normal)
        button.addTarget(self, action: #selector(tempButtonTouched), for: .touchUpInside)
        button.backgroundColor = .lightGray
        button.layer.cornerRadius = 20.0
        button.dropShadow(.black, opacity: 0.3, width: 0, height: 2, radius: 2)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let bannerAd: GADBannerView = {
       let banner = GADBannerView()
        banner.translatesAutoresizingMaskIntoConstraints = false
        return banner
    }()
    
    let progressView: ProgressBar = {
        let view = ProgressBar()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    /*let player: VideoPlayer = {
        let player = VideoPlayer()
        player.translatesAutoresizingMaskIntoConstraints = false
        return player
    }()*/
    
    let animationContainer: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let stopButton: UIButton = {
        let stopBtn = UIButton(type: UIButton.ButtonType.custom) as UIButton
        
        let attributedText = NSMutableAttributedString(string: stopButtonDefaultContent, attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 20)])
        
        stopBtn.setTitleColor(.systemBlue, for: .normal)
        stopBtn.setAttributedTitle(attributedText, for: .normal)
        stopBtn.addTarget(self, action: #selector(stopButtonTouched), for: .touchUpInside)
        stopBtn.translatesAutoresizingMaskIntoConstraints = false
        return stopBtn
    }()
    
    private func setUpLayout() {
        settingsButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
        settingsButton.widthAnchor.constraint(equalToConstant: 32).isActive = true
        settingsButton.topAnchor.constraint(equalTo: view.topAnchor, constant: view.frame.height/13.7).isActive = true
        settingsButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
        
        infoButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
        infoButton.widthAnchor.constraint(equalToConstant: 30).isActive = true
        infoButton.topAnchor.constraint(equalTo: view.topAnchor, constant: view.frame.height/13.7).isActive = true
        infoButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20).isActive = true
        
        titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        titleLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: view.frame.height/5.6).isActive = true
        
        eggSatckView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        eggSatckView.topAnchor.constraint(equalTo: view.topAnchor, constant: view.frame.height/3 + 20).isActive = true
        eggSatckView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
        eggSatckView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20).isActive = true
        eggSatckView.heightAnchor.constraint(equalToConstant: 270).isActive = true
        
        softButton.topAnchor.constraint(equalTo: softEggView.topAnchor).isActive = true
        softButton.leadingAnchor.constraint(equalTo: softEggView.leadingAnchor).isActive = true
        softButton.trailingAnchor.constraint(equalTo: softEggView.trailingAnchor).isActive = true
        softButton.bottomAnchor.constraint(equalTo: softEggView.bottomAnchor).isActive = true
        
        mediumButton.topAnchor.constraint(equalTo: mediumEggView.topAnchor).isActive = true
        mediumButton.leadingAnchor.constraint(equalTo: mediumEggView.leadingAnchor).isActive = true
        mediumButton.trailingAnchor.constraint(equalTo: mediumEggView.trailingAnchor).isActive = true
        mediumButton.bottomAnchor.constraint(equalTo: mediumEggView.bottomAnchor).isActive = true
        
        hardButton.topAnchor.constraint(equalTo: hardEggView.topAnchor).isActive = true
        hardButton.leadingAnchor.constraint(equalTo: hardEggView.leadingAnchor).isActive = true
        hardButton.trailingAnchor.constraint(equalTo: hardEggView.trailingAnchor).isActive = true
        hardButton.bottomAnchor.constraint(equalTo: hardEggView.bottomAnchor).isActive = true
        
        softEggImageForBtn.topAnchor.constraint(equalTo: softEggView.topAnchor).isActive = true
        softEggImageForBtn.leadingAnchor.constraint(equalTo: softEggView.leadingAnchor).isActive = true
        softEggImageForBtn.trailingAnchor.constraint(equalTo: softEggView.trailingAnchor).isActive = true
        softEggImageForBtn.bottomAnchor.constraint(equalTo: softEggView.bottomAnchor).isActive = true
        
        mediumEggImageForBtn.topAnchor.constraint(equalTo: mediumEggView.topAnchor).isActive = true
        mediumEggImageForBtn.leadingAnchor.constraint(equalTo: mediumEggView.leadingAnchor).isActive = true
        mediumEggImageForBtn.trailingAnchor.constraint(equalTo: mediumEggView.trailingAnchor).isActive = true
        mediumEggImageForBtn.bottomAnchor.constraint(equalTo: mediumEggView.bottomAnchor).isActive = true
        
        hardEggImageForBtn.topAnchor.constraint(equalTo: hardEggView.topAnchor).isActive = true
        hardEggImageForBtn.leadingAnchor.constraint(equalTo: hardEggView.leadingAnchor).isActive = true
        hardEggImageForBtn.trailingAnchor.constraint(equalTo: hardEggView.trailingAnchor).isActive = true
        hardEggImageForBtn.bottomAnchor.constraint(equalTo: hardEggView.bottomAnchor).isActive = true
        
        sizeButton.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: -80).isActive = true
        sizeButton.topAnchor.constraint(equalTo: eggSatckView.bottomAnchor, constant: 5).isActive = true
        sizeButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
        sizeButton.widthAnchor.constraint(equalToConstant: 150).isActive = true
        
        tempButton.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 80).isActive = true
        tempButton.topAnchor.constraint(equalTo: eggSatckView.bottomAnchor, constant: 5).isActive = true
        tempButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
        tempButton.widthAnchor.constraint(equalToConstant: 150).isActive = true
        
        bannerAd.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: UIScreen.main.bounds.height < 750 ? 0 : -20).isActive = true
        bannerAd.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        bannerAd.heightAnchor.constraint(equalToConstant: 40).isActive = true
        bannerAd.widthAnchor.constraint(equalToConstant: 320).isActive = true
        
        progressView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        progressView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: UIScreen.main.bounds.height < 750 ? -view.frame.height/10 : -view.frame.height/8.96).isActive = true
        progressView.heightAnchor.constraint(equalToConstant: UIScreen.main.bounds.height < 750 ? view.frame.width/2 + 50: view.frame.width/1.3).isActive = true
        progressView.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.height < 750 ? view.frame.width/2 + 50: view.frame.width/1.3).isActive = true
        
//        player.topAnchor.constraint(equalTo: view.topAnchor, constant: 110).isActive = true
//        player.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
//        player.heightAnchor.constraint(equalToConstant: 300).isActive = true
//        player.widthAnchor.constraint(equalToConstant: 300).isActive = true
        
        animationContainer.topAnchor.constraint(equalTo: view.topAnchor, constant: UIScreen.main.bounds.height < 750 ? view.frame.height/12: view.frame.height/8.9).isActive = true
        animationContainer.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        animationContainer.heightAnchor.constraint(equalToConstant: view.frame.height/3).isActive = true
        animationContainer.widthAnchor.constraint(equalToConstant: view.frame.height/3).isActive = true
        
        animationView?.topAnchor.constraint(equalTo: animationContainer.topAnchor).isActive = true
        animationView?.bottomAnchor.constraint(equalTo: animationContainer.bottomAnchor).isActive = true
        animationView?.trailingAnchor.constraint(equalTo: animationContainer.trailingAnchor).isActive = true
        animationView?.leadingAnchor.constraint(equalTo: animationContainer.leadingAnchor).isActive = true
        
        stopButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        stopButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: UIScreen.main.bounds.height < 750 ? -view.frame.height/6 : -view.frame.height/5.6).isActive = true
        stopButton.heightAnchor.constraint(equalToConstant: 35).isActive = true
    }

    @objc func settingsBtnTouched(_ sender: UIButton) {
        guard let vc = storyboard?.instantiateViewController(identifier: "settings_vc") as? SettingsViewController else {
            return
        }
        
        let generator = UIImpactFeedbackGenerator(style: .medium)
        generator.prepare()
        generator.impactOccurred()
        
        UIView.animate(withDuration: 0.1, animations: {
            self.settingsButton.transform = CGAffineTransform(rotationAngle: .pi);
            self.settingsButton.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
        }) { (succes: Bool) in
            if succes {
                vc.modalPresentationStyle = .fullScreen
                vc.transitioningDelegate = self
                DispatchQueue.main.async {
                   self.present(vc, animated: true, completion: nil)
                }
                UIView.animate(withDuration: 0, delay: 0.1, animations: {
                    self.settingsButton.transform = .identity
                }, completion: nil)
            }
        }
    }
    @objc func infoBtnTouched(_ sender: UIButton) {
        guard let infovc = storyboard?.instantiateViewController(identifier: "receipe_vc") as? ChildHostingController else {
            return
        }
        
        let generator = UIImpactFeedbackGenerator(style: .medium)
        generator.prepare()
        generator.impactOccurred()
        
        let theButton = sender
        
        let bounds = theButton.bounds
        
        UIView.animate(withDuration: 0.1, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 50, options: .curveEaseInOut, animations: {
            theButton.bounds = CGRect(x: bounds.origin.x - 50, y: bounds.origin.y, width: bounds.size.width + 120, height: bounds.size.height)
            
        }) { (succes: Bool) in
            if succes {
//                infovc.modalPresentationStyle = .fullScreen
                self.present(infovc, animated: true)
                UIView.animate(withDuration: 0, delay: 0.1, animations: {
                    self.infoButton.transform = .identity
                }, completion: nil)
            }
        }
    }
    
    func hardnessSelected(totTime: Int, hardness: String) {
        lanceur = Lanceur(layer: self)
        lanceur.setup(frame: view.frame)
        view.layer.addSublayer(lanceur)
        
        EggTimer.invalidate()
        ProgressBarTimer.invalidate()
        totalTime = totTime
        print("totalTime:", totalTime)
        
        secondsPassed = 0
        
        stopButton.isEnabled = true
        
        testHardness(hardness: hardness)
    }
    @objc func softEggTouched() {
        hardnessSelected(totTime: 180, hardness: "À la coque")//180
        let setVc: SettingsViewController = SettingsViewController()
        setVc.createUserActivity()
    }
    @objc func meduimEggTouched() {
        hardnessSelected(totTime: 360, hardness: "Mollet")//360
    }
    @objc func hardEggTouched() {
        hardnessSelected(totTime: 540, hardness: "Dur")//540
    }
    @objc func sizeButtonTouched(_ sender: UIButton) {
        showMiracle()
    }
    @objc func tempButtonTouched(_ sender: UIButton) {
        showTMiracle()
    }
    @objc func stopButtonTouched(_ sender: UIButton) {
        EggTimer.invalidate()
        ProgressBarTimer.invalidate()
        titleLabel.text = "Minuteur arrêté".localized()
        Timer.scheduledTimer(withTimeInterval: 2, repeats: false) { (t) in
            UIView.animate(withDuration: 0.3, animations: { [self] in
                if appIsActive {
                    titleLabel.alpha = 0
                }
            }) { (succes: Bool) in
                if succes {
                    if !self.isPlaying {
                        UIView.animate(withDuration: 0.3, animations: {
                            self.titleLabel.text = self.titleLabelDefaultContent
                            self.titleLabel.textColor = self.setTitleColor
                            self.titleLabel.alpha = 1
                        })
                    }
                }
            }
        }
        resetPlacements()
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(.error)
    }
   
}



// MARK: -Extensions

extension ViewController: UIViewControllerTransitioningDelegate {
    public func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        EggSizeController(presentedViewController: presented, presenting: presenting)
    }
}

extension ViewController: passDataToMc {
    func passData(str: String) {
        eggSizeChoosed(overlayClosed: str)
    }
}

extension UIImageView {
    func dropShadow() {
        self.layer.masksToBounds = false
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOpacity = 0.5
        self.layer.shadowOffset = CGSize(width: 0, height: 3)
        self.layer.shadowRadius = 3
//        self.layer.shadowPath = UIBezierPath(rect: self.bounds).cgPath
        self.layer.shouldRasterize = true
        self.layer.rasterizationScale = UIScreen.main.scale
    }
}

extension UIButton {
    func dropShadow(_ color: UIColor ,opacity: Float, width: CGFloat, height: CGFloat, radius: CGFloat) {
        self.layer.masksToBounds = false
        self.layer.shadowColor = color.cgColor
        self.layer.shadowOpacity = opacity
        self.layer.shadowOffset = CGSize(width: width, height: height)
        self.layer.shadowRadius = radius
        self.layer.shouldRasterize = true
        self.layer.rasterizationScale = UIScreen.main.scale
    }
}

extension UILabel {
    func dropShadow() {
        self.layer.masksToBounds = false
        self.layer.shadowColor = UIColor.darkGray.cgColor
        self.layer.shadowOpacity = 0.5
        self.layer.shadowOffset = CGSize(width: 0, height: 5)
        self.layer.shadowRadius = 3
        self.layer.shouldRasterize = true
        self.layer.rasterizationScale = UIScreen.main.scale
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

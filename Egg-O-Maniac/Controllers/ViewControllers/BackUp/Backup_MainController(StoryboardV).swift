//
//  Backup_MainController(StoryboardV).swift
//  Egg-O-Maniac
//
//  Created by Maxence Gama on 22/01/2021.
//

/*

import UIKit
import AVFoundation
import CoreData
import Firebase
import GoogleMobileAds
import NotificationBannerSwift
import SwiftEntryKit
import HealthKit

public class ViewController: UIViewController, GADBannerViewDelegate {
      
    // MARK: -Initialization
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        lanceur = Lanceur(layer: self)
        lanceur.setup(frame: view.frame)
        view.layer.addSublayer(lanceur)
        setEggButtonsEnable(isEnabled: true)
        updateBackgroundColor()
        sizeButton.layer.cornerRadius = 20.0
        videoLayer.layer.masksToBounds = true
        
        resetPlacements()
        removeSavedDate()
        
        //let resetADS = false
        //UserDefaults.standard.setValue(resetADS, forKey: "isAddDelted")
        
        if UserDefaults.standard.object( forKey: "isAddDelted") as? Bool != nil {
            if UserDefaults.standard.object( forKey: "isAddDelted") as? Bool == true {
                print("Ads Disabled")
            } else {
                print("Ads Enabled")
                bannerView.adUnitID = "/6499/example/banner" //banner-(ca-app-pub-1041974861753876/6735271495)  \\//for-test-(/6499/example/banner)
                bannerView.rootViewController = self
                bannerView.load(DFPRequest())
                bannerView.delegate = self
            }
        }
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(applicationDidEnterBackground(noti:)), name: UIApplication.didEnterBackgroundNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(applicationWillEnterForeground(noti:)), name: UIApplication.didBecomeActiveNotification, object: nil)
         
    }
    
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewIsVisible = true
        print("viewIsVisible : \(viewIsVisible)")
        updateBackgroundColor()
        if isPlaying {
            videoLayer.alpha = 0
            choosVideoPlayerColor()
            UIView.animate(withDuration: 1, delay: 0.5, animations: {
                self.videoLayer.alpha = CGFloat(self.playLayerAlpha)
                }, completion: nil)
        } else {
            videoLayer.alpha = 0
        }
        /*if UserDefaults.standard.object(forKey: "isPlaying") as? Bool != nil {
            if UserDefaults.standard.object(forKey: "isPlaying") as? Bool == false {
                DispatchQueue.main.async {
                    self.resetAfterTimer()
                }
            }
        }*/
        
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
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var verticalStackView: UIStackView!
    @IBOutlet weak var settingsButton: UIButton!
    
    let eggTimes = ["À la coque": 15, "Mollet": 420, "Dur": 720] //300, 420, 720
    var EggTimer = Timer()
    var ProgressBarTimer = Timer()
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
    var playLayerAlpha = 1.0
    
    public var firstColor: UIColor = UIColor.clear
    public var secondColor: UIColor = UIColor.clear
    
    var appDelegate = UIApplication.shared.delegate as? AppDelegate
    var myApp: UIApplication!
    
    static let healthStore: HKHealthStore = HKHealthStore()
    
    @IBOutlet weak var softEggView: UIView!
    @IBOutlet weak var softButton: UIButton!
    @IBOutlet weak var mediumEggView: UIView!
    @IBOutlet weak var mediumButton: UIButton!
    @IBOutlet weak var hardEggView: UIView!
    @IBOutlet weak var hardButton: UIButton!
    @IBOutlet weak var stopButton: UIButton!
    @IBOutlet weak var progressView: ProgressBar!
    @IBOutlet weak var infoButton: UIButton!
    @IBOutlet weak var videoLayer: UIView!
    @IBOutlet weak var player: VideoPlayer!
    @IBOutlet weak var sizeButton: UIButton!
    @IBOutlet weak var bannerView: GADBannerView!
    
 
 
    // MARK: -Background Lists
    
    let backgroundColorsList = [UIColor(hexString: "#84caef"),//default
                                UIColor(hexString: "#00ffd5"),//cyan
                                UIColor(hexString: "#a22709"),//rouge
                                UIColor(hexString: "#67B75E"),//vert
                                UIColor(hexString: "#F8BB00"),//jaune
                                UIColor(hexString: "#BE5FCE"),//violet
                                UIColor(hexString: "#fdbcb4"),//saumon
                                UIColor(hexString: "#979797"),//gris
                                UIColor(hexString: "#FFFFFA")]//blanc
    
    let buttonsColorsList = [UIColor(hexString: "#456576"),//default
                             UIColor(hexString: "#007562"),//cyan
                             UIColor(hexString: "#440000"),//rouge
                             UIColor(hexString: "#0c4023"),//vert
                             UIColor(hexString: "#785710"),//jaune
                             UIColor(hexString: "#41184a"),//violet
                             UIColor(hexString: "#992f19"),//saumon
                             UIColor(hexString: "#303030"),//gris
                             UIColor(hexString: "#a29c9f")]//blanc
    
    let backButtonsColorsList = [UIColor(hexString: "#6fc1ed"),//default
                                 UIColor(hexString: "#00dcb8"),//cyan
                                 UIColor(hexString: "#971e07"),//rouge
                                 UIColor(hexString: "#409E5E"),//vert
                                 UIColor(hexString: "#E6A518"),//jaune
                                 UIColor(hexString: "#B645CE"),//violet
                                 UIColor(hexString: "#fbaa99"),//saumon
                                 UIColor(hexString: "#838383"),//gris
                                 UIColor(hexString: "#E6E6E6")]//blanc
    
    func setAlphaView(isShoun: CGFloat) {
        softEggView.alpha = isShoun
        mediumEggView.alpha = isShoun
        hardEggView.alpha = isShoun
        sizeButton.alpha = isShoun
    }
    
    func setEggButtonsEnable(isEnabled: Bool) {
        softButton.isEnabled = isEnabled
        mediumButton.isEnabled = isEnabled
        hardButton.isEnabled = isEnabled
        sizeButton.isEnabled = isEnabled
    }
 
    // MARK: -Select Hardness
    @IBAction func hardnessSelected(_ sender: UIButton) {
        
        lanceur = Lanceur(layer: self)
        lanceur.setup(frame: view.frame)
        view.layer.addSublayer(lanceur)
        
        EggTimer.invalidate()
        ProgressBarTimer.invalidate()
        
        let hardness = sender.currentTitle!
        totalTime = eggTimes[hardness]!
        print("totalTime:", totalTime)
        
        secondsPassed = 0
        titleLabel.text = hardness
        
        stopButton.isEnabled = true
        
        testHardness(hardness: hardness)
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
        
        if sizeChoosen {
            print("hardness:", hardness)
            checkSize(cuisson: hardness)
        } else {
            setUpTimerAndPlacement()
        }
    }
    
    // MARK: -Check Size
    func checkSize(cuisson: String) {
        print("size to chack:", size)
        
        if cuisson == "À la coque" {
            if size == "small" {
                totalTime -= 15
            } else if size == "large" {
                totalTime += 15
            }
        } else if cuisson == "Mollet" {
            if size == "small" {
                totalTime -= 30
            } else if size == "large" {
                totalTime += 30
            }
        } else if cuisson == "Dur" {
            if size == "small" {
                totalTime -= 45
            } else if size == "large" {
                totalTime += 45
            }
        }
        

        print("total", totalTime)
        
        setUpTimerAndPlacement()
    }
    
    func eggSizeChoosed(overlayClosed: String) {
        print("overlayClosed:", overlayClosed)
        
        if overlayClosed == "small" {
            size = "small"
            sizeButton.setTitle("Taille: Petit", for: .normal)
        } else if overlayClosed == "large" {
            size = "large"
            sizeButton.setTitle("Taille: Gros", for: .normal)
        } else if overlayClosed == "medium" {
            size = "medium"
            sizeButton.setTitle("Taille: Moyen", for: .normal)
        } else if overlayClosed == "dismiss" {
            self.titleLabel.text = "Quelle cuisson voulez-vous ?"
            self.titleLabel.textColor = .darkGray
        }
        sizeChoosen = true
        print("size:", size)
    }
    
    // MARK: -Choose Video Player
    
    func choosVideoPlayerColor() {
        let newRow = UserDefaults.standard.object(forKey: "row") as? Int
        
        if UserDefaults.standard.object(forKey: "row") as? Int != nil {
            if newRow! == 0 {
                player.playVideoWithFileName("Egg_Boil_blue", ofType: "mp4")
                isPlaying = true
            } else if newRow! == 1 {
                player.playVideoWithFileName("Egg_Boil_cyan", ofType: "mp4")
                isPlaying = true
            } else if newRow! == 2 {
                player.playVideoWithFileName("Egg_Boil_red", ofType: "mp4")
                isPlaying = true
            } else if newRow! == 3 {
                player.playVideoWithFileName("Egg_Boil_green", ofType: "mp4")
                isPlaying = true
            } else if newRow! == 4 {
                player.playVideoWithFileName("Egg_Boil_yellow", ofType: "mp4")
                isPlaying = true
            } else if newRow! == 5 {
                player.playVideoWithFileName("Egg_Boil_purple", ofType: "mp4")
                isPlaying = true
            } else if newRow! == 6 {
                player.playVideoWithFileName("Egg_Boil_salmon", ofType: "mp4")
                isPlaying = true
            } else if newRow! == 7 {
                player.playVideoWithFileName("EggBoil_gray", ofType: "mp4")
                isPlaying = true
            } else if newRow! == 8 {
                player.playVideoWithFileName("EggBoil_white", ofType: "mp4")
                isPlaying = true
            }
        } else {
            player.playVideoWithFileName("Egg_Boil_blue", ofType: "mp4")
            isPlaying = true
        }
    }

    // MARK: -Setup Placement and Timers
    
    private func setUpTimerAndPlacement() {
        
        titleLabel.alpha = 0
        
        choosVideoPlayerColor()
        
        setEggButtonsEnable(isEnabled: false)
        self.softEggView.alpha = 0
        self.hardEggView.alpha = 0
        self.mediumEggView.alpha = 0
        self.sizeButton.alpha = 0
        
        UIView.animate(withDuration: 0.0, delay: 0.0, options: .curveEaseInOut, animations: {
            self.stopButton.frame.origin.y -= 80;
            self.progressView.frame.origin.y += 70;
        }) { (succes: Bool) in
            if succes {
                UIView.animate(withDuration: 0.4, delay: 0.3, options: .curveEaseInOut, animations: {
                    self.progressView.frame.origin.y -= 70;
                    self.progressView.alpha = 1
                    }, completion: nil)
                
                self.stopButton.isEnabled = true
                UIView.animate(withDuration: 0.2, delay: 1,  usingSpringWithDamping: 0.6, initialSpringVelocity: 1, options: .curveEaseInOut, animations: {
                    self.stopButton.frame.origin.y += 80;
                    self.stopButton.alpha = 1
                }, completion: nil)
                
                UIView.animate(withDuration: 3, delay: 0.5, animations: {
                    self.videoLayer.alpha = CGFloat(self.playLayerAlpha)
                    }, completion: nil)
                
                let generator = UIImpactFeedbackGenerator(style: .heavy)
                generator.prepare()
                generator.impactOccurred()
            }
        }
        
        setEggButtonsEnable(isEnabled: false)
        
        let timersEnded = false
        print("timersEnded:", timersEnded)
        UserDefaults.standard.set(timersEnded, forKey: "timersEnded")
        
        countFired = 0
        setTimers(countFired: CGFloat(countFired))
    }
    
    
    func setTimers(countFired: CGFloat) {
        EggTimer = Timer.scheduledTimer(timeInterval: 1.0, target:self, selector: #selector(self.updateTimer), userInfo: nil, repeats: true)
        print("countFired : \(countFired)")
        ProgressBarTimer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { (timer) in self.countFired += 0.1
        
        self.progressView.progress = max((CGFloat(self.totalTime) - self.countFired) / (CGFloat(self.totalTime)), 0)
        self.progressView.timerText = String(self.totalTime - self.secondsPassed)
        
        if self.progressView.progress == 0 {
            self.ProgressBarTimer.invalidate()
            }
        }
        
        UserDefaults.standard.set(isPlaying, forKey: "isPlaying")
    }
    
    // MARK: -Backgound Fetch-----------------------------------------------------------------------------------------------------
    
    var diffHrs = 0
    var diffMins = 0
    var diffSecs = 0
    
    @objc func applicationDidEnterBackground(noti: Notification) {
        print("applicationDidEnterBackground")
        if UserDefaults.standard.object(forKey: "isPlaying") as? Bool != nil {
            if UserDefaults.standard.object(forKey: "isPlaying") as? Bool == true {
                self.ProgressBarTimer.invalidate()
                self.EggTimer.invalidate()
                let savedTime = Date()
                print("savedTime : \(savedTime)")
                UserDefaults.standard.setValue(savedTime, forKey: "savedTime")
                
                appDelegate?.scheduleNotification(timeInterval: (totalTime-secondsPassed))
                print("notification in \(totalTime-secondsPassed)s")
                
                player.stopVideo()
            }
        }
    }
    
    @objc func applicationWillEnterForeground(noti: Notification) {
        print("applicationWillEnterForeground")
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
        } else if secondsPassed < totalTime {
            countFired = CGFloat(secondsPassed)
            setTimers(countFired: CGFloat(secondsPassed))
            UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
            videoLayer.alpha = 0
            choosVideoPlayerColor()
            UIView.animate(withDuration: 1, delay: 0.5, animations: {
                self.videoLayer.alpha = CGFloat(self.playLayerAlpha)
                }, completion: nil)
            player.playVideo()
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
            
            writeHealthData()
    
            resetPlacements()
            print("view is visible")
            
            EggTimer.invalidate()
            titleLabel.text = "C'est cuit !"
            titleLabel.textColor = .red
            
            softButton.isEnabled = false
            mediumButton.isEnabled = false
            hardButton.isEnabled  = false
            lanceur.lancerConfettis()
            
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
            
            Timer.scheduledTimer(withTimeInterval: 5, repeats: false) { (t) in
                UIView.animate(withDuration: 0.3, animations: {
                    self.titleLabel.alpha = 0
                    self.lanceur.emitterCells?.removeAll()
                }) { (succes: Bool) in
                    if succes {
                        if !self.isPlaying {
                            UIView.animate(withDuration: 0.5, animations: {
                                self.titleLabel.text = "Quelle cuisson voulez-vous ?"
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
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 5, execute: {
                //Nbanner.dismiss()
            })
            
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
    
    /*func updateTimerBC() {
        DispatchQueue.global(qos: .background).async {
            DispatchQueue.main.async {
                
                print("is not active")
                
                //self.EggTimer.invalidate()
                //self.ProgressBarTimer.invalidate()
                self.isPlaying = false
                self.stopButton.isEnabled = false

                self.titleLabel.alpha = 1
                self.player.stopVideo()
                self.isPlaying = false
                UserDefaults.standard.set(self.isPlaying, forKey: "isPlaying")
                
                print("is playing", self.isPlaying)
                
                self.setEggButtonsEnable(isEnabled: true)
                
                self.size = ""
                self.sizeButton.setTitle("Choisir la taille", for: .normal)
                self.progressView.alpha = 0
                self.videoLayer.alpha = 0
                self.stopButton.frame.origin.y -= 80
                self.stopButton.alpha = 0
                self.progressView.frame.origin.y += 70
                self.setAlphaView(isShoun: 1.0)
                self.titleLabel.text = "Quelle cuisson voulez-vous ?"

            }
            
        }
    }*/
    
    
    // MARK: -Stop Button
    @IBAction func stopButton(_ sender: UIButton) {
        EggTimer.invalidate()
        ProgressBarTimer.invalidate()
        titleLabel.text = "Minuteur arrêté"
        Timer.scheduledTimer(withTimeInterval: 2, repeats: false) { (t) in
            UIView.animate(withDuration: 0.3, animations: {
                self.titleLabel.alpha = 0
            }) { (succes: Bool) in
                if succes {
                    if !self.isPlaying {
                        UIView.animate(withDuration: 0.3, animations: {
                            self.titleLabel.text = "Quelle cuisson voulez-vous ?"
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
    
    // MARK: -Reset Placement
    
    private func resetPlacements() {
        removeSavedDate()
        stopButton.isEnabled = false
        
        sizeButton.setTitle("Choisir la taille", for: .normal)

        titleLabel.alpha = 1
        player.stopVideo()
        isPlaying = false
        UserDefaults.standard.set(isPlaying, forKey: "isPlaying")
        
        print("is playing", isPlaying)
        
        setEggButtonsEnable(isEnabled: true)
        
        size = ""
        
        UIView.animate(withDuration: 0, delay: 0.0, options: .curveEaseInOut, animations: {
            self.progressView.alpha = 0;
            self.videoLayer.alpha = 0
            }) { (succes: Bool) in
                if succes {
                    self.stopButton.alpha = 0
                    self.setAlphaView(isShoun: 1.0)
                }
            }
    }
    
    public func resetAfterTimer() {
        removeSavedDate()
        
        sizeButton.setTitle("Choisir la taille", for: .normal)
        titleLabel.text = "Quelle cuisson voulez-vous ?"
        titleLabel.textColor = self.setTitleColor
        
        videoLayer.alpha = 0
        titleLabel.alpha = 1
        player.stopVideo()
        isPlaying = false
        size = ""
        setEggButtonsEnable(isEnabled: true)
        progressView.alpha = 0
        setAlphaView(isShoun: 1.0)
        stopButton.alpha = 0
        stopButton.isEnabled = false

    }
    
    // MARK: -Settings Button
    
    @available(iOS 14.0, *)
    @IBAction func settingsButton(_ sender: AnyObject) {
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
    
    // MARK: -Info Button
    
    @IBAction func infoButton(_ sender: AnyObject) {
        /*guard let infovc = storyboard?.instantiateViewController(identifier: "info_vc") as? InfoViewController else {
            return
        }*/     //receipices not finished
        guard let infovc = storyboard?.instantiateViewController(identifier: "waitingInfo_vc") as? WaitingViewController else {
            return
        }       //wait view for info VC
        
        let generator = UIImpactFeedbackGenerator(style: .medium)
        generator.prepare()
        generator.impactOccurred()
        
        let theButton = sender as! UIButton
        
        let bounds = theButton.bounds
        
        UIView.animate(withDuration: 0.1, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 50, options: .curveEaseInOut, animations: {
            theButton.bounds = CGRect(x: bounds.origin.x - 50, y: bounds.origin.y, width: bounds.size.width + 150, height: bounds.size.height)
            
        }) { (succes: Bool) in
            if succes {
                //infovc.modalPresentationStyle = .fullScreen
                self.present(infovc, animated: true)
                UIView.animate(withDuration: 0, delay: 0.1, animations: {
                    self.infoButton.transform = .identity
                }, completion: nil)
            }
        }
    }
    
    // MARK: -Show Miracle To Choose Size
    
    @objc func showMiracle() {
        let slideVC = OverlayFirtView()
        slideVC.modalPresentationStyle = .custom
        slideVC.transitioningDelegate = self
        slideVC.delegate = self
        self.present(slideVC, animated: true, completion: nil)
    }
    
    // MARK: -Update Background Color
    public func updateBackgroundColor() {
        //let reset = 0
        //UserDefaults.standard.setValue(reset, forKey: "row")
        
        let newRow = UserDefaults.standard.object(forKey: "row") as? Int
        
        if UserDefaults.standard.object(forKey: "row") as? Int != nil {
            view.backgroundColor = backgroundColorsList[newRow!]
            
            /*if newRow! != 0 || newRow! != 8 {
                setTitleColor = .black
                titleLabel.textColor = setTitleColor
            } else if newRow! == 0 || newRow! == 8 {
                setTitleColor = .darkGray
                titleLabel.textColor = setTitleColor
            }*/
            
            setTitleColor = .black
            titleLabel.textColor = setTitleColor
            
            softButton.setTitleColor(buttonsColorsList[newRow!], for: .normal)
            mediumButton.setTitleColor(buttonsColorsList[newRow!], for: .normal)
            hardButton.setTitleColor(buttonsColorsList[newRow!], for: .normal)
            
            if newRow! == 0 {
                sizeButton.backgroundColor = backButtonsColorsList[0]
                sizeButton.setTitleColor(.systemBlue, for: .normal)
            } else {
                sizeButton.backgroundColor = backButtonsColorsList[newRow!]
                sizeButton.setTitleColor(buttonsColorsList[newRow!], for: .normal)
            }
            
        } else {
            view.backgroundColor = backgroundColorsList[0]
            setTitleColor = .black
        }
    }
    
    // MARK: -Size Button
    @IBAction func sizeButton(_ sender: UIButton) {
        showMiracle()
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
        let title = "C'est cuit!"
        let description =
        """
        Ça y est vos oeufs sont prêts. \
        Votre minuteur est terminé.
        """
        
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
                text: "Fermer",
                style: .init(
                    font: UIFont.systemFont(ofSize: 16),
                    color: .black
                )
            ),
            backgroundColor: .init(UIColor(hexString: "#BBF2FF")),
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

/*
extension ViewController: HealthDataTableViewControllerDelegate {
    
    /// Handle a value corresponding to incoming HealthKit data.
    func didAddNewData(with value: Double) {
        guard let sample = processHealthSample(with: value) else { return }

        HealthData.saveHealthData([sample]) { [weak self] (success, error) in
            if let error = error {
                print("DataTypeTableViewController didAddNewData error:", error.localizedDescription)
            }
            if success {
                print("Successfully saved a new sample!", sample)
                DispatchQueue.main.async { [weak self] in
                    self?.reloadData()
                }
            } else {
                print("Error: Could not save new sample.", sample)
            }
        }
    }
    
    private func processHealthSample(with value: Double) -> HKObject? {
        let dataTypeIdentifier = self.dataTypeIdentifier
        
        guard
            let sampleType = getSampleType(for: dataTypeIdentifier),
            let unit = preferredUnit(for: dataTypeIdentifier)
        else {
            return nil
        }
        
        let now = Date()
        let start = now
        let end = now
        
        var optionalSample: HKObject?
        if let quantityType = sampleType as? HKQuantityType {
            let quantity = HKQuantity(unit: unit, doubleValue: value)
            let quantitySample = HKQuantitySample(type: quantityType, quantity: quantity, start: start, end: end)
            optionalSample = quantitySample
        }
        if let categoryType = sampleType as? HKCategoryType {
            let categorySample = HKCategorySample(type: categoryType, value: Int(value), start: start, end: end)
            optionalSample = categorySample
        }
        return optionalSample
    }
}
*/

*/

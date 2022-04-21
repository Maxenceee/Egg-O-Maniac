//
//  MainViewController.swift
//  EggTimer
//
//  Created by Maxence Gama on 01/11/2020.
//

import UIKit

@available(iOS 14.0, *)
class MainViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    /*
    let backgroundColorsList = [UIColor(hexString: "#84caef"),//default
                                UIColor(hexString: "#00ffd5"),//cyan
                                UIColor(hexString: "#a22709"),//rouge
                                UIColor(hexString: "#67B75E"),//vert
                                UIColor(hexString: "#F8BB00"),//jaune
                                UIColor(hexString: "#BE5FCE"),//violet
                                UIColor(hexString: "#fdbcb4"),//saumon
                                UIColor(hexString: "#979797"),//gris
                                UIColor(hexString: "#FFFFFA")]//blancc
    
    let buttonsColorsList = [UIColor(hexString: "#6fc1ed"),//default
                             UIColor(hexString: "#00dcb8"),//cyan
                             UIColor(hexString: "#8e141e"),//rouge
                             UIColor(hexString: "#409E5E"),//vert
                             UIColor(hexString: "#E6A518"),//jaune
                             UIColor(hexString: "#B645CE"),//violet
                             UIColor(hexString: "#fbaa99"),//saumon
                             UIColor(hexString: "#838383"),//gris
                             UIColor(hexString: "#E6E6E6")]//blanc
    
    @IBOutlet weak var settingsButton: UIButton!
    @IBOutlet weak var infoButton: UIButton!
    @IBOutlet weak var choosHardenss: UIButton!
    @IBOutlet weak var progressView: ProgressBar!
    @IBOutlet weak var stopButton: UIButton!
    @IBOutlet weak var videoLayer: UIView!
    @IBOutlet weak var player: VideoPlayer!
    
    var EggTimer = Timer()
    var ProgressBarTimer = Timer()
    var totalTime = 0
    var secondsPassed = 0
    var countFired: CGFloat = 0
    
    public override func viewDidLoad() {
        updateBackgroundColor()
        
        choosHardenss.layer.cornerRadius = 20
        DispatchQueue.main.async {
            self.resetPlacements()
        }
        videoLayer.alpha = 0
    }
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateBackgroundColor()
    }
    
    func updateBackgroundColor() {
        let newRow = UserDefaults.standard.object(forKey: "row") as? Int
        
        if UserDefaults.standard.object(forKey: "row") as? Int != nil {
            view.backgroundColor = backgroundColorsList[newRow!]
            choosHardenss.backgroundColor = buttonsColorsList[newRow!]
        } else {
            view.backgroundColor = backgroundColorsList[0]
            choosHardenss.backgroundColor = buttonsColorsList[0]
        }
    }
    
    @IBAction func stopButton(_ sender: UIButton) {
        EggTimer.invalidate()
        ProgressBarTimer.invalidate()
        resetPlacements()
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(.error)
    }
    
    @IBAction func settingsButton(_ sender: UIButton) {
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
                self.present(vc, animated: true)
                UIView.animate(withDuration: 0, delay: 0.1, animations: {
                    self.settingsButton.transform = .identity
                }, completion: nil)
            }
        }
    }
    
    @IBAction func infoButton(_ sender: Any) {
        guard let infovc = storyboard?.instantiateViewController(identifier: "info_vc") as? InfoViewController else {
            return
        }
        
        let generator = UIImpactFeedbackGenerator(style: .medium)
        generator.prepare()
        generator.impactOccurred()
        
        let theButton = sender as! UIButton
        
        let bounds = theButton.bounds
        
        UIView.animate(withDuration: 0.1, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 50, options: .curveEaseInOut, animations: {
            theButton.bounds = CGRect(x: bounds.origin.x - 50, y: bounds.origin.y, width: bounds.size.width + 150, height: bounds.size.height)
            
        }) { (succes: Bool) in
            if succes {
                infovc.modalPresentationStyle = .fullScreen
                self.present(infovc, animated: true)
                UIView.animate(withDuration: 0, delay: 0.1, animations: {
                    self.infoButton.transform = .identity
                }, completion: nil)
            }
        }
    }
    
    @IBAction func choosHardenss(_ sender: UIButton) {
        showMiracle()
    }
    
    @IBAction func CloseTemporarely(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    @objc func showMiracle() {
        let slideVC = OverlayCuisson()
        slideVC.modalPresentationStyle = .custom
        slideVC.transitioningDelegate = self
        slideVC.delegate = self
        self.present(slideVC, animated: true, completion: nil)
    }
    
    private func setUpTimerAndPlacement() {
        
        videoLayer.alpha = 1
        player.playVideoWithFileName("EggBoil", ofType: "mp4")
        
        choosHardenss.isEnabled = false
        choosHardenss.alpha = 0
        
        secondsPassed = 0
        
        UIView.animate(withDuration: 0.4, delay: 0.3, options: .curveEaseInOut, animations: {
            self.progressView.frame.origin.y -= 70;
            self.progressView.alpha = 1
            }, completion: nil)
        
        stopButton.isEnabled = true
        UIView.animate(withDuration: 0.2, delay: 0.8,  usingSpringWithDamping: 0.6, initialSpringVelocity: 1, options: .curveEaseInOut, animations: {
            self.stopButton.frame.origin.y += 100;
            self.stopButton.alpha = 1
        }, completion: nil)
        
        let generator = UIImpactFeedbackGenerator(style: .heavy)
        generator.prepare()
        generator.impactOccurred()
        
        EggTimer = Timer.scheduledTimer(timeInterval: 1.0, target:self, selector: #selector(updateTimer), userInfo: nil, repeats: true)
        
        countFired = 0
        ProgressBarTimer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { (timer) in self.countFired += 0.1
        
        DispatchQueue.main.async {
            self.progressView.progress = max((CGFloat(self.totalTime) - self.countFired) / (CGFloat(self.totalTime)), 0)
            self.progressView.timerText = String(self.totalTime - self.secondsPassed)
            
            if self.progressView.progress == 0 {
                self.ProgressBarTimer.invalidate()
                }
            }
        }
    }
        
    @objc func updateTimer() {
        if secondsPassed < totalTime {
            secondsPassed += 1
        } else {
            EggTimer.invalidate()
            
            let generator = UINotificationFeedbackGenerator()
            generator.notificationOccurred(.success)
        }
    }
    
    func resetPlacements() {
        
        videoLayer.alpha = 0
        player.stopVideo()
        
        choosHardenss.isEnabled = true
        
        stopButton.isEnabled = false
        UIView.animate(withDuration: 0.1, delay: 0.0, options: .curveEaseInOut, animations: {
            self.stopButton.frame.origin.y -= 100;
            self.stopButton.alpha = 0
            }, completion: nil)
        
        UIView.animate(withDuration: 0.3, delay: 0.0, options: .curveEaseInOut, animations: {
            self.progressView.alpha = 0
            }) { (succes: Bool) in
                if succes {
                    self.progressView.frame.origin.y += 70;
                    self.choosHardenss.alpha = 1
                }
            }
    }
    
    func eggCuisson(overlayClosed: String) {
        print(overlayClosed)
        
        if overlayClosed == "soft" {
            totalTime = 15
        } else if overlayClosed == "med" {
            totalTime = 65
        } else if overlayClosed == "hard" {
            totalTime = 720
        } else {
            totalTime = 0
        }
        setUpTimerAndPlacement()
    }
    /*
    func playVideo(currrentlyPlaying: Bool) {
        let playerLayer = AVPlayerLayer()
        
        let path = Bundle.main.url(forResource: "EggBoil", withExtension: "mp4")
        let playerItem = AVPlayerItem(url: path!)
        
        let player = AVPlayer(playerItem: playerItem)
        playerLayer.player = player
        playerLayer.videoGravity = .resizeAspectFill
        self.videoLayer.layer.addSublayer(playerLayer)
        
        player.play()
        /*
        if currrentlyPlaying {
            player.play()
            player.isMuted = true
        } else {
            player.pause()
        }*/
        
    }*/

 */
}

/*
extension MainViewController: UIViewControllerTransitioningDelegate {
    public func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        EggSizeController(presentedViewController: presented, presenting: presenting)
    }
    
}

extension MainViewController: passDataToNmC {
    func passData(str: String) {
        eggCuisson(overlayClosed: str)
    }
}
*/

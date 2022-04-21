//
//  WaitingViewController.swift
//  Egg-O-Maniac
//
//  Created by Maxence Gama on 05/12/2020.
//

import UIKit
import AVFoundation

class WaitingViewController: UIViewController {
    
    @IBOutlet weak var player: VideoPlayer!
    @IBOutlet var waitingLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(applicationDidEnterBackground(noti:)), name: UIApplication.didEnterBackgroundNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(applicationWillEnterForeground(noti:)), name: UIApplication.didBecomeActiveNotification, object: nil)
        
        player.playVideoWithFileName("Loading_anim_InfoVC")
        
        var count = 0
        Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { (t) in
            if count == 3 {
                self.waitingLabel.text = "Encore un peu de patience"
                count = 0
            } else {
                self.waitingLabel.text! += "."
                count += 1
            }
        }
    }

    @IBAction func close(_ sender: UIButton) {
        let generator = UIImpactFeedbackGenerator(style: .heavy)
        generator.prepare()
        generator.impactOccurred()
        dismiss(animated: true, completion: nil)
    }
    
    @objc func applicationDidEnterBackground(noti: Notification) {
        player.stopVideo()
    }
    
    @objc func applicationWillEnterForeground(noti: Notification) {
        player.playVideo()
    }
}

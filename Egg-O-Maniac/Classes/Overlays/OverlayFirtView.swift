//
//  OverlayFirtView.swift
//  EggTimer
//
//  Created by Maxence Gama on 23/10/2020.
//

import UIKit

protocol passDataToMc {
    func passData(str: String)
}

class OverlayFirtView: UIViewController {
    
    var hasSetPointOrigin = false
    var pointOrigin: CGPoint?
    
    @IBOutlet weak var slideIdicator: UIView!
    @IBOutlet weak var eggS: UIView!
    @IBOutlet weak var eggM: UIView!
    @IBOutlet weak var eggL: UIView!

    var delegate: passDataToMc!
    
    @IBAction func smalClicked(_ sender: Any) {
        UIView.animate(withDuration: 0.2, animations: {
            self.eggS.alpha = 0.5;
        }) { (succes: Bool) in
            if succes {
                self.delegate.passData(str: "small")
                self.dismiss(animated: true, completion: nil)
            }
        }
    }
    @IBAction func mediumClicked(_ sender: Any) {
        UIView.animate(withDuration: 0.2, animations: {
            self.eggM.alpha = 0.5;
        }) { (succes: Bool) in
            if succes {
                self.delegate.passData(str: "medium")
                self.dismiss(animated: true, completion: nil)
            }
        }
    }
    @IBAction func largeClicked(_ sender: Any) {
        UIView.animate(withDuration: 0.2, animations: {
            self.eggL.alpha = 0.5;
        }) { (succes: Bool) in
            if succes {
                self.delegate.passData(str: "large")
                self.dismiss(animated: true, completion: nil)
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(panGestureRecognizerAction))
        view.addGestureRecognizer(panGesture)
        
        slideIdicator.roundCorners(.allCorners, radius: 10)
    }
    
    override var prefersHomeIndicatorAutoHidden: Bool {
        return true
    }
    
    override func viewDidLayoutSubviews() {
        if !hasSetPointOrigin {
            hasSetPointOrigin = true
            pointOrigin = self.view.frame.origin
        }
    }
    @objc func panGestureRecognizerAction(sender: UIPanGestureRecognizer) {
        var translation = sender.translation(in: view)
        
        // Not allowing the user to drag the view upward
//        guard translation.y >= -330 else { return }
        
        print(translation.y)
        
        if translation.y < 0 {
            translation.y -= translation.y/1.1
        }
        
        // setting x as 0 because we don't want users to move the frame side ways!! Only want straight up or down
        view.frame.origin = CGPoint(x: 10, y: self.pointOrigin!.y + translation.y)
        
        if sender.state == .ended {
            let dragVelocity = sender.velocity(in: view)
            if dragVelocity.y >= 1300 || translation.y > 150 {
                self.dismiss(animated: true, completion: nil)
            } else {
                // Set back to original position of the view controller
                UIView.animate(withDuration: 0.3) {
                    self.view.frame.origin = self.pointOrigin ?? CGPoint(x: 0, y: 400)
                }
            }
        }
    }

}

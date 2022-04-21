//
//  OverlayTempView.swift
//  Egg-O-Maniac
//
//  Created by Maxence Gama on 05/03/2021.
//

import UIKit

class OverlayTempView: UIViewController {

    var hasSetPointOrigin = false
    var pointOrigin: CGPoint?
    
    @IBOutlet var tempLabel: UILabel!
    @IBOutlet var tempSlider: UISlider!
    @IBOutlet var mainLabel: UILabel!
    @IBOutlet var sliderIndicator: UIView!
    
    var lastValue: Float = 0
    let step: Float = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(panGestureRecognizerAction))
        view.addGestureRecognizer(panGesture)
        
        sliderIndicator.RoundCorners(.allCorners, radius: 10)
        
        if UserDefaults.standard.object(forKey: "eggTemp") as? Float != nil {
            let absTemp =  UserDefaults.standard.object(forKey: "eggTemp") as? Float
            print(absTemp!)
            let temp = String(format: "%.0f", absTemp!)
            var feelTemp: String = ""
            if absTemp! < 0 {
                feelTemp = " - Congélateur".localized()
            } else if absTemp! >= 0 && absTemp! < 10 {
                feelTemp = " - Réfrigérateur".localized()
            } else if absTemp! >= 10 && absTemp! < 20 {
                feelTemp = " - Légèrement frais".localized()
            } else if absTemp! >= 20 && absTemp! < 35 {
                feelTemp = " - Temp. Ambiante".localized()
            } else if absTemp! >= 35 {
                feelTemp = " - Coup de chaud".localized()
            }
            tempLabel.text = "\(temp)°\(feelTemp)"
            tempSlider.value = absTemp!
        } else {
            let temp = String(format: "%.0f", 20.0)
            tempLabel.text = "\(temp)° - Temp. Ambiante".localized()
            tempSlider.value = 20
        }
        
        mainLabel.font = UIFont.systemFont(ofSize: UIScreen.main.bounds.width < 400 ? 20 : 25)
        
    }
    
    override var prefersHomeIndicatorAutoHidden: Bool {
        return true
    }
    
    @IBAction func tempSliderChnaged(_ sender: UISlider) {
        let temp = String(format: "%.0f", sender.value)
        let roundedStepValue = round(sender.value / step) * step
        sender.value = roundedStepValue
        var feelTemp: String = ""
        if sender.value < 0 {
            feelTemp = " - Congélateur".localized()
        } else if sender.value >= 0 && sender.value < 10 {
            feelTemp = " - Réfrigérateur".localized()
        } else if sender.value >= 10 && sender.value < 20 {
            feelTemp = " - Légèrement frais".localized()
        } else if sender.value >= 20 && sender.value < 35 {
            feelTemp = " - Temp. Ambiante".localized()
        } else if sender.value >= 35 {
            feelTemp = " - Coup de chaud".localized()
        }
        tempLabel.text = "\(temp)°\(feelTemp)"
        UserDefaults.standard.setValue(sender.value, forKey: "eggTemp")
        
        if abs(sender.value) - abs(lastValue) >= 1 || abs(sender.value) - abs(lastValue) <= -1 {
            lastValue = roundedStepValue
            let generator = UIImpactFeedbackGenerator(style: .medium)
            generator.prepare()
            generator.impactOccurred()
        }
    }
    
    @objc func dismissOverlay() {
        self.dismiss(animated: true, completion: nil)
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

class MySliderStepper: UISlider {
    private let values: [Float]
    private var lastIndex: Int? = nil
    let callback: (Float) -> Void

    init(frame: CGRect, values: [Float], callback: @escaping (_ newValue: Float) -> Void) {
        self.values = values
        self.callback = callback
        super.init(frame: frame)
        self.addTarget(self, action: #selector(handleValueChange(sender:)), for: .valueChanged)

        let steps = values.count - 1
        self.minimumValue = 0
        self.maximumValue = Float(steps)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    @objc func handleValueChange(sender: UISlider) {
        let newIndex = Int(sender.value + 0.5) // round up to next index
        self.setValue(Float(newIndex), animated: false) // snap to increments
        let didChange = lastIndex == nil || newIndex != lastIndex!
        if didChange {
            lastIndex = newIndex
            let actualValue = self.values[newIndex]
            self.callback(actualValue)
        }
    }
}

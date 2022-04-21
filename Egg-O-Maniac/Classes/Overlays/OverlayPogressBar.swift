//
//  OverlayPogressBar.swift
//  EggTimer
//
//  Created by Maxence Gama on 31/10/2020.
//

import UIKit

class OverlayPogressBar: UIViewController {
    
    var hasSetPointOrigin = false
    var pointOrigin: CGPoint?
    
    //let defaultColor = UIColor(hexString: "#ACD9EC")
    
    @IBOutlet weak var slideIdicator: UIView!
    
    @IBOutlet weak var ColorPicker: UIPickerView!
    @IBOutlet weak var PickerLabel: UILabel!
    @IBOutlet var customColorButtoon: UIButton!
    /*
    var diffBackgroundColors = ["Rouge & Orange-Default".localized(),//1
                                "Cyan & Vert".localized(),//2
                                "Rouge & Rose".localized(),//3
                                "Bleu & Violet".localized(),//4
                                "Vert & Marron".localized(),//5
                                "Rouge & Cyan".localized(),//6
                                "Vairon & Rose Pâle".localized(),//7
                                "Jaune & Blanc".localized()]//8
    */
    var selectedColor: String!
    var selectedColorValue: UIColor = .clear
    
    var savedrow = UserDefaults.standard.object(forKey: "PBrow") as? Int
    
    var pickerViewContent = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(panGestureRecognizerAction))
        view.addGestureRecognizer(panGesture)
        
        pickerViewContent = ColorList.diffPbBackgroundColors
        
        customColorButtoon.RoundCorners(.allCorners, radius: 10)
        customColorButtoon.backgroundColor = UIColor(hexString: "#777777", alpha: 0.3)
        customColorButtoon.setImage(UIImage.init(systemName: "plus"), for: .normal)
        
        slideIdicator.roundCorners(.allCorners, radius: 10)
        
        let isColorCustom = UserDefaults.standard.object(forKey: "isColorCustom") as? Bool
        
        if isColorCustom != nil && isColorCustom! == true {
            pickerViewContent.append("Couleurs Personnalisées".localized())
            
            selectedColor = pickerViewContent[pickerViewContent.count - 1]
            ColorPicker.selectRow(pickerViewContent.count - 1, inComponent: 0, animated: true)
        } else {
            if savedrow != nil {
                ColorPicker.selectRow(savedrow!, inComponent: 0, animated: true )
            }
            
            if savedrow != nil {
                print(savedrow!)
                selectedColor = pickerViewContent[savedrow!]
            } else {
                selectedColor = pickerViewContent[0]
            }
        }
        
        PickerLabel.text = selectedColor
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        if self.traitCollection.userInterfaceStyle == .dark {
            customColorButtoon.tintColor = UIColor(hexString: "#cdcdcd", alpha: 0.8)
        } else {
            customColorButtoon.tintColor = UIColor(hexString: "#383838", alpha: 0.8)
        }
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
    
    func creatToolBar() {
        let toolBar = UIToolbar()
        toolBar.sizeToFit()
        
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(dismissOverlay))
        toolBar.setItems([doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
    }
    
    @objc func dismissOverlay() {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func customeColorsButtonClicked(_ sender: Any) {
        UIButton.animate(withDuration: 0.1, delay: 0, options: .curveEaseInOut, animations: { [self] in
            customColorButtoon.transform = CGAffineTransform(rotationAngle: .pi/4);
        }) { (succes) in
            if succes {
                self.showCCiracle()
            }
        }
    }
    
    @objc func showCCiracle() {
        weak var pvc = self.presentingViewController

        self.dismiss(animated: true, completion: {
            let slideVC = CustomPBColorsViewController()
            slideVC.modalPresentationStyle = .custom
            slideVC.transitioningDelegate = self
            pvc?.present(slideVC, animated: true, completion: nil)
        })
    }
}

extension OverlayPogressBar: UIPickerViewDelegate, UIPickerViewDataSource {

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerViewContent.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerViewContent[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        if selectedColor != pickerViewContent[row] {
            Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false) { (t) in
                self.dismiss(animated: true, completion: nil)
            }
            
            selectedColor = pickerViewContent[row]
            PickerLabel.text = selectedColor
            
            print("isColorCustom :", (UserDefaults.standard.object(forKey: "isColorCustom") as? Bool != nil))
            
            if (UserDefaults.standard.object(forKey: "isColorCustom") as? Bool != nil) == true {
                UserDefaults.standard.set(false, forKey: "isColorCustom")
                print("pop")
            }
            
            UserDefaults.standard.set(row, forKey: "PBrow")
            print("npnc", (UserDefaults.standard.object(forKey: "PBrow") as? Int)!)
        }
    }
}

extension OverlayPogressBar: UIViewControllerTransitioningDelegate {
    public func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        CustomeColorsPresentation(presentedViewController: presented, presenting: presenting)
    }
}

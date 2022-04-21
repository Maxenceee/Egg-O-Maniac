//
//  CustomPBColorsViewController.swift
//  Egg-O-Maniac
//
//  Created by Maxence Gama on 06/03/2021.
//

import UIKit

class CustomPBColorsViewController: UIViewController {
    
    var hasSetPointOrigin = false
    var pointOrigin: CGPoint?

    @IBOutlet var color1: UIButton!
    @IBOutlet var color2: UIButton!
    @IBOutlet var sliderIdicator: UIView!
    @IBOutlet var saveButton: UIButton!
    @IBOutlet var colorsPreview: UIView!
    @IBOutlet var cancelButton: UIButton!
    @IBOutlet var colorPreviewWidth: NSLayoutConstraint!
    
    @IBOutlet var color1Width: NSLayoutConstraint!
    @IBOutlet var color2Width: NSLayoutConstraint!
    
    public var selectedColor = UIColor.systemTeal
    private var colorPicker = UIColorPickerViewController()
    
    private var gradientLayer: CAGradientLayer!
    private var foregroundLayer: CAShapeLayer!
    
    var customColor1: UIColor!
    var customColor2: UIColor!
    
    var isFirstButtonClicked: Bool!
    /*
    let firstColorList = [UIColor(hexString: "#fea948", alpha: 1),//1
                          UIColor(hexString: "#00ffd5", alpha: 1),//2
                          UIColor(hexString: "#ff1600", alpha: 1),//3
                          UIColor(hexString: "#3172ed", alpha: 1),//4
                          UIColor(hexString: "#008a5f", alpha: 1),//5
                          UIColor(hexString: "#f92909", alpha: 1),//6
                          UIColor(hexString: "#a6f1ac", alpha: 1),//7
                          UIColor(hexString: "#ffc83a", alpha: 1)]//8
    
    let secondColorList = [UIColor(hexString: "#F10101", alpha: 1),//1
                           UIColor(hexString: "#00ff00", alpha: 1),//2
                           UIColor(hexString: "#da00ff", alpha: 1),//3
                           UIColor(hexString: "#7b008a", alpha: 1),//4
                           UIColor(hexString: "#834a00", alpha: 1),//5
                           UIColor(hexString: "#00fdff", alpha: 1),//6
                           UIColor(hexString: "#b33687", alpha: 1),//7
                           UIColor(hexString: "#ffe2c6", alpha: 1)]//8
    */
    override func viewDidLoad() {
        super.viewDidLoad()
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(panGestureRecognizerAction))
        view.addGestureRecognizer(panGesture)
        colorPicker.delegate = self
        
        view.addSubview(gradientLabel)
        view.addSubview(colorsPreview)
        
        setupLayout()
        
        if UIScreen.main.bounds.width < 400 {
            color1Width.constant = 130
            color2Width.constant = 130
            colorPreviewWidth.constant -= 20
            color1.layer.cornerRadius = 15
            color2.layer.cornerRadius = 15
        } else {
            color1.RoundCorners(.allCorners, radius: 15)
            color2.RoundCorners(.allCorners, radius: 15)
        }
        
        sliderIdicator.RoundCorners(.allCorners, radius: 10)
        colorsPreview.RoundCorners(.allCorners, radius: 10)
        
//        saveButton.RoundCorners(.allCorners, radius: 10)
//        saveButton.backgroundColor = .systemGray5
        
        cancelButton.RoundCorners(.allCorners, radius: 10)
        cancelButton.backgroundColor = UIColor(hexString: "#777777", alpha: 0.3)
        cancelButton.setImage(UIImage.init(systemName: "chevron.backward"), for: .normal)
        
        saveButton.RoundCorners(.allCorners, radius: 10)
        saveButton.backgroundColor = UIColor(hexString: "#777777", alpha: 0.3)
        saveButton.setImage(#imageLiteral(resourceName: "save"), for: .normal)
        
        let isColorCustom = UserDefaults.standard.object(forKey: "isColorCustom") as? Bool
        
        if isColorCustom != nil && isColorCustom == true{
            customColor1 = UserDefaults.standard.colorForKey(key: "customColor1")
            customColor2 = UserDefaults.standard.colorForKey(key: "customColor2")
            
            if customColor1 != nil {
                color1.backgroundColor = customColor1!
            }
            if customColor2 != nil {
                color2.backgroundColor = customColor2!
            }
            if customColor1 != nil && customColor2 != nil {
                setColorsPreview(Gcolor1: customColor1!, Gcolor2: customColor2!)
            }
        } else {
            let savedrow = UserDefaults.standard.object(forKey: "PBrow") as? Int
            
            if savedrow != nil {
                color1.backgroundColor = ColorList.firstColorList[savedrow!]
                color2.backgroundColor = ColorList.secondColorList[savedrow!]
                setColorsPreview(Gcolor1: ColorList.firstColorList[savedrow!], Gcolor2: ColorList.secondColorList[savedrow!])
                customColor1 = ColorList.firstColorList[savedrow!]
                customColor2 = ColorList.secondColorList[savedrow!]
            } else {
                color1.backgroundColor = ColorList.firstColorList[0]
                color2.backgroundColor = ColorList.secondColorList[0]
                setColorsPreview(Gcolor1: ColorList.firstColorList[0], Gcolor2: ColorList.secondColorList[0])
                customColor1 = ColorList.firstColorList[0]
                customColor2 = ColorList.secondColorList[0]
            }
        }
        
        setupBarButton()
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        if self.traitCollection.userInterfaceStyle == .dark {
            saveButton.tintColor = UIColor(hexString: "#cdcdcd", alpha: 0.8)
            cancelButton.tintColor = UIColor(hexString: "#cdcdcd", alpha: 0.8)
        } else {
            saveButton.tintColor = UIColor(hexString: "#383838", alpha: 0.8)
            cancelButton.tintColor = UIColor(hexString: "#383838", alpha: 0.8)
        }
    }
    
    override var prefersHomeIndicatorAutoHidden: Bool {
        return true
    }
    
    func setColorsPreview(Gcolor1: UIColor, Gcolor2: UIColor) {
        colorsPreview.backgroundColor = UIColor.clear
        let layer = CAGradientLayer()
        layer.frame = colorsPreview.bounds
        layer.colors = [Gcolor1.cgColor, Gcolor2.cgColor]
        layer.startPoint = CGPoint(x: 0,y: 0.5)
        layer.endPoint = CGPoint(x: 1,y: 0.5)
        colorsPreview.layer.addSublayer(layer)
    }
    
    @IBAction func color1Clicked(_ sender: Any) {
        isFirstButtonClicked = true
        print(isFirstButtonClicked!)
        selectColor()
    }
    @IBAction func color2Clicked(_ sender: Any) {
        isFirstButtonClicked = false
        print(isFirstButtonClicked!)
        selectColor()
    }
    @IBAction func closeBUtton(_ sender: Any) {
        UserDefaults.standard.set(true, forKey: "isColorCustom")
        UserDefaults.standard.setColor(color: customColor1, forKey: "customColor1")
        UserDefaults.standard.setColor(color: customColor2, forKey: "customColor2")
        print(UserDefaults.standard.object(forKey: "isColorCustom") as? Bool != nil)
        dismissOverlay()
    }
    @IBAction func cancelButton(_ sender: Any) {
        UIButton.animate(withDuration: 0.1, delay: 0, options: .curveEaseInOut, animations: { [self] in
            cancelButton.transform = CGAffineTransform(rotationAngle: -.pi/2);
        }) { (succes) in
            if succes {
                Timer.scheduledTimer(withTimeInterval: 0.1, repeats: false) { (t) in
                    self.showPBiracle()
                }
            }
        }
    }
    
    @objc func showPBiracle() {
        weak var pvc = self.presentingViewController

        self.dismiss(animated: true, completion: {
            let slideVC = OverlayPogressBar()
            slideVC.modalPresentationStyle = .custom
            slideVC.transitioningDelegate = self
            pvc?.present(slideVC, animated: true, completion: nil)
        })
    }
    
    @objc func dismissOverlay() {
        self.dismiss(animated: true, completion: nil)
    }
    
    public func selectColor() {
        colorPicker.supportsAlpha = false
        colorPicker.selectedColor = selectedColor
        present(colorPicker, animated: true)
    }
    
    private func setupBarButton() {
        let pickedColorAction = UIAction(title: "choosColor") {_ in
            self.selectColor()
        }
        
        let pickColorBarButton = UIBarButtonItem(image: UIImage(systemName: "eyedropper"), primaryAction: pickedColorAction)
        
        navigationItem.rightBarButtonItem = pickColorBarButton
    }
    
    let gradientLabel: UILabel = {
        let label = UILabel()
        label.text = "Rendu actuel :".localized()
        label.font = UIFont.systemFont(ofSize: UIScreen.main.bounds.width < 400 ? 14 : 17)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    func setupLayout() {
        gradientLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 150).isActive =  true
        gradientLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: UIScreen.main.bounds.width < 400 ? view.frame.width/8 : view.frame.width/6).isActive = true
        gradientLabel.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width < 400 ? 100 : 120).isActive = true
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

@available(iOS 14.0, *)
extension CustomPBColorsViewController: UIColorPickerViewControllerDelegate {
    func colorPickerViewControllerDidSelectColor(_ viewController: UIColorPickerViewController) {
        selectedColor = viewController.selectedColor
        
        if isFirstButtonClicked! {
            customColor1 = selectedColor
            color1.backgroundColor = customColor1
        } else if !isFirstButtonClicked! {
            customColor2 = selectedColor
            color2.backgroundColor = customColor2
        }
        setColorsPreview(Gcolor1: customColor1, Gcolor2: customColor2)
        colorsPreview.setNeedsDisplay()
        colorsPreview.setNeedsLayout()
    }
    
    func colorPickerViewControllerDidFinish(_ viewController: UIColorPickerViewController) {
        isFirstButtonClicked = nil
        print("Choisis")
    }
    
}

extension UserDefaults {
  func colorForKey(key: String) -> UIColor? {
    var colorReturnded: UIColor?
    if let colorData = data(forKey: key) {
      do {
        if let color = try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(colorData) as? UIColor {
          colorReturnded = color
        }
      } catch {
        print("Error UserDefaults")
      }
    }
    return colorReturnded
  }
  
  func setColor(color: UIColor?, forKey key: String) {
    var colorData: NSData?
    if let color = color {
      do {
        let data = try NSKeyedArchiver.archivedData(withRootObject: color, requiringSecureCoding: false) as NSData?
        colorData = data
      } catch {
        print("Error UserDefaults")
      }
    }
    set(colorData, forKey: key)
  }
}

extension CustomPBColorsViewController: UIViewControllerTransitioningDelegate {
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        PresentationController(presentedViewController: presented, presenting: presenting)
    }
}

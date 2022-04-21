//
//  OverlayView.swift
//

import UIKit

protocol passColorToVCs {
    func passDataColor(newColor: UIColor)
}

class OverlayView: UIViewController {
    
    var hasSetPointOrigin = false
    var pointOrigin: CGPoint?
    
    var delegate: passColorToVCs!
    
    var viewController: ViewController!
    
    @IBOutlet var customColorButton: UIButton!
    
    @IBOutlet weak var slideIdicator: UIView!
    
    @IBOutlet weak var ColorPicker: UIPickerView!
    @IBOutlet weak var PickerLabel: UILabel!
    
    public var selectedUColor = UIColor.systemTeal
    private var colorUPicker = UIColorPickerViewController()
    /*
    let diffBackgroundColors = ["Bleu clair - Default".localized(),
                                "Cyan".localized(),
                                "Rouge".localized(),
                                "Vert".localized(),
                                "Jaune".localized(),
                                "Violet".localized(),
                                "Saumon".localized(),
                                "Gris".localized(),
                                "Blanc".localized()]
     
    let backgroundColorsList = [UIColor(hexString: "#ACD9EC", alpha: 1),
                                UIColor(hexString: "#01BEB8", alpha: 1),
                                UIColor(hexString: "#B4141E", alpha: 1),
                                UIColor(hexString: "#67B75E", alpha: 1),
                                UIColor(hexString: "#F8BB00", alpha: 1),
                                UIColor(hexString: "#BE5FCE", alpha: 1),
                                UIColor(hexString: "#F63C61", alpha: 1),
                                UIColor(hexString: "#6A6A6B", alpha: 1),
                                UIColor(hexString: "#FFFFFA", alpha: 1)]
    
    let buttonsColorsList = [UIColor(hexString: "#ADD1EF", alpha: 1),
                             UIColor(hexString: "#018FB8", alpha: 1),
                             UIColor(hexString: "#87141E", alpha: 1),
                             UIColor(hexString: "#409E5E", alpha: 1),
                             UIColor(hexString: "#E6A518", alpha: 1),
                             UIColor(hexString: "#B645CE", alpha: 1),
                             UIColor(hexString: "#DB2445", alpha: 1),
                             UIColor(hexString: "#979797", alpha: 1),
                             UIColor(hexString: "#E6E6E6", alpha: 1)]
    */
    
    var selectedColor = ""
    var selectedColorValue: UIColor = .clear
    
    var savedrow = UserDefaults.standard.object(forKey: "row") as? Int
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(panGestureRecognizerAction))
        view.addGestureRecognizer(panGesture)
        
        customColorButton.RoundCorners(.allCorners, radius: 10)
        customColorButton.backgroundColor = .systemGray5
        customColorButton.setImage(UIImage.init(systemName: "plus"), for: .normal)
        customColorButton.tintColor = .darkGray
        
        customColorButton.isEnabled = false
        customColorButton.alpha = 0
        
        slideIdicator.roundCorners(.allCorners, radius: 10)
        
        if savedrow != nil {
            ColorPicker.selectRow(savedrow!, inComponent: 0, animated: true)
        }
        
        if UserDefaults.standard.object(forKey: "row") as? Int != nil {
            print(savedrow!)
            selectedColor = ColorList.diffBackgroundColors[savedrow!]
            selectedColorValue = ColorList.backgroundColorsList[savedrow!]
        } else {
            print("nil row")
            selectedColor = ColorList.diffBackgroundColors[0]
            selectedColorValue = ColorList.backgroundColorsList[0]
        }
        PickerLabel.text = selectedColor
    }
    
    override func viewDidLayoutSubviews() {
        if !hasSetPointOrigin {
            hasSetPointOrigin = true
            pointOrigin = self.view.frame.origin
        }
    }
    
    override var prefersHomeIndicatorAutoHidden: Bool {
        return true
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
    
    @IBAction func customButtonClicked(_ sender: Any) {
        selectColor()
    }
    
    public func selectColor() {
        colorUPicker.supportsAlpha = false
        colorUPicker.selectedColor = selectedUColor
        
        weak var pvc = self.presentingViewController

        self.dismiss(animated: true, completion: { [self] in
            pvc?.present(colorUPicker, animated: true, completion: nil)
        })
    }
    
    private func setupBarButton() {
        let pickedColorAction = UIAction(title: "choosColor") {_ in
            self.selectColor()
        }
        
        let pickColorBarButton = UIBarButtonItem(image: UIImage(systemName: "eyedropper"), primaryAction: pickedColorAction)
        
        navigationItem.rightBarButtonItem = pickColorBarButton
    }
    
}

extension OverlayView: UIPickerViewDelegate, UIPickerViewDataSource {

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return ColorList.diffBackgroundColors.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return ColorList.diffBackgroundColors[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        if selectedColor != ColorList.diffBackgroundColors[row] {
            Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false) { (t) in
                self.dismiss(animated: true, completion: nil)
            }
            
            selectedColor = ColorList.diffBackgroundColors[row]
            selectedColorValue = ColorList.backgroundColorsList[row]
            
            PickerLabel.text = selectedColor
            
            print(selectedColor, ColorList.diffBackgroundColors[row])
            
            UserDefaults.standard.set(row, forKey: "row")
            
            delegate.passDataColor(newColor: ColorList.backgroundColorsList[row])
        }
    }
}

@available(iOS 14.0, *)
extension OverlayView: UIColorPickerViewControllerDelegate {
    func colorPickerViewControllerDidSelectColor(_ viewController: UIColorPickerViewController) {
        selectedUColor = viewController.selectedColor
        
        UserDefaults.standard.setValue(true, forKey: "isColorCustomBG")
        UserDefaults.standard.setColor(color: selectedUColor, forKey: "CustomColorBG")
    }
    
    func colorPickerViewControllerDidFinish(_ viewController: UIColorPickerViewController) {
        print("Choisis")
    }
    
}

extension UIColor {
    convenience init(hexString: String, alpha: CGFloat) {
        let hexString: String = hexString.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        let scanner = Scanner(string: hexString)
        if (hexString.hasPrefix("#")) {
            scanner.scanLocation = 1
        }
        var color: UInt32 = 0
        scanner.scanHexInt32(&color)
        let mask = 0x000000FF
        let r = Int(color >> 16) & mask
        let g = Int(color >> 8) & mask
        let b = Int(color) & mask
        let red   = CGFloat(r) / 255.0
        let green = CGFloat(g) / 255.0
        let blue  = CGFloat(b) / 255.0
        self.init(red:red, green:green, blue:blue, alpha:alpha)
    }
    func toHexString() -> String {
        var r:CGFloat = 0
        var g:CGFloat = 0
        var b:CGFloat = 0
        var a:CGFloat = 0
        getRed(&r, green: &g, blue: &b, alpha: &a)
        let rgb:Int = (Int)(r*255)<<16 | (Int)(g*255)<<8 | (Int)(b*255)<<0
        return String(format:"#%06x", rgb)
    }
}

//ACD9EC = default BGColor

//
//  deleteAddViewController.swift
//  EggTimer
//
//  Created by Maxence Gama on 06/11/2020.
//

//  code: Utvu-G95O-K7hf
//  test-code : Uk4f-Rg1P-Hu7c

import UIKit
import NotificationBannerSwift
import SwiftEntryKit

class deleteAddViewController: UIViewController {

    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var validateButton: UIButton!
    @IBOutlet var textFieldTopAnchor: NSLayoutConstraint!
    
    var code = "Utvu-G95O-K7hf"
    var testcode = "Uk4f-Rg1P-Hu7c"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTextField()
        configureTapGesture()
        
        if UserDefaults.standard.object(forKey: "isAddDelted") as? Bool != nil {
            if UserDefaults.standard.object(forKey: "isAddDelted") as? Bool == true {
                print("ads disabled")
                label.text = "Les pubs sont déjà supprimées".localized()
                validateButton.alpha = 0
                textField.alpha = 0
                validateButton.isEnabled = false
                textField.isEnabled = false
            } else {
                print("ads not disabled")
                label.text = "Saisir le code".localized()
            }
        } else {
            print("ads not disabled")
            label.text = "Saisir le code".localized()
        }
        
        label.tintColor = .none
        textField.adjustsFontSizeToFitWidth = true
        textField.autocorrectionType = .no
        textField.autocapitalizationType = .none
        textField.borderStyle = .roundedRect
        textField.clearsOnBeginEditing = true
        textField.clearButtonMode = .always
        
        NotificationCenter.default.addObserver(self, selector: #selector(adjustForKeyboard(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
    }
    
    @objc func adjustForKeyboard(_ notification: Notification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            self.textFieldTopAnchor.constant = keyboardSize.height+25
            UIView.animate(withDuration: 0.3, animations: { [self] in
                self.view.layoutIfNeeded()
            })
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        textField.becomeFirstResponder()
    }
    
    @IBAction func validateButton(_ sender: UIButton) {
        if textField.text == code {
            label.text = "Code bon".localized()
            label.textColor = .green
            handleTap()
            validateButton.alpha = 0
            textField.alpha = 0
            validateButton.isEnabled = false
            textField.isEnabled = false
            
            let isAddEnabled = true
            UserDefaults.standard.set(isAddEnabled, forKey: "isAddDelted")
            
            Timer.scheduledTimer(withTimeInterval: 1, repeats: false) { (t) in
                self.label.text = "Pubs supprimées".localized()
                self.label.tintColor = .none
                self.handleShowPopUp()
                self.navigationController?.popViewController(animated: true)
                NotificationCenter.default.post(name: Notification.Name(rawValue: "deleteAddsNotif"), object: nil)

                let generator = UINotificationFeedbackGenerator()
                generator.notificationOccurred(.success)
            }
            
        } else if textField.text == testcode {
            
            validateButton.isEnabled = false
            
            Timer.scheduledTimer(withTimeInterval: 1, repeats: false) { (t) in
                self.label.text = "Pubs supprimées".localized()
                self.label.tintColor = .none
                self.handleShowPopUp()
                self.navigationController?.popViewController(animated: true)
                NotificationCenter.default.post(name: Notification.Name(rawValue: "deleteAddsNotif"), object: nil)
                
                let generator = UINotificationFeedbackGenerator()
                generator.notificationOccurred(.success)
            }
        } else {
            label.text = "Mauvais code".localized()
            textField.text = ""
            let generator = UINotificationFeedbackGenerator()
            generator.notificationOccurred(.error)
            UIView.animate(withDuration: 0.3, delay: 1, animations: { [self] in
                label.alpha = 0
            }, completion: { [self] _ in
                label.text = "Réessayez".localized()
                UIView.animate(withDuration: 0.5, animations: { [self] in
                    label.alpha = 1
                }, completion: { [self] _ in
                    textField.becomeFirstResponder()
                })
            })
            label.textColor = .red
            handleTap()
        }
    }
    
    func configureTapGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(deleteAddViewController.handleTap))
        view.addGestureRecognizer(tapGesture)
    }
    
    @objc func handleTap() {
        view.endEditing(true)
    }
    
    func configureTextField() {
        textField.delegate = self
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        print("Editing began")
    }
    
    // MARK: -Popup intialization
    
    func setupAttributes() -> EKAttributes {
        var attributes = EKAttributes.bottomFloat
        attributes.displayDuration = .infinity
        attributes.screenBackground = .color(color: .init(light: UIColor(white: 100.0/255.0, alpha: 0.3), dark: UIColor(white: 50.0/255.0, alpha: 0.3)))
        attributes.shadow = .active(
            with: .init(
                color: .black,
                opacity: 0.3,
                radius: 8
            )
        )
        
        attributes.entryBackground = .color(color: EKColor(red: 0, green: 97, blue: 121))
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
        
        let image = UIImage(named: "megaphone")!.withRenderingMode(.alwaysTemplate)
        let title = "Pubs supprimées".localized()
        let description = "Les pubs ont été supprimées.".localized()
        
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
                    color: .white
                )
            ),
            backgroundColor: .init(UIColor(hexString: "#4C94AD", alpha: 1)),
            highlightedBackgroundColor: .white
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

extension deleteAddViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

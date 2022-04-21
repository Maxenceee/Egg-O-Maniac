//
//  SettingsViewController.swift
//  EggTimer
//
//  Created by Maxence Gama on 07/10/2020.
//

import UIKit
import SwiftEntryKit
import IntentsUI


@available(iOS 14.0, *)
class SettingsViewController: UIViewController, INUIAddVoiceShortcutViewControllerDelegate {
    
    func addVoiceShortcutViewController(_ controller: INUIAddVoiceShortcutViewController, didFinishWith voiceShortcut: INVoiceShortcut?, error: Error?) {
        addSiriShortcutButton.removeFromSuperview()
        controller.dismiss(animated: true, completion: nil)
    }
    
    func addVoiceShortcutViewControllerDidCancel(_ controller: INUIAddVoiceShortcutViewController) {
        controller.dismiss(animated: true, completion: nil)
    }
    
    var alphaDisplayButtons = 0
    public var selectedColor = UIColor.systemTeal
    private var colorPicker = UIColorPickerViewController()
    
    var firtSelected = false
    var secondSelected = false
    
    var firstColor: UIColor = UIColor.clear
    var secondColor: UIColor = UIColor.clear
    var firstColorAsChanged = false
    var secondColorAsChnaged = false
    
    var backgroundSettingSelected = false
    
    static var shadowOpacity = 0.3
    static var shadowHeight = 2
    static var shadowRadius = 3
    
    let addSiriShortcutButton = INUIAddVoiceShortcutButton(style: .blackOutline)

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
    
    let buttonsColorsList = [UIColor(hexString: "#6fc1ed", alpha: 1),//default
                             UIColor(hexString: "#00dcb8", alpha: 1),//cyan
                             UIColor(hexString: "#971e07", alpha: 1),//rouge
                             UIColor(hexString: "#409E5E", alpha: 1),//vert
                             UIColor(hexString: "#E6A518", alpha: 1),//jaune
                             UIColor(hexString: "#B645CE", alpha: 1),//violet
                             UIColor(hexString: "#fbaa99", alpha: 1),//saumon
                             UIColor(hexString: "#838383", alpha: 1),//gris
                             UIColor(hexString: "#E6E6E6", alpha: 1)]//blanc
    */
    
    func DisplaySettingsButtonsAlpha() {
        languageButton.alpha = 0
        ColorDiplayButton.alpha = 0
        backgroungSettingButton.alpha = 0
        aboutButton.alpha = 0
        healthSyncButton.alpha = 0
        addSiriShortcutButton.alpha = 0
    }
    
    var OrDescription =
    """
    Autorisez le partage de données avec Santé. Seules des informations nutritives seront partagées.
    """.localized()
    var btnText = "Syncroniser".localized()
    
    
    var didOnce = false
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if UserDefaults.standard.object(forKey: "didHealthSyncDone") as? Bool != nil {
            if UserDefaults.standard.object(forKey: "didHealthSyncDone") as? Bool == true {
                self.OrDescription =
                    """
                    L'application partage déjà ses données Santé. Vous pouvez modifier les permitions directement dans l'application Santé.
                    """.localized()
                self.btnText = "Fermer".localized()
            }
        }
        
        //updateButtonColor()
        
        if !didOnce {
            
            UIView.animate(withDuration: 0.0, animations: {
                self.closeWheelTop.frame.origin.y -= 20
                self.reglageLabelOnTop.frame.origin.x -= 150
            }, completion: nil)
            
            //Setup placement
            UIButton.animate(withDuration: 0.0, delay: 0.0, options: .curveEaseInOut, animations: {
                self.languageButton.frame.origin.y += 330;
                self.ColorDiplayButton.frame.origin.y += 330;
                self.backgroungSettingButton.frame.origin.y += 330;
                self.aboutButton.frame.origin.y += 330;
                self.healthSyncButton.frame.origin.y += 330
                self.addSiriShortcutButton.frame.origin.y += 330;
                }, completion: nil)
            
            let startDelay = 0.1
            //Open up animation
            UIButton.animate(withDuration: 0.3, delay: startDelay, options: .curveEaseInOut, animations: {
                self.languageButton.frame.origin.y -= 330;
                self.languageButton.alpha = 1
                }, completion: nil)
            
            UIButton.animate(withDuration: 0.3, delay: startDelay + 0.05, options: .curveEaseInOut, animations: {
                self.backgroungSettingButton.frame.origin.y -= 330;
                self.backgroungSettingButton.alpha = 1
                }, completion: nil)
            
            UIButton.animate(withDuration: 0.3, delay: startDelay + 0.1, options: .curveEaseInOut, animations: {
                self.ColorDiplayButton.frame.origin.y -= 330;
                self.ColorDiplayButton.alpha = 1
                }, completion: nil)
            
            UIButton.animate(withDuration: 0.3, delay: startDelay + 0.15, options: .curveEaseInOut, animations: {
                self.healthSyncButton.frame.origin.y -= 330;
                self.healthSyncButton.alpha = 1
                }, completion: nil)
            
            UIButton.animate(withDuration: 0.3, delay: startDelay + 0.2, options: .curveEaseInOut, animations: {
                self.aboutButton.frame.origin.y -= 330;
                self.aboutButton.alpha = 1
                }, completion: nil)
            
            UILabel.animate(withDuration: 0.3, delay: startDelay + 0.25, animations: {
                self.addSiriShortcutButton.frame.origin.y -= 330;
                self.addSiriShortcutButton.alpha = 1
            }, completion: nil)
            
            UILabel.animate(withDuration: 0.2, delay: 0.3, animations: {
                self.reglageLabelOnTop.frame.origin.x += 150;
                self.reglageLabelOnTop.alpha = 1
            }, completion: nil)
            
            UIView.animate(withDuration: 0.2, delay: 1.0, usingSpringWithDamping: 0.4, initialSpringVelocity: 1, options: .curveEaseInOut, animations: {
                self.closeWheelTop.alpha = 1;
                self.closeWheelTop.frame.origin.y += 20
            }, completion: nil)

            didOnce = true
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(panGestureRecognizerAction(sender:)))
        view.addGestureRecognizer(panGesture)
        
        addSiriShortcutButton.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(reglageLabelOnTop)
        view.addSubview(closeWheelTop)
        view.addSubview(buttonsStackView)
//        buttonsStackView.addArrangedSubview(languageButton)
        buttonsStackView.addArrangedSubview(backgroungSettingButton)
        buttonsStackView.addArrangedSubview(ColorDiplayButton)
        buttonsStackView.addArrangedSubview(healthSyncButton)
        buttonsStackView.addArrangedSubview(aboutButton)
//        view.addSubview(addSiriShortcutButton)
        
        addSiriShortcutButton.addTarget(self, action: #selector(addToSiri(_:)), for: .touchUpInside)
        
        setuplayout()
        
        updateButtonColor()
        
        DisplaySettingsButtonsAlpha()
        reglageLabelOnTop.alpha = 0
        closeWheelTop.alpha = 0
        
        ColorDiplayButton.isEnabled = true
        languageButton.isEnabled = true
        aboutButton.isEnabled = true
        healthSyncButton.isEnabled = true
        
        setupBarButton()
        
        healthStore = HealthStore()
    }
    
    @objc func addToSiri(_ sender: Any) {
        let activity = NSUserActivity(activityType: "Gama-Maxence-Egg-O-Maniac.softTime")
        activity.title = "Lancer un minuteur pour la cuisson d'oeufs à la coque.".localized()
        activity.isEligibleForSearch = true
        activity.isEligibleForPrediction = true
        activity.suggestedInvocationPhrase = "Lance un minuteur pour cuir des oeufs mollet.".localized()
        
        self.userActivity = activity
        self.userActivity?.becomeCurrent()
        
        let shortCut = INShortcut(userActivity: activity)
        let viewcontroller = INUIAddVoiceShortcutViewController(shortcut: shortCut)
        viewcontroller.delegate = self
        viewcontroller.modalPresentationStyle = .formSheet
        present(viewcontroller, animated: true, completion: nil)
    }
    
    public func createUserActivity() {
        let activity = NSUserActivity(activityType: "Gama-Maxence-Egg-O-Maniac.softTime")
        activity.title = "Lancer un minuteur pour la cuisson d'oeufs à la coque.".localized()
        activity.isEligibleForSearch = true
        activity.isEligibleForPrediction = true
        
        self.userActivity = activity
        self.userActivity?.becomeCurrent()
    }
    
    var hasSetPointOrigin = false
    var pointOrigin: CGPoint?

    override func viewDidLayoutSubviews() {
        if !hasSetPointOrigin {
            hasSetPointOrigin = true
            pointOrigin = self.view.frame.origin
        }
    }
    
    @objc func panGestureRecognizerAction(sender: UIPanGestureRecognizer) {
        let translation = sender.translation(in: view)
        
        if sender.state == .ended {
            let dragVelocity = sender.velocity(in: view)
            if translation.y >= 0 {
                if dragVelocity.y >= 1300 {
                    self.dismiss(animated: true, completion: nil)
                }
            }
        }
    }
    
    let reglageLabelOnTop: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Comfortaa", size: 25)
        label.text = "Réglages".localized()
        label.textColor = .black
        label.textAlignment = .center
        label.dropShadow()
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    let closeWheelTop: UIButton = {
        let button = UIButton(type: UIButton.ButtonType.custom) as UIButton
        let bgImage = UIImage(systemName: "xmark") as UIImage?
        button.setBackgroundImage(bgImage, for: .normal)
        button.tintColor = .black
        button.contentMode = .scaleAspectFit
        button.addTarget(self, action: #selector(closeButton), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let buttonsStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.distribution = .fillEqually
        stackView.contentMode = .scaleAspectFit
        stackView.spacing = 10
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    let languageButton: UIButton = {
        let button = UIButton(type: UIButton.ButtonType.custom) as UIButton
        let attributedText = NSMutableAttributedString(string: "   Langue".localized(), attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 15)])
        
        button.contentHorizontalAlignment = .left
        button.setTitleColor(.black, for: .normal)
        button.setAttributedTitle(attributedText, for: .normal)
        button.addTarget(self, action: #selector(languageButtton), for: .touchUpInside)
        button.contentMode = .scaleToFill
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .systemTeal
        button.layer.cornerRadius = 25
        button.dropShadow(.black, opacity: Float(shadowOpacity), width: 0, height: CGFloat(shadowHeight), radius: CGFloat(shadowRadius))
        return button
    }()
    
    let ColorDiplayButton: UIButton = {
        let button = UIButton(type: UIButton.ButtonType.custom) as UIButton
        let attributedText = NSMutableAttributedString(string: "   Couleurs du minuteur".localized(), attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 15)])
        
        button.contentHorizontalAlignment = .left
        button.setTitleColor(.black, for: .normal)
        button.setAttributedTitle(attributedText, for: .normal)
        button.addTarget(self, action: #selector(ColorDisplayButton), for: .touchUpInside)
        button.contentMode = .scaleToFill
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .systemTeal
        button.layer.cornerRadius = 25
        button.dropShadow(.black, opacity: Float(shadowOpacity), width: 0, height: CGFloat(shadowHeight), radius: CGFloat(shadowRadius))
        return button
    }()
    
    let backgroungSettingButton: UIButton = {
        let button = UIButton(type: UIButton.ButtonType.custom) as UIButton
        let attributedText = NSMutableAttributedString(string: "   Couleur d'arrière plan".localized(), attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 15)])
        
        button.contentHorizontalAlignment = .left
        button.setTitleColor(.black, for: .normal)
        button.setAttributedTitle(attributedText, for: .normal)
        button.addTarget(self, action: #selector(onButton), for: .touchUpInside)
        button.contentMode = .scaleToFill
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .systemTeal
        button.layer.cornerRadius = 25
        button.dropShadow(.black, opacity: Float(shadowOpacity), width: 0, height: CGFloat(shadowHeight), radius: CGFloat(shadowRadius))
        return button
    }()
    
    let healthSyncButton: UIButton = {
        let button = UIButton(type: UIButton.ButtonType.custom) as UIButton
        let attributedText = NSMutableAttributedString(string: "   Synchroniser avec Santé".localized(), attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 15)])
        
        button.contentHorizontalAlignment = .left
        button.setTitleColor(.black, for: .normal)
        button.setAttributedTitle(attributedText, for: .normal)
        button.addTarget(self, action: #selector(syncHealth), for: .touchUpInside)
        button.contentMode = .scaleToFill
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .systemTeal
        button.layer.cornerRadius = 25
        button.dropShadow(.black, opacity: Float(shadowOpacity), width: 0, height: CGFloat(shadowHeight), radius: CGFloat(shadowRadius))
        return button
    }()
    
    let aboutButton: UIButton = {
        let button = UIButton(type: UIButton.ButtonType.custom) as UIButton
        let attributedText = NSMutableAttributedString(string: "   À propos".localized(), attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 15)])
        
        button.contentHorizontalAlignment = .left
        button.setTitleColor(.black, for: .normal)
        button.setAttributedTitle(attributedText, for: .normal)
        button.addTarget(self, action: #selector(openAboutView), for: .touchUpInside)
        button.contentMode = .scaleToFill
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .systemTeal
        button.layer.cornerRadius = 25
        button.dropShadow(.black, opacity: Float(shadowOpacity), width: 0, height: CGFloat(shadowHeight), radius: CGFloat(shadowRadius))
        return button
    }()
    
    @objc func closeButton(_ sender: AnyObject) {
        
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(.warning)
        
        let theButton = sender as! UIButton
        
        let bounds = theButton.bounds
        
        UIView.animate(withDuration: 0.1, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 50, options: .curveEaseInOut, animations: {
            theButton.bounds = CGRect(x: bounds.origin.x - 50, y: bounds.origin.y, width: bounds.size.width + 150, height: bounds.size.height); self.DisplaySettingsButtonsAlpha()
        }) { (succes: Bool) in
            if succes {
                self.dismiss(animated: true)
            }
        }
    }
    
    @objc func openAboutView(_ sender: Any) {
        let storyboard = UIStoryboard(name: "AboutStoryboard", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "starting_vc")
        self.present(vc, animated: true)
    }
    
    @objc func languageButtton(_ sender: Any) {
        guard let ivc = storyboard?.instantiateViewController(identifier: "language_vc") as? LanguageViewController else {
            return
        }
        self.present(ivc, animated: true)
    }
    
    @objc func ColorDisplayButton(_ sender: Any) {
        showMiraclePB()
    }
    
    @objc func showMiraclePB() {
        let slideVCs = OverlayPogressBar()
        slideVCs.modalPresentationStyle = .custom
        slideVCs.transitioningDelegate = self
        self.present(slideVCs, animated: true, completion: nil)
    }
    
    @objc func showMiracle() {
        let slide = OverlayView()
        slide.modalPresentationStyle = .custom
        slide.transitioningDelegate = self
        slide.delegate = self
        self.present(slide, animated: true, completion: nil)
    }
    
    @objc func onButton(_ sender: Any) {
        showMiracle()
    }
    
    private var healthStore: HealthStore?
    
    @objc func syncHealth(_ sender: Any) {
        handleShowPopUp()
    }
    
    func requestHealthSync() {
        if let healthStore = healthStore {
            healthStore.requestAuthorization { succes in
                if succes {
                    let didHealthSyncDone = true
                    UserDefaults.standard.setValue(didHealthSyncDone, forKey: "didHealthSyncDone")
                    print("sync requested")
                    self.OrDescription =
                        """
                        L'application partage déjà ses données Santé. \
                        Vous pouvez modifier les permitions directement dans l'application Santé.
                        """
                    self.btnText = "Fermer"
                }
            }
        }
    }
    
    /*
    @IBAction func aboutBUtton(_ sender: UIButton) {
        guard let vc = storyboard?.instantiateViewController(identifier: "about_vc") as? aboutTableViewController else {
            return
        }
        
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true)
    }*/
    
    public func selectColor() {
        colorPicker.supportsAlpha = true
        colorPicker.selectedColor = selectedColor
        present(colorPicker, animated: true)
    }
    
    private func setupBarButton() {
        let pickedColorAction = UIAction(title: "Coisir Une Couleur") {_ in
            self.selectColor()
        }
        
        let pickColorBarButton = UIBarButtonItem(image: UIImage(systemName: "eyedropper"), primaryAction: pickedColorAction)
        
        navigationItem.rightBarButtonItem = pickColorBarButton
    }
    
    func updateButtonColor() {
        let newRow = UserDefaults.standard.object(forKey: "row") as? Int
        
        if newRow != nil && newRow == 44 {
            
        } else {
            if ((UserDefaults.standard.object(forKey: "row") as? Int) != nil) {
                view.backgroundColor = ColorList.backgroundColorsList[newRow!]
                languageButton.backgroundColor = ColorList.backButtonsColorsList[newRow!]
                ColorDiplayButton.backgroundColor = ColorList.backButtonsColorsList[newRow!]
                backgroungSettingButton.backgroundColor = ColorList.backButtonsColorsList[newRow!]
                aboutButton.backgroundColor = ColorList.backButtonsColorsList[newRow!]
                healthSyncButton.backgroundColor = ColorList.backButtonsColorsList[newRow!]
            } else {
                view.backgroundColor = ColorList.backgroundColorsList[0]
                ColorDiplayButton.backgroundColor = ColorList.backButtonsColorsList[0]
                backgroungSettingButton.backgroundColor = ColorList.backButtonsColorsList[0]
                aboutButton.backgroundColor = ColorList.backButtonsColorsList[0]
                healthSyncButton.backgroundColor = ColorList.backButtonsColorsList[0]
            }
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
        
        attributes.entryBackground = .color(color: EKColor(red: 28, green: 88, blue: 122))
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
        
        let image = UIImage(named: "heart-vitals")!.withRenderingMode(.alwaysTemplate)
        let title = "Syncronisation avec Santé".localized()
        let description = OrDescription
        
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
                text: btnText,
                style: .init(
                    font: UIFont.systemFont(ofSize: 16),
                    color: .white
                )
            ),
            backgroundColor: .init(UIColor(hexString: "#338FAB", alpha: 1)),
            highlightedBackgroundColor: .clear
        )
        
        let message = EKPopUpMessage(themeImage: themeImage, title: titleLabel, description: descriptionLabel, button: button) {
            self.requestHealthSync()
            SwiftEntryKit.dismiss()
        }
        return message
    }
    
    @objc func handleShowPopUp() {
        SwiftEntryKit.display(entry: MyPopUpView(with: setupMessage()), using: setupAttributes())
    }
    
    func setuplayout() {
        reglageLabelOnTop.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        reglageLabelOnTop.topAnchor.constraint(equalTo: view.topAnchor, constant: view.frame.height/17.9).isActive = true
        reglageLabelOnTop.heightAnchor.constraint(equalToConstant: 30).isActive = true
        reglageLabelOnTop.widthAnchor.constraint(equalToConstant: 150).isActive = true
        
        closeWheelTop.topAnchor.constraint(equalTo: view.topAnchor, constant: view.frame.height/17.9).isActive = true
        closeWheelTop.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20).isActive = true
        closeWheelTop.heightAnchor.constraint(equalToConstant: 25).isActive = true
        closeWheelTop.widthAnchor.constraint(equalToConstant: 25).isActive = true
        
        buttonsStackView.topAnchor.constraint(equalTo: view.topAnchor, constant: view.frame.height/4.48).isActive = true
        buttonsStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
        buttonsStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20).isActive = true
        buttonsStackView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: UIScreen.main.bounds.height > 750 ? -view.frame.height/2.4  : -view.frame.height/3.1).isActive = true
        
//        languageButton.heightAnchor.constraint(equalToConstant: buttonsStackView.frame.height/5 - 40).isActive = true
//        languageButton.leadingAnchor.constraint(equalTo: buttonsStackView.leadingAnchor).isActive = true
//        languageButton.trailingAnchor.constraint(equalTo: buttonsStackView.trailingAnchor).isActive = true

//        ColorDiplayButton.heightAnchor.constraint(equalToConstant: buttonsStackView.frame.height/5 - 40).isActive = true
        ColorDiplayButton.leadingAnchor.constraint(equalTo: buttonsStackView.leadingAnchor).isActive = true
        ColorDiplayButton.trailingAnchor.constraint(equalTo: buttonsStackView.trailingAnchor).isActive = true

//        backgroungSettingButton.heightAnchor.constraint(equalToConstant: buttonsStackView.frame.height/5 - 40).isActive = true
        backgroungSettingButton.leadingAnchor.constraint(equalTo: buttonsStackView.leadingAnchor).isActive = true
        backgroungSettingButton.trailingAnchor.constraint(equalTo: buttonsStackView.trailingAnchor).isActive = true

//        healthSyncButton.heightAnchor.constraint(equalToConstant: buttonsStackView.frame.height/5 - 40).isActive = true
        healthSyncButton.leadingAnchor.constraint(equalTo: buttonsStackView.leadingAnchor).isActive = true
        healthSyncButton.trailingAnchor.constraint(equalTo: buttonsStackView.trailingAnchor).isActive = true

//        aboutButton.heightAnchor.constraint(equalToConstant: buttonsStackView.frame.height/5 - 40).isActive = true
        aboutButton.leadingAnchor.constraint(equalTo: buttonsStackView.leadingAnchor).isActive = true
        aboutButton.trailingAnchor.constraint(equalTo: buttonsStackView.trailingAnchor).isActive = true
        
//        addSiriShortcutButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
//        addSiriShortcutButton.widthAnchor.constraint(equalToConstant: 150).isActive = true
//        addSiriShortcutButton.topAnchor.constraint(equalTo: buttonsStackView.bottomAnchor, constant: 10).isActive = true
//        addSiriShortcutButton.leadingAnchor.constraint(equalTo: buttonsStackView.leadingAnchor).isActive = true
    }

}

/*
@available(iOS 14.0, *)
extension SettingsViewController: UIColorPickerViewControllerDelegate {
    func colorPickerViewControllerDidSelectColor(_ viewController: UIColorPickerViewController) {
        selectedColor = viewController.selectedColor
        
        if backgroundSettingSelected {
            //changeButtonsColor()
        } else {
            if self.firtSelected {
                self.delegate.passTimerColorData(newColor: selectedColor, name: "first")
            } else if self.secondSelected {
                self.delegate.passTimerColorData(newColor: selectedColor, name: "second")
            }
            
        }
        
    }
    
    func colorPickerViewControllerDidFinish(_ viewController: UIColorPickerViewController) {
        backgroundSettingSelected = false
        print("Choisis")
    }
    
}*/

extension SettingsViewController: UIViewControllerTransitioningDelegate {
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        PresentationController(presentedViewController: presented, presenting: presenting)
    }
}

extension SettingsViewController: passColorToVCs {
    func passDataColor(newColor: UIColor) {
        view.backgroundColor = newColor
        updateButtonColor()
    } 
}

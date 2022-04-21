//
//  ReportViewController.swift
//  Egg-O-Maniac
//
//  Created by Maxence Gama on 27/11/2020.
//

import UIKit
import Combine
import Loaf
import MBProgressHUD

class ReportViewController: UIViewController {
    
    @IBOutlet weak var objectTextField: UITextView!
    @IBOutlet weak var subjectTextField: UITextView!
    @IBOutlet weak var sendButton: UIButton!
    
    @Published private var feedbackCategory: String?
    @Published private var comments: String?
    
    private var subscriber: AnyCancellable?
    
    private var emailManager = EmailManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        sendButton.layer.cornerRadius = 25
        subjectTextField.layer.borderWidth = 1
        objectTextField.layer.borderWidth = 1
        subjectTextField.layer.cornerRadius = 10
        objectTextField.layer.cornerRadius = 10
        subjectTextField.layer.borderColor = UIColor.darkGray.cgColor
        objectTextField.layer.borderColor = UIColor.darkGray.cgColor
        
        setupGestures()
        /*
        observeForm()
        
        sendButton.isEnabled = false
        sendButton.alpha = 0.7*/
    }
    
    private func clearForm() {
        subjectTextField.text = ""
        objectTextField.text = ""
        feedbackCategory = nil
        comments = nil
    }
    
    private func observeForm() {
        subscriber = Publishers.CombineLatest($feedbackCategory, $comments).sink { [unowned self] (category, comments) in
            let isFormCompleted = (category?.isEmpty == false) && (comments?.isEmpty == false)
            self.sendButton.isEnabled = isFormCompleted
            self.sendButton.alpha = 1
        }
    }
    
    private func setupGestures() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tapGesture)
    }
    
    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }
    
    @IBAction func sendButton(_ sender: Any) {
        if subjectTextField.text != "" && objectTextField.text != "" {
            feedbackCategory = subjectTextField.text
            comments = objectTextField.text
            
            guard let category = self.feedbackCategory,
                let comments = self.comments else { return }
            
            let form = FeedbackForm(category: category, comments: comments)
            
            MBProgressHUD.showAdded(to: view, animated: true)
            
            emailManager.send(form: form) { [unowned self] (result) in
                
                DispatchQueue.main.async {
                    MBProgressHUD.hide(for: self.view, animated: true)
                    self.clearForm()
                    switch result {
                    case .success:
                        Loaf("Votre signalement a été reçu avec succes.", state: .success, sender: self).show()
                        Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false) { (t) in
                            self.navigationController?.popViewController(animated: true)
                        }
                    case .failure(let error):
                        Loaf(error.localizedDescription, state: .error, sender: self).show()
                    }
                }
            }
        } else {
            Loaf("Vous devez remplir tous les champs.", state: .error, sender: self).show()
        }
        
    }
    
}

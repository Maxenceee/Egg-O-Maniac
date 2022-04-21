//
//  LoadingButton.swift
//  Egg-O-Maniac
//
//  Created by Maxence Gama on 30/11/2020.
//

import UIKit

class LoadingButton: UIButton {
    
    var activityIndicator: UIActivityIndicatorView!
    
    @IBInspectable
    let activityIndicatorColor: UIColor = .lightGray

    func showLoading() {
        if (activityIndicator == nil) {
            activityIndicator = createActivityIndicator()
        }
        alpha = 0.8
        isEnabled = false
        showSpinning()
    }
    
    func hideLoading() {
        alpha = 1.0
        isEnabled = true
        activityIndicator.stopAnimating()
    }
    
    private func createActivityIndicator() -> UIActivityIndicatorView {
        let activityIndicator = UIActivityIndicatorView()
        activityIndicator.hidesWhenStopped = true
        activityIndicator.color = activityIndicatorColor
        return activityIndicator
    }
    
    private func showSpinning() {
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(activityIndicator)
        positionActivityIndicatorInButton()
        activityIndicator.startAnimating()
    }
    
    private func positionActivityIndicatorInButton() {
        let xCenterConstraint = NSLayoutConstraint(item: self,
                                                   attribute: .trailing,
                                                   relatedBy: .equal,
                                                   toItem: activityIndicator,
                                                   attribute: .trailing,
                                                   multiplier: 1, constant: 16)
        self.addConstraint(xCenterConstraint)
        
        let yCenterConstraint = NSLayoutConstraint(item: self,
                                                   attribute: .centerY,
                                                   relatedBy: .equal,
                                                   toItem: activityIndicator,
                                                   attribute: .centerY,
                                                   multiplier: 1, constant: 0)
        self.addConstraint(yCenterConstraint)
    }
    
}

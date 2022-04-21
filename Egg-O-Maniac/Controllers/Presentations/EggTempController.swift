//
//  EggTempController.swift
//  Egg-O-Maniac
//
//  Created by Maxence Gama on 05/03/2021.
//

import UIKit

class EggTempController: UIPresentationController {
    
    let blurEffectView: UIVisualEffectView!
    var tapGestureRecognizer: UITapGestureRecognizer = UITapGestureRecognizer()

    override init(presentedViewController: UIViewController, presenting presentingViewController: UIViewController?) {
        let blurEffect = UIBlurEffect(style: .prominent)
      blurEffectView = UIVisualEffectView(effect: blurEffect)
      super.init(presentedViewController: presentedViewController, presenting: presentingViewController)
      tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissController))
      blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
      self.blurEffectView.isUserInteractionEnabled = true
      self.blurEffectView.addGestureRecognizer(tapGestureRecognizer)
    }

    override var frameOfPresentedViewInContainerView: CGRect {
        CGRect(origin: CGPoint(x: 0, y: self.containerView!.frame.height * 0.5 - (UIScreen.main.bounds.height < 750 ? -20 : -100)),
               size: CGSize(width: self.containerView!.frame.width, height: self.containerView!.frame.height *
                            0.5 - (UIScreen.main.bounds.height < 750 ? 0 : 100)))
    }

    override func presentationTransitionWillBegin() {
      self.blurEffectView.alpha = 0
      self.containerView?.addSubview(blurEffectView)
      self.presentedViewController.transitionCoordinator?.animate(alongsideTransition: { (UIViewControllerTransitionCoordinatorContext) in
        self.blurEffectView.alpha = 1
      }, completion: { (UIViewControllerTransitionCoordinatorContext) in })
    }

    override func dismissalTransitionWillBegin() {
      self.presentedViewController.transitionCoordinator?.animate(alongsideTransition: { (UIViewControllerTransitionCoordinatorContext) in
        self.blurEffectView.alpha = 0.0
      }, completion: { (UIViewControllerTransitionCoordinatorContext) in
          self.blurEffectView.removeFromSuperview()
      })
    }

    override func containerViewWillLayoutSubviews() {
      super.containerViewWillLayoutSubviews()
      presentedView!.RoundCorners([.topLeft, .topRight], radius: 22)
    }

    override func containerViewDidLayoutSubviews() {
      super.containerViewDidLayoutSubviews()
      presentedView?.frame = frameOfPresentedViewInContainerView
      blurEffectView.frame = containerView!.bounds
    }

    @objc func dismissController(){
      self.presentedViewController.dismiss(animated: true, completion: nil)
    }
}


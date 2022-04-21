//
//  PresentationController.swift
//  SlideOverTutorial
//
//  Created by Maxence Gama on 31/10/2020.
//


import UIKit

class PresentationController: UIPresentationController {

    let blurEffectView: UIVisualEffectView!
    var tapGestureRecognizer: UITapGestureRecognizer = UITapGestureRecognizer()

    override init(presentedViewController: UIViewController, presenting presentingViewController: UIViewController?) {
      let blurEffect = UIBlurEffect(style: .light)
      blurEffectView = UIVisualEffectView(effect: blurEffect)
      super.init(presentedViewController: presentedViewController, presenting: presentingViewController)
      tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissController))
      blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
      self.blurEffectView.isUserInteractionEnabled = true
      self.blurEffectView.addGestureRecognizer(tapGestureRecognizer)
    }

    override var frameOfPresentedViewInContainerView: CGRect {
        CGRect(origin: CGPoint(x: 10, y: UIScreen.main.bounds.height < 750 ? (self.containerView!.frame.height * 0.5 - 10) : (self.containerView!.frame.height * 0.62 - 10)),
             size: CGSize(width: self.containerView!.frame.width - 20, height: UIScreen.main.bounds.height < 750 ? (self.containerView!.frame.height * 0.5) : (self.containerView!.frame.height * 0.38)))
    }

    override func presentationTransitionWillBegin() {
      self.blurEffectView.alpha = 0
      self.containerView?.addSubview(blurEffectView)
      self.presentedViewController.transitionCoordinator?.animate(alongsideTransition: { (UIViewControllerTransitionCoordinatorContext) in
        self.blurEffectView.alpha = 1.0
      }, completion: { (UIViewControllerTransitionCoordinatorContext) in })
    }

    override func dismissalTransitionWillBegin() {
      self.presentedViewController.transitionCoordinator?.animate(alongsideTransition: { (UIViewControllerTransitionCoordinatorContext) in
        self.blurEffectView.alpha = -1.0
      }, completion: { (UIViewControllerTransitionCoordinatorContext) in
          self.blurEffectView.removeFromSuperview()
      })
    }

    override func containerViewWillLayoutSubviews() {
      super.containerViewWillLayoutSubviews()
        presentedView!.roundCorners(.allCorners, radius: 40)
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

extension UIView {
    func roundCorners(_ corners: UIRectCorner, radius: CGFloat) {
      let path = UIBezierPath(roundedRect: bounds, byRoundingCorners: corners,
                              cornerRadii: CGSize(width: radius, height: radius))
      let mask = CAShapeLayer()
      mask.path = path.cgPath
      layer.mask = mask
    }
}

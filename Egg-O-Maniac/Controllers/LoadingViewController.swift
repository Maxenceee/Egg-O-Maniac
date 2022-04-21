//
//  LoadingViewController.swift
//  Egg-O-Maniac
//
//  Created by Maxence Gama on 08/03/2021.
//

import UIKit
import Lottie

class LoadingViewController: UIViewController {
    
    var animationView: AnimationView?

    override func viewDidLoad() {
        super.viewDidLoad()

        view.addSubview(animationContainer)
        
        animationView = .init(name: "EOM_Intro")
        animationView!.translatesAutoresizingMaskIntoConstraints = false
        animationView!.contentMode = .scaleAspectFit
        animationView!.loopMode = .playOnce
        animationView!.animationSpeed = 1
        animationView!.frame = animationContainer.bounds
        
        animationContainer.addSubview(animationView!)

        setupLayout()
        
        animationView?.play()
        
        guard let vc = storyboard?.instantiateViewController(identifier: "main_vc") as? ViewController else {
            return
        }
        vc.modalPresentationStyle = .fullScreen
        DispatchQueue.main.asyncAfter(deadline: .now() + 4, execute: {
            self.present(vc, animated: true, completion: nil)
         })
    }
    
    let animationContainer: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    func setupLayout() {
        animationContainer.topAnchor.constraint(equalTo: view.topAnchor, constant: 50).isActive = true
        animationContainer.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: -50).isActive = true
        animationContainer.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 50).isActive = true
        animationContainer.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -50).isActive = true
        
        animationView?.topAnchor.constraint(equalTo: animationContainer.topAnchor).isActive = true
        animationView?.bottomAnchor.constraint(equalTo: animationContainer.bottomAnchor).isActive = true
        animationView?.trailingAnchor.constraint(equalTo: animationContainer.trailingAnchor).isActive = true
        animationView?.leadingAnchor.constraint(equalTo: animationContainer.leadingAnchor).isActive = true
    }

}

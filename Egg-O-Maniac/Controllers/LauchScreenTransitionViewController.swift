//
//  LauchScreenTransitionViewController.swift
//  Egg-O-Maniac
//
//  Created by Maxence Gama on 18/03/2021.
//

import UIKit

class LauchScreenTransitionViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false) { (t) in
            self.performSegue(withIdentifier: "lauchToMain", sender: self)
        }
    }
}

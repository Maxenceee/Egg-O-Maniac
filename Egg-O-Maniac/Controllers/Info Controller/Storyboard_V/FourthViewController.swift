//
//  FourthViewController.swift
//  EggTimer
//
//  Created by Maxence Gama on 22/10/2020.
//

import UIKit

class FourthViewController: UIViewController {
    
    @IBOutlet weak var fermer: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    @IBAction func dismiss(_ sender: UIButton) {
        self.fermer.backgroundColor = .red
        self.dismiss(animated: true)
    }
}

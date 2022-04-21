//
//  ExplicationViewController.swift
//  EggTimer
//
//  Created by Maxence Gama on 01/11/2020.
//

import UIKit

class ExplicationViewController: UIViewController {

    @IBOutlet weak var topView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        topView.image = #imageLiteral(resourceName: "EggTimer Logo")
        topView.layer.cornerRadius = 35.0
    }
}

//
//  LanguageViewController.swift
//  EggTimer
//
//  Created by Maxence Gama on 21/10/2020.
//

import UIKit

class LanguageViewController: UIViewController {
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
 */
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let newRow = UserDefaults.standard.object(forKey: "row") as? Int
        
        if UserDefaults.standard.object(forKey: "row") as? Int != nil {
            view.backgroundColor = ColorList.backgroundColorsList[newRow!]
        } else {
            view.backgroundColor = ColorList.backgroundColorsList[0]
        }
    }
    
    @IBAction func closeButton(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
}

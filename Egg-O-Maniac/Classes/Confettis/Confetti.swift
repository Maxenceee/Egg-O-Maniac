//
//  Confetti.swift
//  EggTimer
//
//  Created by Maxence Gama on 10/10/2020.
//

import UIKit

class Confetti: CAEmitterCell {
    
    var images = [#imageLiteral(resourceName: "soft_egg"), #imageLiteral(resourceName: "medium_egg"), #imageLiteral(resourceName: "hard_egg")]
    
    override init() {
        super.init()
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    func setup() {
        contents = images[Int(arc4random_uniform(UInt32(images.count)))].cgImage
        /*color = UIColor(red: floatAleatoire(), green: floatAleatoire(), blue: floatAleatoire(), alpha: 1).cgColor*/
        birthRate = 1
        lifetime = 3
        lifetimeRange = 2
        velocity = 100
        spin = 4
        spinRange = 4
        scale = 0.008
        scaleRange = 0.03
        emissionLongitude = CGFloat(Double.pi)
        emissionRange = 0.75
    }
    
    func floatAleatoire() -> CGFloat{
        return CGFloat(arc4random_uniform(255)) / 255
    }

}

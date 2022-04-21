//
//  Lanceur.swift
//  EggTimer
//
//  Created by Maxence Gama on 10/10/2020.
//

import UIKit

class Lanceur: CAEmitterLayer {
    
    override init(layer: Any) {
        super.init(layer: layer)
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func setup(frame: CGRect) {
        emitterPosition = CGPoint(x: frame.width/2, y: -10)
        emitterShape = CAEmitterLayerEmitterShape.line
        emitterSize = CGSize(width: frame.width, height: 2)
    }
    
    func lancerConfettis() {
        emitterCells = creerCells()
    }
    
    func creerCells() -> [Confetti] {
        var confettis = [Confetti]()
        for _ in (0...30) {
            confettis.append(Confetti())
        }
        return confettis
    }

}

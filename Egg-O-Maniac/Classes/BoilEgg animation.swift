//
//  BoilEgg animation.swift
//  EggTimer
//
//  Created by Maxence Gama on 04/11/2020.
//  Copyright © 2020 The App Brewery. All rights reserved.
//

import UIKit
import SpriteKit

class BoilEgg_animation: SKScene {
    var boilEggFrames: [SKTexture]?
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(size: CGSize) {
        super.init(size: size)
        
        var frames: [SKTexture] = []
        
        //let boilerAtlas = SKTextureAtlas(named: "")
    }
}

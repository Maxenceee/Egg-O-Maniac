//
//  Item.swift
//  Juice
//
//  Created by Maxence Gama on 03/11/20.
//

import SwiftUI

struct Item: Identifiable {
    
    var id = UUID().uuidString
    var title: String
    var image: String
    var bgimage : String
    var intro : String
    var receipe: String
}



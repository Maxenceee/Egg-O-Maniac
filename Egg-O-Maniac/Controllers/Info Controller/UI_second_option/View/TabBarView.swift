//
//  TabBarView.swift
//  Juice
//
//  Created by Maxence Gama on 03/11/20.
//

import SwiftUI


struct TabBarView: View {
    @StateObject var tabData = TabViewModel()
    @Namespace var animation
    var body: some View {
        
        ZStack{
            Home(tabData: tabData, animation: animation)
            if tabData.isDetail{
                DetailV2(tabData: tabData, animation: animation)
            }
        }
    }
}


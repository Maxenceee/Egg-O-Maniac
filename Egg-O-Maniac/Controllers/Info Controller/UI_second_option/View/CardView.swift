//
//  CardView.swift
//  Juice
//
//  Created by Maxence Gama on 03/11/20.
//

import SwiftUI

struct CardView: View {
    var item: Item
    @ObservedObject var tabData : TabViewModel
    var animation: Namespace.ID
    
    @State var isSmall = UIScreen.main.bounds.height < 750
    
    var body: some View {
        HStack(spacing: 10){
            VStack(alignment: .leading, spacing: 10) {
                Text(item.title)
                    .font(isSmall ? .title2 : .title)
                    .fontWeight(.heavy)
                    .foregroundColor(.white)
                    .lineLimit(2)
                    .padding(.top, isSmall ? 20 : 0)
                Button(action: {
                    withAnimation(.spring()){
                        tabData.selectedItem = item
                        tabData.isDetail.toggle()
                    }
                }) {
                    Text("Voir".localized())
                        .fontWeight(.heavy)
                        .font(UIScreen.main.bounds.width < 380 ? .caption : .body)
                        .foregroundColor(Color(item.bgimage))
                        .padding(.vertical)
                        .padding(.horizontal,25)
                        .background(Color.white)
                        .cornerRadius(15)
                }
                .padding(isSmall ? 20 : 25)
                .padding(.vertical)
            }
            .padding(.leading,10)
            .offset(y: 27)
            
            Spacer(minLength: 0)
            
            Image(item.image)
                .resizable()
                .cornerRadius(25)
                .aspectRatio(contentMode: .fit)
                .matchedGeometryEffect(id: item.image, in: animation)
                .frame(height: UIScreen.main.bounds.height / 3)
        }
        .padding()
        .background(
            Color(item.bgimage)
                .cornerRadius(25)
                .padding(.top,55)
                .shadow(color: Color(.sRGB, red: 0, green: 0, blue: 0, opacity: 0.3), radius: 3, x: 0.0, y: 5)
        )
    }
}


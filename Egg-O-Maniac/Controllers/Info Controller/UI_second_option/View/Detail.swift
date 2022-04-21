//
//  Detail.swift
//  Juice
//
//  Created by Maxence Gama on 03/11/20.
//

import SwiftUI

struct Detail: View {
    @ObservedObject var tabData : TabViewModel
    var animation: Namespace.ID
    @State var start = false
    @State var cart = 1
    
    @State var isSmall = UIScreen.main.bounds.height < 750
    
    var body: some View {
        
        VStack{
            ScrollView{
                VStack{
                    ZStack{
                        HStack{
                            Button(action: {
                                withAnimation(Animation.easeIn(duration: 0.5)){
                                    start.toggle()
                                }
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                                    withAnimation(.spring()){
                                        tabData.isDetail.toggle()
                                    }
                                }
                            }) {
                                Image(systemName: "arrow.left")
                                    .font(.system(size: 24, weight: .heavy))
                                    .foregroundColor(.white)
                            }
                            Spacer()
                        }
                        Text("Recettes")
                            .font(.title)
                            .fontWeight(.heavy)
                            .foregroundColor(.white)
                    }
                    .padding()
                    ZStack{
                        Image(tabData.selectedItem.image)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .matchedGeometryEffect(id: tabData.selectedItem.image, in: animation)
                            .cornerRadius(25)
                            .padding(.horizontal, 10)
                    }
                    .frame(height: UIScreen.main.bounds.height / 3)
                    .padding(.vertical,25)
                }
                .padding(.bottom)
                .background(Color(tabData.selectedItem.bgimage).clipShape(CustomCorner()))
                VStack{
                    HStack{
                        Text(tabData.selectedItem.title)
                            .font(.title2)
                            .fontWeight(.heavy)
                            .foregroundColor(.black)
                        Spacer(minLength: 0)
                    }
                    .padding()
                    HStack{
                        Text(tabData.selectedItem.intro)
                            .fontWeight(.semibold)
                            .foregroundColor(Color.black.opacity(0.7))
                        Spacer(minLength: 0)
                    }
                    .padding(.horizontal)
                    HStack{
                        Text("Recette")
                            .font(.title2)
                            .fontWeight(.heavy)
                            .foregroundColor(.black)
                        Spacer(minLength: 0)
                    }
                    .padding()
                    HStack{
                        Text(tabData.selectedItem.receipe)
                            .fontWeight(.semibold)
                            .foregroundColor(Color.black.opacity(0.7))
                        Spacer(minLength: 0)
                    }
                    .padding(.horizontal)
                }
            }
            .background(
                ZStack{
                    Color(tabData.selectedItem.bgimage)
                        .ignoresSafeArea(.all, edges: .top)
                    Color.white
                        .ignoresSafeArea(.all, edges: .bottom)
                }
            )
            .onAppear {
                withAnimation(Animation.easeIn.delay(0.5)){
                    start.toggle()
                }
            }
        }
    }
}

//
//  test.swift
//  Egg-O-Maniac
//
//  Created by Maxence Gama on 08/02/2021.
//

import SwiftUI

struct test_Previews: PreviewProvider {
    static var previews: some View {
        Homee()
    }
}

struct Homee : View {
    @State var isSmall = UIScreen.main.bounds.height < 750
    @State var isMedium = UIScreen.main.bounds.height < 850
    
    var body: some View{
        ScrollView(.vertical, showsIndicators: false, content: {
            GeometryReader{reader in
                VStack{
                    ZStack{
                        HStack{
                            Button(action: {
                            }) {
                                Image(systemName: "arrow.left")
                                    .font(.system(size: 24, weight: .heavy))
                                    .foregroundColor(.white)
                            }
                            .offset(y: isMedium ? (isSmall ? -45 : -30) : 0)
                            Spacer()
                        }
                        Text("Recettes")
                            .font(.title)
                            .fontWeight(.heavy)
                            .foregroundColor(.white)
                            .offset(y: isSmall ? -30 : 0)
                    }
                    .padding()
                    ZStack{
                        Image("oeuf_mimosa_image")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .cornerRadius(25)
                            .padding(.horizontal, 20)
                    }
                    .frame(height: UIScreen.main.bounds.height / 3)
                    .padding(.vertical, 25)
                }
                .padding(.bottom)
                .background(Color(.orange))
                .offset(y: -reader.frame(in: .global).minY)
                .frame(width: UIScreen.main.bounds.width, height:  reader.frame(in: .global).minY + 480)
            }
            .frame(height: 420)
            VStack{
                HStack{
                    Text("tabData.selectedItem.title")
                        .font(.title2)
                        .fontWeight(.heavy)
                        .foregroundColor(.black)
                    Spacer(minLength: 0)
                }
                .padding()
                HStack{
                    Text("tabData.selectedItem.intro")
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
                    Text("Lorem ipsum, dolor sit amet consectetur adipisicing elit. Consequatur tempore sunt et asperiores quidem magnam laborum optio, reprehenderit cupiditate corporis. Quas non sunt necessitatibus ea praesentium enim quia voluptatum corrupti minus asperiores. Error aut, aspernatur voluptatem impedit sed perferendis veniam voluptatum itaque? Lorem ipsum dolor sit amet consectetur, adipisicing elit. Molestias possimus officia, incidunt quia vel optio? Explicabo reprehenderit numquam eligendi eos cum nesciunt unde voluptatem aspernatur, quidem iusto pariatur repellendus quas. Lorem ipsum, dolor sit amet consectetur adipisicing elit. Consequatur tempore sunt et asperiores quidem magnam laborum optio, reprehenderit cupiditate corporis. Quas non sunt necessitatibus ea praesentium enim quia voluptatum corrupti minus asperiores. Error aut, aspernatur voluptatem impedit sed perferendis veniam voluptatum itaque? Lorem ipsum dolor sit amet consectetur, adipisicing elit. Molestias possimus officia, incidunt quia vel optio? Explicabo reprehenderit numquam eligendi eos cum nesciunt unde voluptatem aspernatur, quidem iusto pariatur repellendus quas. Lorem ipsum, dolor sit amet consectetur adipisicing elit.")
                        .fontWeight(.semibold)
                        .foregroundColor(Color.black.opacity(0.7))
                    Spacer(minLength: 10)
                }
                .padding(.horizontal)
                Spacer(minLength: 20)
            }
            .padding(.top, 25)
            .padding(.horizontal)
            .background(Color.white)
            .cornerRadius(40)
            .offset(y: isSmall ? 0 : 0)
        })
        .edgesIgnoringSafeArea(.all)
        .background(Color(.orange).edgesIgnoringSafeArea(.all))
    }
}


struct DetailV2: View {
    @ObservedObject var tabData : TabViewModel
    var animation: Namespace.ID
    @State var start = false
    @State var cart = 1
    
    @State var isSmall = UIScreen.main.bounds.height < 750
    @State var isMedium = UIScreen.main.bounds.height < 850
    
    var body: some View {
        
        VStack{
            ScrollView(.vertical, showsIndicators: false) {
                GeometryReader{reader in
                    VStack {
                        ZStack{
                            HStack{
                                Button(action: {
                                    withAnimation(Animation.easeIn(duration: 0.5)){
                                        start.toggle()
                                    }
                                    DispatchQueue.main.asyncAfter(deadline: .now()) {
                                        withAnimation(.spring()){
                                            tabData.isDetail.toggle()
                                        }
                                    }
                                }) {
                                    Image(systemName: "arrow.left")
                                        .font(.system(size: 24, weight: .heavy))
                                        .foregroundColor(.white)
                                }
//                                .offset(y: isMedium ? (isSmall ? -45 : -20) : 0)
                                Spacer()
                            }
                            Text("Recettes".localized())
                                .font(.title)
                                .fontWeight(.heavy)
                                .foregroundColor(.white)
//                                .offset(y: isMedium ? (isSmall ? -45 : -20) : 0)
                        }
                        .padding()
                        .padding(.top, 20)
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
                    .background(Color(tabData.selectedItem.bgimage))
                    .offset(y: -reader.frame(in: .global).minY)
                    .frame(width: UIScreen.main.bounds.width, height: reader.frame(in: .global).minY + (isMedium ? (isSmall ? 380 : 440) : 480))
                }
                .frame(height: (isMedium ? (isSmall ? 330 : 390) : 430))
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
                        Text("Recette".localized())
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
                    Spacer(minLength: 30)
                }
                .padding(.top, 25)
                .padding(.horizontal)
                .background(Color.white)
                .cornerRadius(40)
            }
            .onAppear {
                withAnimation(Animation.easeIn.delay(0.5)){
                    start.toggle()
                }
            }
        }
        .edgesIgnoringSafeArea(.all)
        .background(Color(tabData.selectedItem.bgimage).edgesIgnoringSafeArea(.all))
    }
}

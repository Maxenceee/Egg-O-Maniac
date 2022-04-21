//
//  IntroView.swift
//  Egg-O-Maniac
//
//  Created by Maxence Gama on 08/02/2021.
//

import SwiftUI

struct Intro_Previews: PreviewProvider {
    static var previews: some View {
        IntroViewContent()
    }
}

final class ShowPage: ObservableObject {
    @Published var show = false
}

struct IntroViewContent: View {
    var body: some View {
        HomeIntro()
            .environmentObject(ShowPage())
    }
}

struct HomeIntro : View {
    @State var menu = 0
    @State var page = 0
    @EnvironmentObject var showpage: ShowPage
    
    var body: some View{
        ZStack{
            Color("Color").edgesIgnoringSafeArea(.all)
            VStack(spacing: 0) {
                VStack {
                    Text("Egg-O-Maniac")
                        .font(.system(size: 25))
                        .foregroundColor(.black)
                }
                Spacer(minLength: 50)
                if !showpage.show {
                    GeometryReader{g in
                        Carousel(width: UIScreen.main.bounds.width, page: self.$page, height: g.frame(in: .global).height)
                    }
                    Spacer()
                    PageControl(page: self.$page)
                        .padding(.top, 20)
                }
            }
            .padding(.vertical)
        }
    }
}

struct List : View {
    @Binding var page : Int
    var body: some View{
        HStack(spacing: 0){
            ForEach(data){i in
                Card(page: self.$page, width: UIScreen.main.bounds.width, data: i)
            }
        }
    }
}

struct Card : View {
    @Binding var page : Int
    var width: CGFloat
    var data: Type
    @EnvironmentObject var showpage: ShowPage
    @State var isSmall = UIScreen.main.bounds.height < 750
    @State var isMedium = UIScreen.main.bounds.height < 850
    
//    @State var IntroViewHost: IntroViewHost!
    
    var body: some View{
        VStack{
            VStack{
                Text(self.data.name)
                    .font(.system(size: 20))
                    .fontWeight(.bold)
                    .padding(.top, !isSmall ? 10 : (isMedium ? 0 : 0))
                    .foregroundColor(.black)
                Spacer(minLength: 0)
                Image(self.data.image)
                    .resizable()
                        .frame(width: (self.width - (self.page == self.data.id ? 100 : 150)), height: (self.page == self.data.id ? 250 : 200))
                        .cornerRadius(20)
                    .opacity(0.5)
                if page == 4 {
                    VStack {
                        Image(systemName: "arrow.down.circle")
                            .padding(.horizontal)
                            .foregroundColor(.black)
                        HStack{
                            Text("Glisser vers le bas pour \ncommencer à utiliser l'app")
                                .font(isSmall ? .callout : (isMedium ? .callout : .body))
                                .padding(.horizontal)
                                .padding(.top, isSmall ? 0 : (isMedium ? 5 : 10))
                                .multilineTextAlignment(.center)
                                .foregroundColor(Color.black.opacity(0.7))
                        }
                    }
                    .padding()
                    .padding(.top, !isSmall ? 100 : (isMedium ? 50 : 10))
                } else {
                    HStack {
                        Text("Suite")
                            .foregroundColor(.black)
                            .padding(.vertical, 10)
                        Image(systemName: "arrow.forward")
                            .foregroundColor(.black)
                            .padding(.vertical, 10)
                    }
                    .padding(.leading, 200)
                    .padding(.top, !isSmall ? 200 : (isMedium ? 100 : 50))
                }
                Spacer(minLength: 0)
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 25)
            .background(Color.white)
            .cornerRadius(20)
            .padding(.top, 25)
            .padding(.vertical, self.page == data.id ? 0 : 25)
            .padding(.horizontal, self.page == data.id ? 0 : 25)
        }
        .frame(width: self.width)
        .animation(.default)
    }
}

struct Carousel : UIViewRepresentable {
    func makeCoordinator() -> Coordinator {
        
        return Carousel.Coordinator(parent1: self)
    }
    
    var width : CGFloat
    @Binding var page : Int
    var height : CGFloat
    @State var isSmall = UIScreen.main.bounds.height < 750
    
    func makeUIView(context: Context) -> UIScrollView{
        let total = width * CGFloat(data.count)
        let view = UIScrollView()
        view.isPagingEnabled = true
        
        view.contentSize = CGSize(width: total, height: 1.0)
        view.bounces = true
        view.showsVerticalScrollIndicator = false
        view.showsHorizontalScrollIndicator = false
        view.delegate = context.coordinator
        
        let view1 = UIHostingController(rootView: List(page: self.$page))
        view1.view.frame = CGRect(x: 0, y: 0, width: total, height: self.height)
        view1.view.backgroundColor = .clear
        
        view.addSubview(view1.view)
        
        return view
    }
    
    func updateUIView(_ uiView: UIScrollView, context: Context) {
    }
    
    class Coordinator : NSObject,UIScrollViewDelegate{
        var parent : Carousel
        init(parent1: Carousel) {
            parent = parent1
        }
        func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
            
            let page = Int(scrollView.contentOffset.x / UIScreen.main.bounds.width)
            self.parent.page = page
        }
    }
}

struct PageControl : UIViewRepresentable {
    
    @Binding var page : Int
    
    func makeUIView(context: Context) -> UIPageControl {
        let view = UIPageControl()
        view.currentPageIndicatorTintColor = .black
        view.pageIndicatorTintColor = UIColor.black.withAlphaComponent(0.2)
        view.numberOfPages = data.count
        return view
    }
    
    func updateUIView(_ uiView: UIPageControl, context: Context) {
        uiView.currentPage = self.page
    }
}

struct Type : Identifiable {
    var id : Int
    var name : String
    var image : String
}

var data = [

    Type(id: 0, name: "Comment ça marche", image: "WaitingImage-1"),
    
    Type(id: 1, name: "Choisir la cuisson", image: "WaitingImage-1"),
    
    Type(id: 2, name: "Choisir la taille si besoin", image: "WaitingImage-1"),
    
    Type(id: 3, name: "Recettes", image: "WaitingImage-1"),
    
    Type(id: 4, name: "Commencer", image: "WaitingImage-1")
]

class IntroViewHost: UIHostingController<IntroViewContent> {

    required init?(coder: NSCoder) {
        super.init(coder: coder,rootView: IntroViewContent());
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    public func dismissView() {
        self.dismiss(animated: true, completion: nil)
    }
}

//
//  ChildHostingController.swift
//  Egg-O-Maniac
//
//  Created by Maxence Gama on 05/02/2021.
//

import SwiftUI
/*
final class ShowPage: ObservableObject {
    @Published var show = false
}

struct ReceipeView: View {
    var body: some View {
        Home()
            .environmentObject(ShowPage())
    }
}

struct Home : View {
    @State var menu = 0
    @State var page = 0
    @EnvironmentObject var showpage: ShowPage
    var body: some View{
        ZStack{
            Color("Color").edgesIgnoringSafeArea(.all)
            VStack(spacing: 0) {
                VStack {
                    Text("Recettes")
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
                } else {
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
    var body: some View{
        VStack{
            VStack{
                Text(self.data.name)
                    .font(.title)
                    .fontWeight(.bold)
                    .padding(.top,20)
                    .foregroundColor(.black)
                Text(self.data.cName)
                    .foregroundColor(.gray)
                    .padding(.vertical)
                Spacer(minLength: 0)
                Image(self.data.image)
                .resizable()
                    .frame(width: (self.width - (self.page == self.data.id ? 100 : 150)), height: (self.page == self.data.id ? 250 : 200))
                    .cornerRadius(20)
                Button(action: {
                    showpage.show = true
                }) {
                    Text("Voir")
                        .foregroundColor(.black)
                        .padding(.vertical, 10)
                        .padding(.horizontal, 30)
                }
                .background(Color("Color"))
                .clipShape(Capsule())
                .padding(.top, 100)
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
    var cName : String
    var image : String
    var receipe : String
}

var data = [

    Type(id: 0, name: "Oeuf à la coque", cName: "Basic", image: "oeuf_coque_image", receipe: ""),
    
    Type(id: 1, name: "Oeuf mollet", cName: "Basic", image: "oeuf_mollet_image", receipe: ""),
    
    Type(id: 2, name: "Oeuf dur", cName: "Basic", image: "oeuf_dur_image", receipe: ""),
    
    Type(id: 3, name: "Oeufs mimosa", cName: "Préparations", image: "oeuf_mimosa_image", receipe: "")
]

class ChildHostingController: UIHostingController<ReceipeView> {

    required init?(coder: NSCoder) {
        super.init(coder: coder,rootView: ReceipeView());
    }
    
    let closeBtn: UIButton = {
        let button = UIButton(type: UIButton.ButtonType.custom) as UIButton
        let bgImage = UIImage(systemName: "chevron.down") as UIImage?
        button.setBackgroundImage(bgImage, for: .normal)
        button.tintColor = .black
        button.contentMode = .scaleAspectFit
        button.addTarget(self, action: #selector(closeBtnTouched), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(closeBtn)
        
        closeBtn.heightAnchor.constraint(equalToConstant: 25).isActive = true
        closeBtn.widthAnchor.constraint(equalToConstant: 30).isActive = true
        closeBtn.topAnchor.constraint(equalTo: view.topAnchor, constant: 20).isActive = true
        closeBtn.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30).isActive = true
    }
    
    @objc func closeBtnTouched() {
        let generator = UIImpactFeedbackGenerator(style: .medium)
        generator.prepare()
        generator.impactOccurred()
        
        self.dismiss(animated: true, completion: nil)
    }
    
    func openDetailsView() {
        guard let vc = storyboard?.instantiateViewController(identifier: "settings_vc") as? SettingsViewController else {
            return
        }
        
        let generator = UIImpactFeedbackGenerator(style: .medium)
        generator.prepare()
        generator.impactOccurred()
        
        self.present(vc, animated: true, completion: nil)
    }
}
*/

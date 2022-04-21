//
//  IntroContentView.swift
//  Egg-O-Maniac
//
//  Created by Maxence Gama on 23/02/2021.
//

import SwiftUI

struct IntroContentView: View {
    var body: some View {
        WalkthroughtScreen()
    }
}

struct IntroContentView_Previews: PreviewProvider {
    static var previews: some View {
        IntroContentView()
    }
}

struct WalkthroughtScreen: View {
    
    @AppStorage("currentPage") var currentPage = 1
    
    var body: some View{
        ZStack {
            
            if currentPage == 1 {
                ScreenView(image: "WaitingImage-1", title: "Étape 1".localized(), detail: "Lorem ipsum, dolor sit amet consectetur adipisicing elit.", bgColor: Color(.systemBlue))
                    .transition(.identity)
            } else if currentPage == 2 {
                ScreenView(image: "WaitingImage-1", title: "Étape 2".localized(), detail: "Lorem ipsum, dolor sit amet consectetur adipisicing elit.", bgColor: Color(.systemYellow))
                    .transition(.identity)
            } else if currentPage == 3 {
                ScreenView(image: "WaitingImage-1", title: "Étape 3".localized(), detail: "Lorem ipsum, dolor sit amet consectetur adipisicing elit.", bgColor: Color(.systemRed))
                    .transition(.identity)
            }
        }
        .overlay(
            Button(action: {
                
                withAnimation(.easeInOut) {
                    if currentPage < totalPages {
                        currentPage += 1
                    } else {
//                        currentPage = 1
                    }
                }
                
            }, label: {
                Image(systemName: "chevron.right")
                    .font(.system(size: 20, weight: .semibold))
                    .foregroundColor(.black)
                    .frame(width: 60, height: 60)
                    .background(Color.white)
                    .clipShape(Circle())
                    .overlay(
                        ZStack {
                            Circle()
                                .stroke(Color.black.opacity(0.04), lineWidth: 4)
                            Circle()
                                .trim(from: 0.0, to: CGFloat(currentPage-1) / CGFloat(totalPages))
                                .stroke(Color.white, lineWidth: 4)
                                .rotationEffect(.init(degrees: -90))
                        }
                        .padding(-15)
                    )
            })
            .padding(.bottom, 20)
            
            ,alignment: .bottom
        )
    }
}


struct ScreenView: View {
    var image: String
    var title: String
    var detail: String
    var bgColor: Color
    
    @AppStorage("currentPage") var currentPage = 1
    
    var Host: IntroUIViewHost!
    
    var body: some View {
        VStack(spacing: 20) {
            HStack {
                if currentPage == 1 {
                    Text("Bienvenue !".localized())
                        .font(.title)
                        .fontWeight(.semibold)
                        .kerning(1.4)
                } else {
                    Button(action: {
                        withAnimation(.easeInOut) {
                            currentPage -= 1
                        }
                    }, label: {
                        Image(systemName: "chevron.left")
                            .foregroundColor(.white)
                            .padding(.vertical, 10)
                            .padding(.horizontal)
                            .background(Color.black.opacity(0.4))
                            .cornerRadius(10)
                    })
                }
                
                Spacer()
                /*
                Button(action: {
                    withAnimation(.easeInOut) {
                        Host.dismissView()
                    }
                }, label: {
                    Text("Skip")
                        .fontWeight(.semibold)
                        .kerning(1.2)
                })*/
            }
            .padding()
            .foregroundColor(.black)
            
            Spacer(minLength: 0)
            
            Image(image)
                .resizable()
                .aspectRatio(contentMode: .fit)
            
            Text(title)
                .font(.title)
                .fontWeight(.bold)
                .foregroundColor(.black)
                .padding(.top)
            
            Text(detail)
                .fontWeight(.semibold)
                .kerning(1.3)
                .multilineTextAlignment(.center)
                .padding(.horizontal)
            
            
            
            Spacer(minLength: 120)
        }
        .background(bgColor.cornerRadius(10).ignoresSafeArea())
    }
}
 var totalPages = 3


class IntroUIViewHost: UIHostingController<IntroContentView> {

    required init?(coder: NSCoder) {
        super.init(coder: coder,rootView: IntroContentView());
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(skipButton)
        
        skipButton.heightAnchor.constraint(equalToConstant: 20).isActive = true
        skipButton.widthAnchor.constraint(equalToConstant: 100).isActive = true
        skipButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 20).isActive = true
        skipButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -10).isActive = true
    }
    
    @objc func dismissView() {
        self.dismiss(animated: true, completion: nil)
    }
    
    let skipButton: UIButton = {
        let button = UIButton(type: UIButton.ButtonType.custom) as UIButton
        let attributedText = NSMutableAttributedString(string: "Passer".localized(), attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 22)])
        
        button.contentHorizontalAlignment = .right
        button.setTitleColor(.black, for: .normal)
        button.setAttributedTitle(attributedText, for: .normal)
        button.addTarget(self, action: #selector(dismissView), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
}

//
//  ContentView.swift
//  Juice
//
//  Created by Maxence Gama on 03/11/20.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        TabBarView()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

class ChildHostingController: UIHostingController<ContentView> {
    
    required init?(coder: NSCoder) {
        super.init(coder: coder,rootView: ContentView());
    }
    
    let closeBtn: UIButton = {
        let button = UIButton(type: UIButton.ButtonType.custom) as UIButton
        let bgImage = UIImage(systemName: "chevron.down") as UIImage?
        button.setBackgroundImage(bgImage, for: .normal)
        button.contentMode = .scaleAspectFit
        button.tintColor = .black
        button.addTarget(self, action: #selector(closeBtnTouched), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(closeBtn)
        isModalInPresentation = true
        
        closeBtn.heightAnchor.constraint(equalToConstant: 25).isActive = true
        closeBtn.widthAnchor.constraint(equalToConstant: 30).isActive = true
        closeBtn.topAnchor.constraint(equalTo: view.topAnchor, constant: 20).isActive = true
        closeBtn.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30).isActive = true
        
        view.backgroundColor = .white
    }
    
    @objc func closeBtnTouched() {
        let generator = UIImpactFeedbackGenerator(style: .medium)
        generator.prepare()
        generator.impactOccurred()
        
        self.dismiss(animated: true, completion: nil)
    }
}

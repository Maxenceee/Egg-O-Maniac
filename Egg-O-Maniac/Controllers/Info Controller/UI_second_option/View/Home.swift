//
//  Home.swift
//  Juice
//
//  Created by Maxence Gama on 03/11/20.
//

import SwiftUI

struct Home: View {
    
    @State var items = [
        
        Item(title: "Oeuf à la coque".localized(),
             image: "oeuf_coque_image",
             bgimage: "p1",
             intro: "Comment faire de bon oeufs à la coque.".localized(),
             receipe: "Lorem ipsum, dolor sit amet consectetur adipisicing elit. Consequatur tempore sunt et asperiores quidem magnam laborum optio, reprehenderit cupiditate corporis. Quas non sunt necessitatibus ea praesentium enim quia voluptatum corrupti minus asperiores. Error aut, aspernatur voluptatem impedit sed perferendis veniam voluptatum itaque? Lorem ipsum dolor sit amet consectetur, adipisicing elit. Molestias possimus officia, incidunt quia vel optio? Explicabo reprehenderit numquam eligendi eos cum nesciunt unde voluptatem aspernatur, quidem iusto pariatur repellendus quas. Lorem ipsum, dolor sit amet consectetur adipisicing elit. Consequatur tempore sunt et asperiores quidem magnam laborum optio, reprehenderit cupiditate corporis. Quas non sunt necessitatibus ea praesentium enim quia voluptatum corrupti minus asperiores. Error aut, aspernatur voluptatem impedit sed perferendis veniam voluptatum itaque? Lorem ipsum dolor sit amet consectetur, adipisicing elit. Molestias possimus officia, incidunt quia vel optio? Explicabo reprehenderit numquam eligendi eos cum nesciunt unde voluptatem aspernatur, quidem iusto pariatur repellendus quas."),
        Item(title: "Oeuf mollet".localized(),
             image: "oeuf_mollet_image",
             bgimage: "p2",
             intro: "Comment faire de bon oeufs mollets.".localized(),
             receipe: "Lorem ipsum, dolor sit amet consectetur adipisicing elit. Consequatur tempore sunt et asperiores quidem magnam laborum optio, reprehenderit cupiditate corporis. Quas non sunt necessitatibus ea praesentium enim quia voluptatum corrupti minus asperiores. Error aut, aspernatur voluptatem impedit sed perferendis veniam voluptatum itaque? Lorem ipsum dolor sit amet consectetur, adipisicing elit. Molestias possimus officia, incidunt quia vel optio? Explicabo reprehenderit numquam eligendi eos cum nesciunt unde voluptatem aspernatur, quidem iusto pariatur repellendus quas. Lorem ipsum, dolor sit amet consectetur adipisicing elit. Consequatur tempore sunt et asperiores quidem magnam laborum optio, reprehenderit cupiditate corporis. Quas non sunt necessitatibus ea praesentium enim quia voluptatum corrupti minus asperiores. Error aut, aspernatur voluptatem impedit sed perferendis veniam voluptatum itaque? Lorem ipsum dolor sit amet consectetur, adipisicing elit. Molestias possimus officia, incidunt quia vel optio? Explicabo reprehenderit numquam eligendi eos cum nesciunt unde voluptatem aspernatur, quidem iusto pariatur repellendus quas."),
        Item(title: "Oeuf dur".localized(),
             image: "oeuf_dur_image",
             bgimage: "p3",
             intro: "Comment faire de bon oeufs durs.".localized(),
             receipe: "Lorem ipsum, dolor sit amet consectetur adipisicing elit. Consequatur tempore sunt et asperiores quidem magnam laborum optio, reprehenderit cupiditate corporis. Quas non sunt necessitatibus ea praesentium enim quia voluptatum corrupti minus asperiores. Error aut, aspernatur voluptatem impedit sed perferendis veniam voluptatum itaque? Lorem ipsum dolor sit amet consectetur, adipisicing elit. Molestias possimus officia, incidunt quia vel optio? Explicabo reprehenderit numquam eligendi eos cum nesciunt unde voluptatem aspernatur, quidem iusto pariatur repellendus quas. Lorem ipsum, dolor sit amet consectetur adipisicing elit. Consequatur tempore sunt et asperiores quidem magnam laborum optio, reprehenderit cupiditate corporis. Quas non sunt necessitatibus ea praesentium enim quia voluptatum corrupti minus asperiores. Error aut, aspernatur voluptatem impedit sed perferendis veniam voluptatum itaque? Lorem ipsum dolor sit amet consectetur, adipisicing elit. Molestias possimus officia, incidunt quia vel optio? Explicabo reprehenderit numquam eligendi eos cum nesciunt unde voluptatem aspernatur, quidem iusto pariatur repellendus quas."),
        Item(title: "Ouefs mimosa".localized(),
             image: "oeuf_mimosa_image",
             bgimage: "p4",
             intro: "Comment faire de bon oeufs mimosa.".localized(),
             receipe: "Lorem ipsum, dolor sit amet consectetur adipisicing elit. Consequatur tempore sunt et asperiores quidem magnam laborum optio, reprehenderit cupiditate corporis. Quas non sunt necessitatibus ea praesentium enim quia voluptatum corrupti minus asperiores. Error aut, aspernatur voluptatem impedit sed perferendis veniam voluptatum itaque? Lorem ipsum dolor sit amet consectetur, adipisicing elit. Molestias possimus officia, incidunt quia vel optio? Explicabo reprehenderit numquam eligendi eos cum nesciunt unde voluptatem aspernatur, quidem iusto pariatur repellendus quas. Lorem ipsum, dolor sit amet consectetur adipisicing elit. Consequatur tempore sunt et asperiores quidem magnam laborum optio, reprehenderit cupiditate corporis. Quas non sunt necessitatibus ea praesentium enim quia voluptatum corrupti minus asperiores. Error aut, aspernatur voluptatem impedit sed perferendis veniam voluptatum itaque? Lorem ipsum dolor sit amet consectetur, adipisicing elit. Molestias possimus officia, incidunt quia vel optio? Explicabo reprehenderit numquam eligendi eos cum nesciunt unde voluptatem aspernatur, quidem iusto pariatur repellendus quas.")
    ]
    
    @ObservedObject var tabData : TabViewModel
    var animation: Namespace.ID
    
    var body: some View {
        VStack{
            ZStack{
                Text("Recettes".localized())
                    .font(.title)
                    .fontWeight(.heavy)
                    .foregroundColor(.black)
            }
            .padding()
            ScrollView(.vertical, showsIndicators: false) {
                VStack(spacing: 10){
                    ForEach(items){item in
                        CardView(item: item, tabData: tabData,animation: animation)
                    }
                }
                .padding()
            }
        }
    }
}

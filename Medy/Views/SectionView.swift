//
//  SectionView.swift
//  Medy
//
//  Created by Utku on 23/07/24.
//

import SwiftUI

struct SectionView<Content: View>: View {
    let title: String
   
    let content: Content

    init(title: String, @ViewBuilder content: () -> Content) {
        self.title = title
       
        self.content = content()
    }

    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                
                Text(title)
                    .font(.title3)
                Spacer()
            }
            .padding([.top, .leading, .trailing])
            content
                .padding([.leading, .trailing, .bottom])
            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
        .background(Color.gray.opacity(0.1))
        .cornerRadius(10)
    }
}

struct SectionView_Previews: PreviewProvider {
    static var previews: some View {
        SectionView(title: "Title") {
            Text("Content")
        }
    }
}

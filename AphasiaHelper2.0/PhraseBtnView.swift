//
//  PhraseBtnView.swift
//  AphasiaHelper2.0
//
//  Created by Xiaoqing Sun on 2020/12/13.
//

import SwiftUI

struct Phrase {
    var id: Int
    var name: String
}

struct PhraseBtnView: View {
    
    var phrase: Phrase
    
    var body: some View {
        Button(action: {
            read(text: "\(phrase.name)")
            // TODO: 词频加一
        }){
            Text("\(phrase.name)")
                .foregroundColor(Color.black)
                .font(.title3)
                .bold()
                .padding()
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(Color.gray.opacity(0.3), lineWidth: 2)
                        .shadow(color: Color.gray, radius: 2)
                )
                .background(Color.white)
                .cornerRadius(8)
        }
    }
    
}

struct PhraseBtnView_Previews: PreviewProvider {
    static var previews: some View {
        PhraseBtnView(phrase: Phrase(id: 0, name: "null"))
    }
}

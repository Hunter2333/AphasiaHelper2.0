//
//  WordBtnView.swift
//  AphasiaHelper2.0
//
//  Created by Xiaoqing Sun on 2020/12/6.
//

import SwiftUI

struct Word {
    var id: Int
    var name: String
}

struct WordBtnView: View {
    
    var word: Word
    
    @Binding var sentance: String
    
    var body: some View {
        Button(action: {
            read(text: "\(word.name)")
            sentance.append("\(word.name) ")
            // TODO: 词频加一
        }){
            Text("\(word.name)")
                .frame(width: 90.0, height: 90.0)
                .font(.title3)
        }
        .foregroundColor(Color.white)
        .background(Color.blue)
        .cornerRadius(20)
        .shadow(color: .gray, radius: 3, x: 2, y: 2)
        .padding(6)
    }
}

//struct WordBtnView_Previews: PreviewProvider {
//    static var previews: some View {
//
//        WordBtnView(word: Word(id: 0, name: ""))
//    }
//}

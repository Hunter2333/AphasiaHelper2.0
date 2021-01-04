//
//  ComponentWordView.swift
//  AphasiaHelper2.0
//
//  Created by Xiaoqing Sun on 2020/12/14.
//

import SwiftUI

struct ComponentWordView: View {
    
    var word: Word
    
    var body: some View {
        
        Text("\(word.name)")
            .foregroundColor(Color.black)
            .font(.caption)
            .bold()
            .padding(.vertical, 4)
            .padding(.horizontal, 18)
            .background(Color(red: 233/255, green: 238/255, blue: 251/255))
            .cornerRadius(5)
            .padding(.trailing, 2)
    }
}

struct ComponentWordView_Previews: PreviewProvider {
    static var previews: some View {
        
        ComponentWordView(word: Word(DBKey: 0, name: "null", url: "", type: WordType.Subject, isSelected: true))
    }
}

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
            .font(.title2)
            .bold()
            .padding(10)
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(Color(red: 198/255, green: 224/255, blue: 212/255), lineWidth: 6))
            .background(Color(red: 249/255, green: 247/255, blue: 241/255))
            .cornerRadius(8)
        
    }
}

struct ComponentWordView_Previews: PreviewProvider {
    static var previews: some View {
        
        ComponentWordView(word: Word(id: 0, name: "null"))
    }
}

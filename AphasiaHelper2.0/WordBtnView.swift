//
//  WordBtnView.swift
//  AphasiaHelper2.0
//
//  Created by Xiaoqing Sun on 2020/12/6.
//

import SwiftUI


struct WordBtnView: View {
    
    var word: Word
    
    @EnvironmentObject var mainController: MainController
    
    
    var body: some View {
        
        Button(action: {
            read(text: "\(word.name)")
            mainController.addWord(type: word.type, DBKey: word.DBKey)
        }){
            VStack {
                UrlImageView(urlString: word.urlToImage)
                Text("\(word.name)")
                    .foregroundColor(Color.black)
                    .font(.caption)
                    .bold()
            }
            .frame(width: 60, height: 90)
            .background(RoundedRectangle(cornerRadius: 10).fill(Color(red: 233/255, green: 238/255, blue:  251/255)))
            .overlay(word.isSelected ? RoundedRectangle(cornerRadius: 10).stroke(Color.black, lineWidth: 2) : RoundedRectangle(cornerRadius: 10).stroke(Color.black.opacity(0)))
        }.padding(10)
    }
}

struct WordBtnView_Previews: PreviewProvider {
    static var previews: some View {

        WordBtnView(word: Word(DBKey: 0, name: "null", urlToImage: "", type: WordType.Subject, isSelected: true))
    }
}

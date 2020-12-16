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
            if(word.isSelected) {
                // 选中
                VStack {
                    Image(uiImage: word.image ?? UIImage(named: "PlaceHolder")!)
                        .resizable()
                        .frame(width: 50, height: 50)
                    Text("\(word.name)")
                        .foregroundColor(Color.black)
                        .font(.caption)
                        .bold()
                }
                .frame(width: 60, height: 80)
                .overlay(
                    RoundedRectangle(cornerRadius: 6)
                        .stroke(Color(red: 61/255, green: 141/255, blue: 136/255), lineWidth: 8)
                )
                .background(Color.white)
                .cornerRadius(6)
            }
            else {
                // 未选中
                VStack {
                    Image(uiImage: word.image ?? UIImage(named: "PlaceHolder")!)
                        .resizable()
                        .frame(width: 50, height: 50)
                    Text("\(word.name)")
                        .foregroundColor(Color.black)
                        .font(.caption)
                        .bold()
                }
                .frame(width: 60, height: 80)
                .overlay(
                    RoundedRectangle(cornerRadius: 6)
                        .stroke(Color.gray.opacity(0.3), lineWidth: 2)
                        .shadow(color: Color.gray, radius: 2)
                )
                .background(Color.white)
                .cornerRadius(6)
            }
        }
    }
}

struct WordBtnView_Previews: PreviewProvider {
    static var previews: some View {

        WordBtnView(word: Word(DBKey: 0, name: "null", url: "", type: WordType.Subject, isSelected: true))
    }
}

//
//  PhraseBtnView.swift
//  AphasiaHelper2.0
//
//  Created by Xiaoqing Sun on 2020/12/13.
//

import SwiftUI


struct PhraseBtnView: View {
    
    var phrase: Phrase
    
    var body: some View {
        Button(action: {
            read(text: "\(phrase.name)")
            // 后端频率加一
            addFrequency(type: FrequencyUpdateType.sentence, DBKey: phrase.DBKey)
        }){
            Text("\(phrase.name)")
                .foregroundColor(Color.black)
                .font(.caption)
                .bold()
                .padding()
                .background(Color(red: 233/255, green: 238/255, blue: 251/255))
                .cornerRadius(10)
        }
    }
    
}

struct PhraseBtnView_Previews: PreviewProvider {
    static var previews: some View {
        PhraseBtnView(phrase: Phrase(DBKey: 0, name: "null"))
    }
}

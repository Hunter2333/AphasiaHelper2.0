//
//  CategoryBtnView.swift
//  AphasiaHelper2.0
//
//  Created by Xiaoqing Sun on 2020/12/13.
//

import SwiftUI

struct Category {
    var id: Int
    var name: String
}

struct CategoryBtnView: View {
    
    var category: Category
    
    // TODO
    @State var isSelected: Bool = false
    
    var body: some View {
        Button(action: {
            isSelected.toggle()
            //read(text: "\(word.name)")
            // TODO 更新二级分类下的words
        }){
            if(isSelected) {
                // 选中
                Text("\(category.name)")
                    .font(.body)
                    .bold()
                    .padding(.leading, 10)
                    .padding(.trailing, 10)
                    .padding(.top, 5)
                    .padding(.bottom, 5)
                    .foregroundColor(Color.white)
                    .background(Color(red: 59/255, green: 142/255, blue: 136/255))
                    .cornerRadius(5)
                    .shadow(radius: 1)
            }
            else {
                // 未选中
                Text("\(category.name)")
                    .font(.body)
                    .padding(.leading, 10)
                    .padding(.trailing, 10)
                    .padding(.top, 5)
                    .padding(.bottom, 5)
                    .foregroundColor(Color.black)
                    .background(Color.white)
                    .cornerRadius(5)
            }
        }
    }
    
}

struct CategoryBtnView_Previews: PreviewProvider {
    static var previews: some View {
        CategoryBtnView(category: Category(id: 0, name: "null"))
    }
}

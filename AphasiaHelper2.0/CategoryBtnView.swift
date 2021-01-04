//
//  CategoryBtnView.swift
//  AphasiaHelper2.0
//
//  Created by Xiaoqing Sun on 2020/12/13.
//

import SwiftUI


struct CategoryBtnView: View {
    
    var category: Category
    
    @EnvironmentObject var mainController: MainController
    
    var body: some View {
        Button(action: {
            mainController.updateCategoryBtnViews(selectedCategoryDBKey: category.DBKey)
        }){
            if(category.isSelected) {
                // 选中
                Text("\(category.name)")
                    .font(.caption2)
                    .padding(.horizontal, 18)
                    .padding(.vertical, 4)
                    .foregroundColor(Color.white)
                    .background(Color.black)
                    .cornerRadius(5)
            }
            else {
                // 未选中
                Text("\(category.name)")
                    .font(.caption2)
                    .padding(.horizontal, 18)
                    .padding(.vertical, 4)
                    .foregroundColor(Color.black)
                    .background(Color(red: 233/255, green: 238/255, blue: 251/255))
                    .cornerRadius(5)
            }
        }.padding(5)
    }
    
}

struct CategoryBtnView_Previews: PreviewProvider {
    static var previews: some View {
        CategoryBtnView(category: Category(DBKey: 0, name: "null", isSelected: true))
    }
}

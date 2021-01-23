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
            Text("\(category.name)")
                .font(.caption2)
                .padding(.horizontal, 18)
                .padding(.vertical, 4)
                .foregroundColor(category.isSelected ? Color.white : Color.black)
                .background(category.isSelected ? Color.black : Color(red: 233/255, green: 238/255, blue: 251/255))
                .cornerRadius(5)
        }.padding(5)
    }
    
}

struct CategoryBtnView_Previews: PreviewProvider {
    static var previews: some View {
        CategoryBtnView(category: Category(DBKey: 0, name: "null", isSelected: true))
    }
}

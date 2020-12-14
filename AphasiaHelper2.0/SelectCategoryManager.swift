//
//  SelectCategoryManager.swift
//  AphasiaHelper2.0
//
//  Created by Xiaoqing Sun on 2020/12/14.
//

import Foundation

class SelectCategoryManager: ObservableObject {
    
    // 当前选中的那个宾语二级分类标签
    @Published var selectedCategoryIndex: Int = 0
    // 宾语二级分类的所有标签
    @Published var categories: [Category] = [
            Category(name: "食物", isSelected: true),
            Category(name: "饮料", isSelected: false),
            Category(name: "身体", isSelected: false),
            Category(name: "日用品", isSelected: false),
            Category(name: "家具", isSelected: false),
            Category(name: "感受", isSelected: false),
            Category(name: "人物", isSelected: false),
            Category(name: "地点", isSelected: false),
        ]
    
    // TODO 从后台获取所有宾语二级分类标签的方法 -> categories (注意赋值Category对象的isSelected属性)
    //................
    
    // 切换标签: 同时只能有一个二级分类标签被选中, 初次打开页面时默认为第一个
    func updateCategoryBtnViews(selectedCategoryName: String) -> Void {
        
        if(categories[selectedCategoryIndex].name != selectedCategoryName) {
            
            categories[selectedCategoryIndex].isSelected = false
            
            for i in 0..<categories.count {
                if(categories[i].name == selectedCategoryName) {
                    categories[i].isSelected = true
                    selectedCategoryIndex = i
                    // TODO 更新二级分类下的words
                    break
                }
            }
        } else {
            return
        }
    }
    
}

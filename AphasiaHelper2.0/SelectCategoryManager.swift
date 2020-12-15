//
//  SelectCategoryManager.swift
//  AphasiaHelper2.0
//
//  Created by Xiaoqing Sun on 2020/12/14.
//

import Foundation

class SelectCategoryManager: ObservableObject {
    
    // 当前选中的那个宾语二级分类标签在categories中的下标
    @Published var selectedCategoryIndex: Int = 0
    // 宾语二级分类的所有标签
    @Published var categories: [Category] = [
            Category(DBKey: 1, name: "食物", isSelected: true),
            Category(DBKey: 2, name: "饮料", isSelected: false),
            Category(DBKey: 3, name: "身体", isSelected: false),
            Category(DBKey: 4, name: "日用品", isSelected: false),
            Category(DBKey: 5, name: "家具", isSelected: false),
            Category(DBKey: 6, name: "感受", isSelected: false),
            Category(DBKey: 7, name: "人物", isSelected: false),
            Category(DBKey: 8, name: "地点", isSelected: false),
        ]
    
    // TODO 从后台获取所有宾语二级分类标签的方法 -> categories (注意赋值Category对象的isSelected属性)
    //................
    
    // 切换标签: 同时只能有一个二级分类标签被选中, 初次打开页面时默认为第一个
    func updateCategoryBtnViews(selectedCategoryDBKey: Int) -> Void {
        
        if(categories[selectedCategoryIndex].DBKey != selectedCategoryDBKey) {
            
            categories[selectedCategoryIndex].isSelected = false
            
            for i in 0..<categories.count {
                if(categories[i].DBKey == selectedCategoryDBKey) {
                    categories[i].isSelected = true
                    selectedCategoryIndex = i
                    // TODO 更新二级分类下words的方法 (来自另一个类MakeUpSentanceManager)
                    break
                }
            }
        }
    }
    
}

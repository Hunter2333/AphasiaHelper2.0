//
//  Lv2ObjectsView.swift
//  AphasiaHelper2.0
//
//  Created by Xiaoqing Sun on 2021/1/18.
//

import SwiftUI

struct Lv2ObjectsView: View {
    
    @ObservedObject var lv2Objects: Lv2Objects
    
    init(selectedCategoryDBKey: Int) {
        lv2Objects = Lv2Objects(category_dbkey: selectedCategoryDBKey)
    }
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: true) {
            LazyHStack {
                ForEach(lv2Objects, id: \.id) {
                    word in WordBtnView(word: word).onAppear { lv2Objects.loadMoreLv2Objects(currentItem: word) }
                }
            }
            Spacer()
        }
    }
}

struct Lv2ObjectsView_Previews: PreviewProvider {
    static var previews: some View {
        Lv2ObjectsView(selectedCategoryDBKey: 0)
    }
}

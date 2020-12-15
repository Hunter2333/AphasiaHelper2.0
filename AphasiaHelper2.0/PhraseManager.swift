//
//  PhraseManager.swift
//  AphasiaHelper2.0
//
//  Created by Xiaoqing Sun on 2020/12/15.
//

import Foundation

class PhraseManager: ObservableObject {
    
    // 常用短语
    @Published var phrases: [Phrase] = [
            Phrase(DBKey: 1, name: "我不知道"),
            Phrase(DBKey: 2, name: "我感觉不舒服"),
            Phrase(DBKey: 3, name: "我需要帮助"),
            Phrase(DBKey: 4, name: "谢谢"),
        ]
    
    
    // TODO 从后台获取所有常用短语的方法 -> phrases
    //................
    
    // TODO 向后端插入新生成的常用短语
    //................
    
    // TODO 在后端给指定常用短语的频率加一
    //................
}

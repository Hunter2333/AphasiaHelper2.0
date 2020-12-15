//
//  DataModels.swift
//  AphasiaHelper2.0
//
//  Created by Xiaoqing Sun on 2020/12/15.
//

import Foundation


// 词语类型
enum WordType {
    case Subject
    case Predicate
    case Object
}

// 词语
struct Word: Hashable {
    var id = UUID()
    
    var DBKey: Int
    var name: String
    var url: String
    
    var type: WordType
    
    var isSelected: Bool
}

// 宾语二级分类标签
struct Category {
    var id = UUID()
    
    var DBKey: Int
    var name: String
    
    var isSelected: Bool
}

// 常用句子
struct Phrase {
    var id = UUID()
    
    var DBKey: Int
    var name: String
}

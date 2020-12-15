//
//  DataModels.swift
//  AphasiaHelper2.0
//
//  Created by Xiaoqing Sun on 2020/12/15.
//

import Foundation

// -------------------基础类型-------------------
// 词语类型
enum WordType: String, Codable {
    case Subject = "主语"
    case Predicate = "谓语"
    case Object = "宾语"
}

// 词语
struct Word: Hashable, Codable {
    var id = UUID()
    
    var DBKey: Int
    var name: String
    var url: String
    
    var type: WordType = WordType.Subject  //..........
    
    var isSelected: Bool = false  //...........
    
    enum CodingKeys: String, CodingKey {
        case DBKey = "_id"
        case name = "_name"
        case url = "_url"
    }
}

// 宾语二级分类标签
struct Category: Codable {
    var id = UUID()
    
    var DBKey: Int
    var name: String
    
    var isSelected: Bool = false //..............
    
    enum CodingKeys: String, CodingKey {
        case DBKey = "_id"
        case name = "_name"
    }
}

// 常用句子
struct Phrase: Codable {
    var id = UUID()
    
    var DBKey: Int
    var name: String
    
    enum CodingKeys: String, CodingKey {
        case DBKey = "_id"
        case name = "_name"
    }
}





// -------------------网络请求 JSON -> Object 类型-------------------
struct AllData: Codable {
    
}

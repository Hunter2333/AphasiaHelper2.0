//
//  MainController.swift
//  AphasiaHelper2.0
//
//  Created by Xiaoqing Sun on 2020/12/14.
//

import Foundation
import SwiftUI


// TODO: 数据加载问题: 第一次不成功，旋转设备屏幕后(相当于第二次)才成功
// TODO: 数据加载问题: 旋转设备屏幕会造成 lazyHStack 数据加载出错 (词语数量大时有重复的) ---- 原因定位: lazy 或 cache
class MainController: ObservableObject {
    
    // 主语
    @ObservedObject var subjects = Subjects()
    
    // 谓语
    @ObservedObject var predicates = Predicates()
    
    // 宾语常用词
    @ObservedObject var frequentObjects = FrequentObjects()
    
    // 当前选中的那个宾语二级分类标签在categories中的下标
    @Published var selectedCategoryIndex: Int = 0
    // 宾语二级分类的所有标签
    @ObservedObject var categories = Categories()
    
    // 二级宾语
    // TODO: default 80?
    @ObservedObject var lv2Objects = Lv2Objects(category_dbkey: 80)
    
    // 常用短语
    @ObservedObject var phrases = Phrases()
    
    // 组成的一句话
    @Published var sentence: String = ""
    @Published var componentWords = [Word]()
    
    
    // 切换标签: 同时只能有一个二级分类标签被选中, 初次打开页面时默认为第一个
    func updateCategoryBtnViews(selectedCategoryDBKey: Int) -> Void {
        
        if(categories[selectedCategoryIndex].DBKey != selectedCategoryDBKey) {
            
            categories.setIsSelected(pos: selectedCategoryIndex, val: false)
            
            for i in 0..<categories.count {
                if(categories[i].DBKey == selectedCategoryDBKey) {
                    categories.setIsSelected(pos: i, val: true)
                    selectedCategoryIndex = i
                    // 更新二级宾语
                    // TODO: 数据加载问题: 第一次不成功，旋转设备屏幕后(相当于第二次)才成功
                    lv2Objects = Lv2Objects(category_dbkey: selectedCategoryDBKey)
                    //print(lv2Objects.words.count)
                    break
                }
            }
        }
    }
    
    
    // 向组成的句子末添加词语
    func addWord(type: WordType, DBKey: Int) -> Void {
        
        switch type {
        case .Subject:
            for i in 0..<subjects.count {
                if(subjects[i].DBKey == DBKey) {
                    if(!subjects[i].isSelected) {
                        // 该词语未被选中, 更改 button 样式
                        subjects.setIsSelected(pos: i, val: true)
                        sentence.append("\(subjects[i].name)")
                        componentWords.append(subjects[i])
                    }
                    break
                }
            }
        case .Predicate:
            for i in 0..<predicates.count {
                if(predicates[i].DBKey == DBKey) {
                    if(!predicates[i].isSelected) {
                        // 该词语未被选中, 更改 button 样式
                        predicates.setIsSelected(pos: i, val: true)
                        sentence.append("\(predicates[i].name)")
                        componentWords.append(predicates[i])
                    }
                    break
                }

            }
        case .Object:
            // 宾语常用词和二级宾语 isSelected 联动
            var objectInFrequent: Bool = false
            for i in 0..<frequentObjects.count {
                if(frequentObjects[i].DBKey == DBKey) {
                    objectInFrequent = true
                    if(!frequentObjects[i].isSelected) {
                        // 该词语未被选中, 更改 button 样式
                        frequentObjects.setIsSelected(pos: i, val: true)
                        sentence.append("\(frequentObjects[i].name)")
                        componentWords.append(frequentObjects[i])
                        // 检查当前二级宾语中是否有该词语, 保持 button 样式统一
                        for j in 0..<lv2Objects.count {
                            if(lv2Objects[j].DBKey == DBKey) {
                                lv2Objects.setIsSelected(pos: j, val: true)
                                break
                            }
                        }
                        // 后端词频加一 (对于用户点击前为未选中状态的宾语词)
                        self.addFrequency(type: FrequencyUpdateType.object, DBKey: DBKey)
                    }
                    break
                }
            }
            // 用户点击的宾语词不在宾语常用词中, 在当前二级宾语中
            if(!objectInFrequent) {
                for i in 0..<lv2Objects.count {
                    if(lv2Objects[i].DBKey == DBKey) {
                        if(!lv2Objects[i].isSelected) {
                            // 该词语未被选中, 更改 button 样式
                            lv2Objects.setIsSelected(pos: i, val: true)
                            sentence.append("\(lv2Objects[i].name)")
                            componentWords.append(lv2Objects[i])
                            // To Test 后端词频加一 (对于用户点击前为未选中状态的宾语词)
                            self.addFrequency(type: FrequencyUpdateType.object, DBKey: DBKey)
                        }
                        break
                    }
                }
            }
        }
    }
    
    
    // 删除组成的句子中最后一个词
    func removeLastWord() -> Void {
        if(componentWords.count > 0) {
            
            switch componentWords[componentWords.count - 1].type {
            case .Subject:
                for i in 0..<subjects.count {
                    if(subjects[i].DBKey == componentWords[componentWords.count - 1].DBKey) {
                        subjects.setIsSelected(pos: i, val: false)
                        break
                    }
                }
            case .Predicate:
                for i in 0..<predicates.count {
                    if(predicates[i].DBKey == componentWords[componentWords.count - 1].DBKey) {
                        predicates.setIsSelected(pos: i, val: false)
                        break
                    }
                }
            case .Object:
                // 宾语常用词和二级宾语 isSelected 联动
                for i in 0..<frequentObjects.count {
                    if(frequentObjects[i].DBKey == componentWords[componentWords.count - 1].DBKey) {
                        frequentObjects.setIsSelected(pos: i, val: false)
                        break
                    }
                }
                for i in 0..<lv2Objects.count {
                    if(lv2Objects[i].DBKey == componentWords[componentWords.count - 1].DBKey) {
                        lv2Objects.setIsSelected(pos: i, val: false)
                        break
                    }
                }
            }
            
            componentWords.removeLast()
            sentence = ""
            for componentWord in componentWords {
                sentence.append(componentWord.name)
            }
        }
    }
    
    
    // 清空组成的句子
    func removeAllWords() -> Void {
        
        if(componentWords.count > 0) {
            for i in 0..<subjects.count {
                if(subjects[i].isSelected) {
                    subjects.setIsSelected(pos: i, val: false)
                }
            }
            for i in 0..<predicates.count {
                if(predicates[i].isSelected) {
                    predicates.setIsSelected(pos: i, val: false)
                }
            }
            for i in 0..<frequentObjects.count {
                if(frequentObjects[i].isSelected) {
                    frequentObjects.setIsSelected(pos: i, val: false)
                }
            }
            for i in 0..<lv2Objects.count {
                if(lv2Objects[i].isSelected) {
                    lv2Objects.setIsSelected(pos: i, val: false)
                }
            }
            
            componentWords.removeAll()
            sentence = ""
        }
    }
    
    
    // 向后端插入新生成的常用短语
    func addPhrase(phrase: String) {
        
        print("插入常用短语: \(phrase)")
        
        guard let url = URL(string: "http://47.102.158.185:8899/word/insert/sentence?sentence=\(phrase)".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!) else {
            print("Invalid Insert URL")
            return
        }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"

        URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let httpResponse = response as? HTTPURLResponse, let data = data, let dataString = String(data: data, encoding: .utf8) {
                print("Response Status Code: \(httpResponse.statusCode)")
                print("Response Body: \(dataString)")
            } else {
                print(error ?? "")
            }
        }.resume()
    }
    
    
    // 后端频率加一
    func addFrequency(type: FrequencyUpdateType, DBKey: Int) {
        
        print("更新频率: \(type), \(DBKey)")
        
        guard let url = URL(string: "http://47.102.158.185:8899/word/frequency/\(type)?id=\(DBKey)") else {
            print("Invalid URL")
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "PUT"

        URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let httpResponse = response as? HTTPURLResponse {
                print("Response Status Code: \(httpResponse.statusCode)")
            } else {
                print(error ?? "")
            }
        }.resume()
    }
    
}

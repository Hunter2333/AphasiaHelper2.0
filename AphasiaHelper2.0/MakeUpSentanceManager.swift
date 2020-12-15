//
//  MakeUpSentance.swift
//  AphasiaHelper2.0
//
//  Created by Xiaoqing Sun on 2020/12/14.
//

import Foundation

class MakeUpSentanceManager: ObservableObject {
    
    // 主语
    @Published var subjects = [Word]()
    
    // 谓语
    @Published var predicates = [Word]()
    
    // 宾语常用词
    @Published var frequentObjects = [Word]()
    
    // 当前选中的那个宾语二级分类标签在categories中的下标
    @Published var selectedCategoryIndex: Int = 0
    // 宾语二级分类的所有标签
    @Published var categories = [Category]()
    
    // 二级分类下的宾语词
    @Published var lv2Objects = [Word]()
    
    // 常用短语
    @Published var phrases = [Phrase]()
    
    // 组成的一句话
    @Published var sentance: String = ""
    @Published var componentWords = [Word]()
    
    
    
    // 注意赋值 Word 对象的 type & isSelected (检查 ComponentWords) 属性
    // 打开App时加载全部数据
    func loadAll() {
        
    }
    // TODO 从后台获取所有主语的方法 -> subjects
    func getAllSubjects() {
        
    }
    
    // TODO 从后台获取所有谓语的方法 -> predicates
    //................
    
    // TODO 从后台获取所有宾语常用词的方法 -> frequentObjects
    //................
    
    // TODO 从后台获取所有宾语二级分类标签的方法 -> categories (注意赋值Category对象的isSelected属性)
    //................
    
    // TODO 从后台获取指定标签下所有二级宾语词的方法 -> lv2Objects
    //................
    // 注意赋值 Word 对象的 type & isSelected (检查 ComponentWords) 属性
    
    
    // 切换标签: 同时只能有一个二级分类标签被选中, 初次打开页面时默认为第一个
    func updateCategoryBtnViews(selectedCategoryDBKey: Int) -> Void {
        
        if(categories[selectedCategoryIndex].DBKey != selectedCategoryDBKey) {
            
            categories[selectedCategoryIndex].isSelected = false
            
            for i in 0..<categories.count {
                if(categories[i].DBKey == selectedCategoryDBKey) {
                    categories[i].isSelected = true
                    selectedCategoryIndex = i
                    // TODO 更新二级分类下words的方法
                    break
                }
            }
        }
    }
    
    
    // 向组成的句子末添加词语
    // TODO: 后端词频加一 (对于用户点击前为未选中状态的宾语常用词)
    func addWord(type: WordType, DBKey: Int) -> Void {
        
        switch type {
        case .Subject:
            for i in 0..<subjects.count {
                if(subjects[i].DBKey == DBKey) {
                    if(!subjects[i].isSelected) {
                        // 该词语未被选中, 更改 button 样式
                        subjects[i].isSelected = true
                        sentance.append("\(subjects[i].name)")
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
                        predicates[i].isSelected = true
                        sentance.append("\(predicates[i].name)")
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
                        frequentObjects[i].isSelected = true
                        sentance.append("\(frequentObjects[i].name)")
                        componentWords.append(frequentObjects[i])
                        // 检查当前二级宾语中是否有该词语, 保持 button 样式统一
                        for j in 0..<lv2Objects.count {
                            if(lv2Objects[j].DBKey == DBKey) {
                                lv2Objects[j].isSelected = true
                                break
                            }
                        }
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
                            lv2Objects[i].isSelected = true
                            sentance.append("\(lv2Objects[i].name)")
                            componentWords.append(lv2Objects[i])
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
                        subjects[i].isSelected = false
                        break
                    }
                }
            case .Predicate:
                for i in 0..<predicates.count {
                    if(predicates[i].DBKey == componentWords[componentWords.count - 1].DBKey) {
                        predicates[i].isSelected = false
                        break
                    }
                }
            case .Object:
                // 宾语常用词和二级宾语 isSelected 联动
                for i in 0..<frequentObjects.count {
                    if(frequentObjects[i].DBKey == componentWords[componentWords.count - 1].DBKey) {
                        frequentObjects[i].isSelected = false
                        break
                    }
                }
                for i in 0..<lv2Objects.count {
                    if(lv2Objects[i].DBKey == componentWords[componentWords.count - 1].DBKey) {
                        lv2Objects[i].isSelected = false
                        break
                    }
                }
            }
            
            componentWords.removeLast()
            sentance = ""
            for componentWord in componentWords {
                sentance.append(componentWord.name)
            }
        }
    }
    
    
    // TODO 从后台获取所有常用短语的方法 -> phrases
    //................
    
    // TODO 向后端插入新生成的常用短语
    //................
    
    // TODO 在后端给指定常用短语的频率加一
    //................
    
}

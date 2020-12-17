//
//  MainController.swift
//  AphasiaHelper2.0
//
//  Created by Xiaoqing Sun on 2020/12/14.
//

import Foundation
import SwiftUI

// TODO: (多线程 返回Word的顺序应与JSON保持一致、数据加载速度优化) & 图片缓存
// TODO: lv2Objects合并到categories中存储, 对已请求过的分类标签下的词语列表不用重复请求
class MainController: ObservableObject {
    
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
    @Published var sentence: String = ""
    @Published var componentWords = [Word]()
    
    
    
    // 打开App时加载全部数据
    func loadAll() {
        // TODO: url中的参数写成活的(来自DataModel中的total)以应对词库变更
        guard let url = URL(string: "http://47.102.158.185:8899/word/all?categorySize=19&preSize=59&secObjSize=4&subSize=15&usualObjSize=363&usualSenSize=5") else {
            print("Invalid URL")
            return
        }
        let request = URLRequest(url: url)
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let data = data {
                if let decodedResponse = try? JSONDecoder().decode(AllData.self, from: data) {
                    
                    //print(decodedResponse)
                    
                    DispatchQueue.main.sync { // 串行执行, 代码块顺序轻微可调
                        
                        self.subjects = decodedResponse.subject.list
                        self.predicates = decodedResponse.predicate.list
                        self.frequentObjects = decodedResponse.usualObject.list
                        self.categories = decodedResponse.categoryList.list
                        self.lv2Objects = decodedResponse.curCategory._item.list
                        self.phrases = decodedResponse.usualSentence.list
                        
                        if(self.categories.count > 0) {
                            self.categories[self.selectedCategoryIndex].isSelected = true
                        }
                        
                        for i in 0..<self.subjects.count {
                            guard let imageUrl = URL(string: self.subjects[i].url.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!) else {
                                    print("Invalid Image URL")
                                    return
                                }
                            URLSession.shared.dataTask(with: imageUrl){ (data, response, error) in
                                if let image = UIImage(data: data!){
                                    self.subjects[i].image = image
                                } else {
                                    print(error ?? "")
                                }
                            }.resume()
                        }
                        for i in 0..<self.predicates.count {
                            self.predicates[i].type = WordType.Predicate
                            guard let imageUrl = URL(string: self.predicates[i].url.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!) else {
                                    print("Invalid Image URL")
                                    return
                                }
                            URLSession.shared.dataTask(with: imageUrl){ (data, response, error) in
                                if let image = UIImage(data: data!){
                                    self.predicates[i].image = image
                                } else {
                                    print(error ?? "")
                                }
                            }.resume()
                        }
                        for i in 0..<self.frequentObjects.count {
                            self.frequentObjects[i].type = WordType.Object
                            guard let imageUrl = URL(string: self.frequentObjects[i].url.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!) else {
                                    print("Invalid Image URL")
                                    return
                                }
                            URLSession.shared.dataTask(with: imageUrl){ (data, response, error) in
                                if let image = UIImage(data: data!){
                                    self.frequentObjects[i].image = image
                                } else {
                                    print(error ?? "")
                                }
                            }.resume()
                        }
                        for i in 0..<self.lv2Objects.count {
                            self.lv2Objects[i].type = WordType.Object
                            guard let imageUrl = URL(string: self.lv2Objects[i].url.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!) else {
                                    print("Invalid Image URL")
                                    return
                                }
                            URLSession.shared.dataTask(with: imageUrl){ (data, response, error) in
                                if let image = UIImage(data: data!){
                                    self.lv2Objects[i].image = image
                                } else {
                                    print(error ?? "")
                                }
                            }.resume()
                        }
                        
                    }
                }
            } else {
                print(error ?? "")
            }
        }.resume()
        
    }
    
    
    // 注意赋值 Word 对象的 type & isSelected (检查 ComponentWords) 属性
    // 从后台获取所有主语的方法 -> subjects
    //................
    
    // 从后台获取所有谓语的方法 -> predicates
    //................
    
    // 从后台获取所有宾语常用词的方法 -> frequentObjects
    //................
    
    // 从后台获取所有宾语二级分类标签的方法 -> categories (注意赋值Category对象的isSelected属性)
    //................
    
    
    // 从后台获取指定标签下所有二级宾语词的方法 -> lv2Objects
    func loadLv2ObjectsInCategory(selectedCategoryDBKey: Int) {
        
        self.lv2Objects.removeAll()
        
        // TODO: url中的参数pageSize写成活的(来自DataModel中的total)以应对词库变更
        let maxItemNum = 50
        guard let url = URL(string: "http://47.102.158.185:8899/word/page/second_object?id=\(selectedCategoryDBKey)&pageNum=1&pageSize=\(maxItemNum)") else {
            print("Invalid URL")
            return
        }
        let request = URLRequest(url: url)
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let data = data {
                if let decodedResponse = try? JSONDecoder().decode(WordList.self, from: data) {
                    
                    DispatchQueue.main.sync { // 串行执行, 代码块顺序不可颠倒
                        
                        self.lv2Objects = decodedResponse.list
                        
                        for i in 0..<self.lv2Objects.count {
                            self.lv2Objects[i].type = WordType.Object
                            guard let imageUrl = URL(string: self.lv2Objects[i].url.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!) else {
                                    print("Invalid Image URL")
                                    return
                                }
                            URLSession.shared.dataTask(with: imageUrl){ (data, response, error) in
                                if let image = UIImage(data: data!){
                                    self.lv2Objects[i].image = image
                                } else {
                                    print(error ?? "")
                                }
                            }.resume()
                        }
                        
                        // 修改 lv2Objects 中 word 的 isSelected 属性 (检查 ComponentWords)
                        for i in 0..<self.componentWords.count {
                            if(self.componentWords[i].type == WordType.Object) {
                                for j in 0..<self.lv2Objects.count {
                                    if(!self.lv2Objects[j].isSelected && self.componentWords[i].DBKey == self.lv2Objects[j].DBKey) {
                                        self.lv2Objects[j].isSelected = true
                                        break
                                    }
                                }
                            }
                        }
                    }
                }
            } else {
                print(error ?? "")
            }
        }.resume()
    }
    
    
    // 切换标签: 同时只能有一个二级分类标签被选中, 初次打开页面时默认为第一个
    func updateCategoryBtnViews(selectedCategoryDBKey: Int) -> Void {
        
        if(categories[selectedCategoryIndex].DBKey != selectedCategoryDBKey) {
            
            categories[selectedCategoryIndex].isSelected = false
            
            for i in 0..<categories.count {
                if(categories[i].DBKey == selectedCategoryDBKey) {
                    categories[i].isSelected = true
                    selectedCategoryIndex = i
                    // 更新二级分类下的words
                    self.loadLv2ObjectsInCategory(selectedCategoryDBKey: selectedCategoryDBKey)
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
                        subjects[i].isSelected = true
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
                        predicates[i].isSelected = true
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
                        frequentObjects[i].isSelected = true
                        sentence.append("\(frequentObjects[i].name)")
                        componentWords.append(frequentObjects[i])
                        // 检查当前二级宾语中是否有该词语, 保持 button 样式统一
                        for j in 0..<lv2Objects.count {
                            if(lv2Objects[j].DBKey == DBKey) {
                                lv2Objects[j].isSelected = true
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
                            lv2Objects[i].isSelected = true
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
            sentence = ""
            for componentWord in componentWords {
                sentence.append(componentWord.name)
            }
        }
    }
    
    
    // 从后台获取所有常用短语的方法 -> phrases
    func loadAllPhrases() {
        
        self.phrases.removeAll()
        
        // TODO: url中的参数pageSize写成活的(来自DataModel中的total)以应对词库变更
        let maxItemNum = 15
        guard let url = URL(string: "http://47.102.158.185:8899/word/page/usual_sentence?pageNum=1&pageSize=\(maxItemNum)") else {
            print("Invalid URL")
            return
        }
        let request = URLRequest(url: url)
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let data = data {
                if let decodedResponse = try? JSONDecoder().decode(PhraseList.self, from: data) {
                    DispatchQueue.main.async {
                        self.phrases = decodedResponse.list
                    }
                }
            } else {
                print(error ?? "")
            }
        }.resume()
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

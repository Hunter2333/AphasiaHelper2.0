//
//  DataModels.swift
//  AphasiaHelper2.0
//
//  Created by Xiaoqing Sun on 2020/12/15.
//

import Foundation
import SwiftUI

// -------------------基础类型-------------------
// 词语类型
enum WordType: String, Codable {
    case Subject
    case Predicate
    case Object
}

// 可更新频率的类型
enum FrequencyUpdateType: String {
    case object
    case sentence  // phrase
}


// 加载词语
class Words: ObservableObject, RandomAccessCollection {
    
    typealias Element = Word
    
    @Published var words = [Word]()
    
    var startIndex: Int { words.startIndex }
    var endIndex: Int { words.endIndex }
    var nextPageToLoad = 1
    var pageSize = 15
    var currentlyLoading = false
    var doneLoading = false
    
    var urlBase = "http://47.102.158.185:8899/word/page/"
    
    var wordType: WordType
    
    var categoryDBKey: Int  // 二级宾语所属分类标签的DBKey, 当words是一级词语时设为默认值-1 (无分类)
    
    var componentWords: [Word]  // mainController中组成的一句话
    
    init(urlWordType: String, type: WordType, category_dbkey: Int? = nil, component_words: [Word]? = nil) {
        urlBase.append(urlWordType)
        wordType = type
        categoryDBKey = category_dbkey ?? -1  // 一级词语默认分类标签DBKey为-1 (无分类)
        componentWords = component_words ?? [Word]()
        loadMoreWords()
    }
    
    subscript(position: Int) -> Word {
        return words[position]
    }
    
    func setIsSelected(pos: Int, val: Bool) {
        words[pos].isSelected = val
    }
    
    func loadMoreWords(currentItem: Word? = nil) {
        
        if !shouldLoadMoreData(currentItem: currentItem) {
            return
        }
        currentlyLoading = true
        
        let urlString: String
        if(categoryDBKey == -1) {
            // 一级词语
            urlString = "\(urlBase)?pageNum=\(nextPageToLoad)&pageSize=\(pageSize)"
        } else {
            // 二级宾语
            urlString = "\(urlBase)?id=\(categoryDBKey)&pageNum=\(nextPageToLoad)&pageSize=\(pageSize)"
        }
        
        let url = URL(string: urlString)!
        let task = URLSession.shared.dataTask(with: url, completionHandler: parseWordsFromResponse(data:response:error:))
        task.resume()
    }
    
    func shouldLoadMoreData(currentItem: Word? = nil) -> Bool {
        if currentlyLoading || doneLoading {
            return false
        }
        
        guard let currentItem = currentItem else {
            return true
        }
        
        for n in (words.count - 4)...(words.count - 1) {
            if n >= 0 && currentItem.id == words[n].id {
                return true
            }
        }
        return false
    }
    
    func parseWordsFromResponse(data: Data?, response: URLResponse?, error: Error?) {
        guard error == nil else {
            print("Error: \(error!)")
            currentlyLoading = false
            return
        }
        guard let data = data else {
            print("No data found")
            currentlyLoading = false
            return
        }
        if var decodedResponse = try? JSONDecoder().decode(WordList.self, from: data) {
            for i in 0..<decodedResponse.list.count {
                decodedResponse.list[i].type = wordType
            }
            // 检查是否在当前组成的一句话中，若在，修改isSelected为true (TODO: 仅对二级宾语？)
            if(categoryDBKey != -1 && componentWords.count > 0) {
                for i in 0..<componentWords.count {
                    if(componentWords[i].type == WordType.Object) {
                        for j in 0..<decodedResponse.list.count {
                            if(decodedResponse.list[j].DBKey == componentWords[i].DBKey) {
                                decodedResponse.list[j].isSelected = true
                                break
                            }
                        }
                    }
                }
            }
            DispatchQueue.main.async {
                self.words.append(contentsOf: decodedResponse.list)
                self.nextPageToLoad += 1
                self.currentlyLoading = false
                self.doneLoading = (decodedResponse.list.count == 0)
            }
        } else {
            print(error ?? "")
        }
    }
}

// 加载常用短语
class Phrases: ObservableObject, RandomAccessCollection {
    
    typealias Element = Phrase
    
    @Published var phrases = [Phrase]()
    
    var startIndex: Int { phrases.startIndex }
    var endIndex: Int { phrases.endIndex }
    var nextPageToLoad = 1
    var pageSize = 15
    var currentlyLoading = false
    var doneLoading = false
    
    var urlBase = "http://47.102.158.185:8899/word/page/usual_sentence"
    
    init() {
        loadMorePhrases()
    }
    
    subscript(position: Int) -> Phrase {
        return phrases[position]
    }
    
    func loadMorePhrases(currentItem: Phrase? = nil) {
        
        if !shouldLoadMoreData(currentItem: currentItem) {
            return
        }
        currentlyLoading = true
        
        let urlString = "\(urlBase)?pageNum=\(nextPageToLoad)&pageSize=\(pageSize)"
        let url = URL(string: urlString)!
        let task = URLSession.shared.dataTask(with: url, completionHandler: parsePhrasesFromResponse(data:response:error:))
        task.resume()
    }
    
    func shouldLoadMoreData(currentItem: Phrase? = nil) -> Bool {
        if currentlyLoading || doneLoading {
            return false
        }
        
        guard let currentItem = currentItem else {
            return true
        }
        
        for n in (phrases.count - 4)...(phrases.count - 1) {
            if n >= 0 && currentItem.id == phrases[n].id {
                return true
            }
        }
        return false
    }
    
    func parsePhrasesFromResponse(data: Data?, response: URLResponse?, error: Error?) {
        guard error == nil else {
            print("Error: \(error!)")
            currentlyLoading = false
            return
        }
        guard let data = data else {
            print("No data found")
            currentlyLoading = false
            return
        }
        if let decodedResponse = try? JSONDecoder().decode(PhraseList.self, from: data) {
            DispatchQueue.main.async {
                self.phrases.append(contentsOf: decodedResponse.list)
                self.nextPageToLoad += 1
                self.currentlyLoading = false
                self.doneLoading = (decodedResponse.list.count == 0)
            }
        } else {
            print(error ?? "")
        }
    }
}

// 加载宾语二级分类的所有标签
class Categories: ObservableObject, RandomAccessCollection {
    
    typealias Element = Category
    
    @Published var categories = [Category]()
    
    var startIndex: Int { categories.startIndex }
    var endIndex: Int { categories.endIndex }
    var total = 19  //...........
    var doneLoading = false // 用于确保加载完 categories 再加载 MainView->Lv2ObjectsView
    
    var urlBase = "http://47.102.158.185:8899/word/page/category_list?pageNum=1&pageSize="
    
    init() {
        loadAllCategories()
    }
    
    subscript(position: Int) -> Category {
        return categories[position]
    }
    
    func setIsSelected(pos: Int, val: Bool) {
        categories[pos].isSelected = val
    }
    
    func loadAllCategories() {
        
        let urlString = "\(urlBase)\(total)"
        let url = URL(string: urlString)!
        let task = URLSession.shared.dataTask(with: url, completionHandler: parseCategoriesFromResponse(data:response:error:))
        task.resume()
    }
    
    func parseCategoriesFromResponse(data: Data?, response: URLResponse?, error: Error?) {
        guard error == nil else {
            print("Error: \(error!)")
            return
        }
        guard let data = data else {
            print("No data found")
            return
        }
        if var decodedResponse = try? JSONDecoder().decode(CategoryList.self, from: data) {
            if(decodedResponse.list.count > 0) {
                // 初次打开App时默认第一个分类标签被选中
                decodedResponse.list[0].isSelected = true
            }
            DispatchQueue.main.async {
                self.categories = decodedResponse.list
                self.doneLoading = true
            }
        } else {
            print(error ?? "")
        }
    }
}

// 主语
class Subjects: Words {
    
    init() {
        super.init(urlWordType: "subject", type: WordType.Subject)
    }
}

// 谓语
class Predicates: Words {
    
    init() {
        super.init(urlWordType: "predicate", type: WordType.Predicate)
    }
}

// 宾语常用词
class FrequentObjects: Words {
    
    init() {
        super.init(urlWordType: "usual_object", type: WordType.Object)
    }
}

// 二级宾语
class Lv2Objects: Words {
    
    // 检查是否在当前组成的一句话中，若在，修改isSelected为true (TODO: 仅对二级宾语？)
    init(category_dbkey: Int, component_words: [Word]) {
        super.init(urlWordType: "second_object", type: WordType.Object, category_dbkey: category_dbkey, component_words: component_words)
    }
}

// 加载词语图片
class UrlImageModel: ObservableObject {
    @Published var image: UIImage?
    var urlString: String?
    var imageCache = ImageCache.getImageCache()
    
    init(urlString: String?) {
        self.urlString = urlString
        loadImage()
    }
    
    func loadImage() {
        
        if loadImageFromCache() {
            //print("Cache hit")
            return
        }
        
        //print("Cache miss, loading from url")
        loadImageFromUrl()
    }
    
    func loadImageFromCache() -> Bool {
        guard let urlString = urlString else {
            return false
        }
        guard let cacheImage = imageCache.get(forKey: urlString) else {
            return false
        }
        image = cacheImage
        return true
    }
    
    func loadImageFromUrl() {
        guard let urlString = urlString else {
            return
        }
        let url = URL(string: urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!)!
        let task = URLSession.shared.dataTask(with: url, completionHandler: getImageFromResponse(data:response:error:))
        task.resume()
    }
    
    func getImageFromResponse(data: Data?, response: URLResponse?, error: Error?) {
        guard error == nil else {
            print("Error: \(error!)")
            return
        }
        guard let data = data else {
            print("No data found")
            return
        }
        DispatchQueue.main.async {
            guard let loadedImage = UIImage(data: data) else {
                return
            }
            self.imageCache.set(forKey: self.urlString!, image: loadedImage)
            self.image = loadedImage
        }
    }
}

//缓存已加载过的词语图片
class ImageCache {
    var cache = NSCache<NSString, UIImage>()
    
    func get(forKey: String) -> UIImage? {
        return cache.object(forKey: NSString(string: forKey))
    }
    
    func set(forKey: String, image: UIImage) {
        cache.setObject(image, forKey: NSString(string: forKey))
    }
}
extension ImageCache {
    private static var imageCache = ImageCache()
    static func getImageCache() -> ImageCache {
        return imageCache
    }
}


// 词语
struct Word: Hashable, Codable {
    
    var id = UUID()
    
    var DBKey: Int
    var name: String
    var urlToImage: String?
    
    var type: WordType = WordType.Subject  //..........
    
    var isSelected: Bool = false  //...........
    
    enum CodingKeys: String, CodingKey {
        case DBKey = "_id"
        case name = "_name"
        case urlToImage = "_url"
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
struct WordList: Codable {
    var total: Int
    var list: [Word]
}

struct CategoryList: Codable {
    var total: Int
    var list: [Category]
}

struct PhraseList: Codable {
    var total: Int
    var list: [Phrase]
}

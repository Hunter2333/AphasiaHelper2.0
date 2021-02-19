//
//  DataModels.swift
//  AphasiaHelper2.0
//
//  Created by Xiaoqing Sun on 2020/12/15.
//

import Foundation
import SwiftUI


// -------------------为实现视图控制而定义的枚举类型-------------------
// AddView
enum TabsInAdd: String {
    case AddNewWord  // 添加词语
    case AddTodoItem  // 待办事项
}



// -------------------为实现功能逻辑而定义的枚举类型-------------------
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

// 可添加词语的类型
enum AddableType: String {
    case subject  // GET
    case predicate  // GET
    case second_object  // 添加宾语必须选定一个二级分类, GET
    case sentence  // POST
    case UNSET  // 用户未选定类别时
}



// -------------------用于数据加载的类型-------------------
// 加载词语列表 (父类)
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
    
    init(urlWordType: String, type: WordType, category_dbkey: Int? = nil, component_words: [Word]) {
        urlBase.append(urlWordType)
        wordType = type
        categoryDBKey = category_dbkey ?? -1  // 一级词语默认分类标签DBKey为-1 (无分类)
        componentWords = component_words
        loadMoreWords()
    }
    
    subscript(position: Int) -> Word {
        return words[position]
    }
    
    func clearOld(category_dbkey: Int? = nil, component_words: [Word]) {
        words.removeAll()
        nextPageToLoad = 1
        currentlyLoading = false
        doneLoading = false
        
        categoryDBKey = category_dbkey ?? -1  // 一级词语默认分类标签DBKey为-1 (无分类)
        componentWords = component_words
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
            // 检查是否在当前组成的一句话中，若在，修改isSelected为true
            if(componentWords.count > 0) {
                for i in 0..<componentWords.count {
                    for j in 0..<decodedResponse.list.count {
                        if(decodedResponse.list[j].type == componentWords[i].type && decodedResponse.list[j].DBKey == componentWords[i].DBKey) {
                            decodedResponse.list[j].isSelected = true
                            break
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

// 加载常用短语列表
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
    
    func clearOld() {
        phrases.removeAll()
        nextPageToLoad = 1
        currentlyLoading = false
        doneLoading = false
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

// 加载二级宾语分类标签的列表
class Categories: ObservableObject, RandomAccessCollection {
    
    typealias Element = Category
    
    @Published var categories = [Category]()
    
    var startIndex: Int { categories.startIndex }
    var endIndex: Int { categories.endIndex }
    var total = 30  // TODO: default infinity?
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

// 加载主语列表 (子类)
class Subjects: Words {
    
    // 检查是否在当前组成的一句话中，若在，修改isSelected为true
    init(component_words: [Word]) {
        super.init(urlWordType: "subject", type: WordType.Subject, component_words: component_words)
    }
}

// 加载谓语列表 (子类)
class Predicates: Words {
    
    // 检查是否在当前组成的一句话中，若在，修改isSelected为true
    init(component_words: [Word]) {
        super.init(urlWordType: "predicate", type: WordType.Predicate, component_words: component_words)
    }
}

// 加载宾语常用词列表 (子类)
class FrequentObjects: Words {
    
    // 检查是否在当前组成的一句话中，若在，修改isSelected为true
    init(component_words: [Word]) {
        super.init(urlWordType: "usual_object", type: WordType.Object, component_words: component_words)
    }
}

// 加载指定分类标签下的二级宾语列表 (子类)
class Lv2Objects: Words {
    
    // 检查是否在当前组成的一句话中，若在，修改isSelected为true
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
        if(urlString == "") {
            return
        }
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



// 保存摄像机刚拍摄的照片到本地相册
class ImageSaver: NSObject {
    
    func writeToPhotoAlbum(image: UIImage) {
        UIImageWriteToSavedPhotosAlbum(image, self, #selector(saveError), nil)
    }
    @objc func saveError(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
        print("Photo save finished!")
    }
}

// TODO: 获取图片目标检测的结果
class ImageObjectDetector: ObservableObject, RandomAccessCollection {
    
    typealias Element = ImageRecogResult
    
    @Published var image: UIImage?
    @Published var imageRecogResults = [ImageRecogResult]()
    
    var startIndex: Int { imageRecogResults.startIndex }
    var endIndex: Int { imageRecogResults.endIndex }
    
    var url: String = "http://47.102.158.185:8899/alg/predict"
    var componentWords = [Word]()
    var predictObjects = [PredictObject]()
    
    init(image: UIImage?) {
        if(image != nil) {
            self.image = image
        } else {
            self.image = nil
        }
        // 正常坐标系: x轴向右越来越大, y轴向上越来越大
        //self.predictObjects = [PredictObject(name: "狗", x1: 204, y1: 44, x2: 450, y2: 452, specInfo: SpecInfo(category: "动物", name: "狗", id: 524, url: "http://image.uniskare.xyz/image/object/动物/狗.png", wordType: "宾语")), PredictObject(name: "猫", x1: 38, y1: 121, x2: 290, y2: 400, specInfo: SpecInfo(category: "动物", name: "猫", id: 548, url: "http://image.uniskare.xyz/image/object/动物/猫.png", wordType: "宾语"))]
    }
    
    subscript(position: Int) -> ImageRecogResult {
        return imageRecogResults[position]
    }
    
    // 抠图
    func cropObjectsOnImage() -> [UIImage] {
        var result = [UIImage]()
        for i in 0..<predictObjects.count {
            let rect = CGRect(x: predictObjects[i].x1, y: Int(image!.size.height) - predictObjects[i].y2, width: abs(predictObjects[i].x2 - predictObjects[i].x1), height: abs(predictObjects[i].y2 - predictObjects[i].y1))
            let cgImage = image!.cgImage
            let croppedCGImage = cgImage!.cropping(to: rect)
            result.append(UIImage(cgImage: croppedCGImage!, scale: image!.scale, orientation: image!.imageOrientation))
        }
        return result
    }
    
    // 画识别框
    func drawRectanglesOnImage() -> UIImage {
        // 随机选取方框颜色 (识别出多少个物体就有多少个方框)
        let colors = [UIColor.red.cgColor, UIColor.green.cgColor, UIColor.orange.cgColor, UIColor.blue.cgColor, UIColor.yellow.cgColor, UIColor.purple.cgColor]
        let getRandom = randomSequenceGenerator(start: 0, end: colors.count - 1)
        
        // Create a context of the starting image size and set it as the current one
        UIGraphicsBeginImageContext(image!.size)
        // Draw the starting image in the current context as background
        image!.draw(at: CGPoint.zero)
        // Get the current context
        let context = UIGraphicsGetCurrentContext()!
        // Draw rectangles
        context.setLineWidth(3.0)
        // WARNING: 须确保 predictObjects.count > 0 !!!!
        for i in 0..<predictObjects.count {
            // 正常坐标系转图片坐标系
            // 图片坐标系: x轴向右越来越大, y轴向下越来越大
            let new_y1 = Int(image!.size.height) - predictObjects[i].y1
            let new_y2 = Int(image!.size.height) - predictObjects[i].y2
            context.setStrokeColor(colors[getRandom()])
            context.move(to: CGPoint(x: predictObjects[i].x1, y: new_y1))
            context.addLine(to: CGPoint(x: predictObjects[i].x2, y: new_y1))
            context.addLine(to: CGPoint(x: predictObjects[i].x2, y: new_y2))
            context.addLine(to: CGPoint(x: predictObjects[i].x1, y: new_y2))
            context.addLine(to: CGPoint(x: predictObjects[i].x1, y: new_y1))
            context.addLine(to: CGPoint(x: predictObjects[i].x2, y: new_y1))
            context.strokePath()
        }
        
        // Save the context as a new UIImage
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        // Return modified image
        return newImage!
    }
    
    func setIsSelected(pos: Int, val: Bool) {
        imageRecogResults[pos].word.isSelected = val
    }
    
    func updateImage(image: UIImage) {
        self.image = image
    }

    func updateComponentWords(componentWords: [Word]) {
        self.componentWords = componentWords
    }
    
    func clearOld() {
        self.image = nil
        self.imageRecogResults = [ImageRecogResult]()
        self.componentWords = [Word]()
        self.predictObjects = [PredictObject]()
    }
    
    func getPredictResult() {
        guard let endpoint = URL(string: url) else {
            print("Error creating endpoint")
            return
        }
        var request = URLRequest(url: endpoint)
        request.httpMethod = "POST"
        
        let boundary = "Boundary-\(UUID().uuidString)"
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        let mimeType = "image/jpg"
        
        let body = NSMutableData()
        let imageData = image!.jpegData(compressionQuality: 1.0)!
        let filename = "imageForObjectDetection.jpg"
        
        body.append("--\(boundary)\r\n".data(using: .utf8)!)
        body.append("Content-Disposition: form-data; name=\"pic\"; filename=\"\(filename)\"\r\n".data(using: .utf8)!)
        body.append("Content-Type: \(mimeType)\r\n\r\n".data(using: .utf8)!)
        body.append(imageData)
        body.append("\r\n".data(using: .utf8)!)
        body.append("--\(boundary)--\r\n".data(using: .utf8)!)
        
        request.httpBody = body as Data
        
        let task = URLSession.shared.dataTask(with: request, completionHandler: parseObjectsFromResponse(data:response:error:))
        task.resume()
    }
    
    func parseObjectsFromResponse(data: Data?, response: URLResponse?, error: Error?) {
        guard error == nil else {
            print("Error: \(error!)")
            return
        }
        guard let data = data else {
            print("No data found")
            return
        }
        
        let dataString = String(data: data, encoding: .utf8)
        print("——————————拍照识别结果——————————")
        print(dataString!)
        
        if let decodedResponse = try? JSONDecoder().decode(PredictResponse.self, from: data) {
            DispatchQueue.main.async {
                self.predictObjects = decodedResponse.rel
                // TODO: 拍照识别结果的页面展示-predictObjects未返回时显示加载页面, 返回predictObjects=[]为空时页面显示"未识别出任何目标"文字-因为需要明显的页面提示告诉用户等待的网络请求已返回结果
                if self.predictObjects.count > 0 {
                    self.image = self.drawRectanglesOnImage()
                    let croppedImages = self.cropObjectsOnImage()
                    for i in 0..<self.predictObjects.count {
                        // 填充词语的类型
                        var wordType = WordType.Subject
                        switch self.predictObjects[i].specInfo.wordType {
                        case "主语":
                            wordType = WordType.Subject
                        case "谓语":
                            wordType = WordType.Predicate
                        case "宾语":
                            wordType = WordType.Object
                        default:
                            break
                        }
                        // isSelected: 需要检查是否在当前组成的一句话中
                        var isSelected = false
                        for componentWord in self.componentWords {
                            if(wordType == componentWord.type && self.predictObjects[i].specInfo.id == componentWord.DBKey) {
                                isSelected = true
                            }
                        }
                        self.imageRecogResults.append(ImageRecogResult(img: croppedImages[i], word: Word(DBKey: self.predictObjects[i].specInfo.id, name: self.predictObjects[i].specInfo.name, urlToImage: self.predictObjects[i].specInfo.url, type: wordType, isSelected: isSelected)))
                    }
                }
            }
        } else {
            print(error ?? "")
        }
    }
}
extension ImageObjectDetector {
    
    //随机数生成器函数
    func randomSequenceGenerator(start: Int, end: Int) -> () ->Int {
        //根据参数初始化可选值数组
        var numbers: [Int] = []
        return {
            if numbers.isEmpty {
                numbers = Array(start ... end)
            }
            //随机返回一个数，同时从数组里删除
            let index = Int(arc4random_uniform(UInt32(numbers.count)))
            return numbers.remove(at: index)
        }
    }
}





// -------------------基础数据类型-------------------
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

// 拍照识别结果
struct ImageRecogResult: Identifiable {
    var id = UUID()
    var img: UIImage // 抠图
    var word: Word // 词语信息
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

struct PredictResponse: Codable {
    var isSuccess: Bool
    var rel: [PredictObject]
}

struct PredictObject: Codable {
    var name: String
    var x1: Int
    var y1: Int
    var x2: Int
    var y2: Int
    var specInfo: SpecInfo
}

struct SpecInfo: Codable {
    var category: String
    var name: String
    var id: Int
    var url: String
    var wordType: String
}

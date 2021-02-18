//
//  functions.swift
//  AphasiaHelper2.0
//
//  Created by Xiaoqing Sun on 2020/12/7.
//

import Foundation
import AVFoundation


// 朗读
func read(text: String) {
    var speechSynthesizer = AVSpeechSynthesizer()
    var speechUtterance: AVSpeechUtterance = AVSpeechUtterance(string: text)
    speechUtterance.rate = AVSpeechUtteranceMaximumSpeechRate / 4.0
    speechUtterance.voice = AVSpeechSynthesisVoice(language: "zh-CN")
    speechSynthesizer.speak(speechUtterance)
}


// 语音识别: Sound Visualizer 相关
func normalizeSoundLevel(level: Float) -> CGFloat {
    let level = max(0.2, CGFloat(level) + 50) / 2 // between 0.1 and 25
    //return CGFloat(level * (300 / 25)) // scaled to max at 300 (our height of our bar)
    return CGFloat(level * (50 / 25))
}


// 向后端插入词语 (主谓宾) 或 常用短语
func addItemToDB(type: AddableType, name: String, categoryDBKey: Int) {
    
    print("请求添加: \(type), \(name), \(categoryDBKey)")
    
    let urlBase = "http://47.102.158.185:8899/word/insert/\(type)"
    var urlString = ""
    if(type == AddableType.sentence) {
        urlString = "\(urlBase)?sentence=\(name)"
    } else if(type == AddableType.second_object) {
        urlString = "\(urlBase)?categoryId=\(categoryDBKey)&name=\(name)"
    } else {
        urlString = "\(urlBase)?name=\(name)"
    }
    
    guard let url = URL(string: urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!) else {
        print("Invalid Insert URL")
        return
    }
    var request = URLRequest(url: url)
    if(type == AddableType.sentence) {
        request.httpMethod = "POST"
    }
    
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

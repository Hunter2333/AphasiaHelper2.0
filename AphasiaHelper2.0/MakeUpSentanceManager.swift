//
//  MakeUpSentance.swift
//  AphasiaHelper2.0
//
//  Created by Xiaoqing Sun on 2020/12/14.
//

import Foundation

class MakeUpSentanceManager: ObservableObject {
    
    @Published var sentance: String = ""
    @Published var componentWords = [Word]()
    
    func addWord(word: Word) -> Void {
        
        sentance.append("\(word.name)")
        componentWords.append(word)
    }
    
    func removeLastWord() -> Void {
        if(componentWords.count > 0) {
            componentWords.removeLast()
            sentance = ""
            for componentWord in componentWords {
                sentance.append(componentWord.name)
            }
        } else {
            return
        }
    }
    
}

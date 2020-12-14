//
//  MakeUpSentance.swift
//  AphasiaHelper2.0
//
//  Created by Xiaoqing Sun on 2020/12/14.
//

import Foundation

class MakeUpSentance: ObservableObject {
    
    @Published var sentance: String = ""
    @Published var componentWords = [Word]()
}

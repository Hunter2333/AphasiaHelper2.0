//
//  functions.swift
//  AphasiaHelper2.0
//
//  Created by Xiaoqing Sun on 2020/12/7.
//

import AVFoundation

func read(text: String) {
    var speechSynthesizer = AVSpeechSynthesizer()
    var speechUtterance: AVSpeechUtterance = AVSpeechUtterance(string: text)
    speechUtterance.rate = AVSpeechUtteranceMaximumSpeechRate / 4.0
    speechUtterance.voice = AVSpeechSynthesisVoice(language: "zh-CN")
    speechSynthesizer.speak(speechUtterance)
}

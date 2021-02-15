//
//  SpeechRecogView.swift
//  AphasiaHelper2.0
//
//  Created by Xiaoqing Sun on 2021/2/14.
//

import SwiftUI

let numberOfSamples: Int = 50

struct SpeechRecogView: View {
    
    @State var isRecording: Bool = false
    @State var words = [Word]()
    @ObservedObject var mic = MicrophoneMonitor(numberOfSamples: numberOfSamples)
    
    var body: some View {
        GeometryReader { geo in
            VStack {
                VStack(spacing: 0) {
                    
                    HStack(spacing: 0) {
                        HStack(spacing: 4) {
                            ForEach(mic.soundSamples, id: \.self) { level in
                                SoundVisualizerBarView(value: normalizeSoundLevel(level: level))
                            }
                        }.padding(.leading, (geo.size.width - 20 - geo.size.height / 10) / 24 * 7)
                        Spacer()
                        Button(action: {
                            withAnimation {
                                isRecording.toggle()
                            }
                            if isRecording {
                                // 开始录音
                                mic.startMonitoring()
                            } else {
                                // 停止录音
                                mic.stopMonitoring()
                            }
                        }){
                            if isRecording {
                                Image(systemName: "stop.circle.fill")
                                    .font(.system(size: 26, weight: .bold))
                                    .foregroundColor(Color.red)
                            } else {
                                Image(systemName: "record.circle")
                                    .font(.system(size: 26, weight: .bold))
                                    .foregroundColor(Color.black)
                            }
                        }.padding(.trailing, 10)
                        Button(action: {
                            // TODO: 重置
                            words.removeAll()
                        }){
                            Image(systemName: "arrow.triangle.2.circlepath")
                                .font(.system(size: 23, weight: .bold))
                                .foregroundColor(Color.black)
                        }.padding(.trailing, 16)
                    }.frame(height: 70).padding(.bottom, 10)
                    
                    HStack(spacing: 0) {
                        VStack(spacing: 0) {
                            Text("我")
                                .foregroundColor(Color.black)
                                .font(.caption)
                                .bold()
                                .frame(width: 60, height: 30)
                                .background(Color(red: 233/255, green: 238/255, blue: 251/255))
                                .cornerRadius(10)
                            Button(action: {
                                // TODO
                                //                                read(text: "\(word.name)")
                                //                                addWord(type: word.type, DBKey: word.DBKey)
                            }){
                                VStack {
                                    UrlImageView(urlString: "")
                                    Text("我")
                                        .foregroundColor(Color.black)
                                        .font(.caption)
                                        .bold()
                                }
                                .frame(width: 60, height: 90)
                                .background(RoundedRectangle(cornerRadius: 10).fill(Color(red: 233/255, green: 238/255, blue:  251/255)))
                                //                                .overlay(word.isSelected ? RoundedRectangle(cornerRadius: 10).stroke(Color.black, lineWidth: 2) : RoundedRectangle(cornerRadius: 10).stroke(Color.black.opacity(0)))
                            }
                            .padding(.vertical, 8)
                            .padding(.horizontal, 5)
                        }
                        VStack(spacing: 0) {
                            Text("要")
                                .foregroundColor(Color.black)
                                .font(.caption)
                                .bold()
                                .frame(width: 60, height: 30)
                                .background(Color(red: 233/255, green: 238/255, blue: 251/255))
                                .cornerRadius(10)
                            Button(action: {
                                // TODO: 加入待办事项
                            }){
                                VStack(spacing: 0) {
                                    Image(systemName: "plus")
                                        .font(.system(size: 28, weight: .bold))
                                    Text("加入待办事项")
                                        .font(.system(size: 8))
                                        .bold()
                                        .padding(.top, 8)
                                }
                                .frame(width: 60, height: 90)
                                .foregroundColor(Color.black)
                                .background(RoundedRectangle(cornerRadius: 10).fill(Color(red: 233/255, green: 238/255, blue:  251/255)))
                            }
                            .padding(.vertical, 8)
                            .padding(.horizontal, 5)
                        }
                    }
                }
                .frame(width: geo.size.width - 20 - geo.size.height / 10, height: 240, alignment: .top)
                .background(RoundedRectangle(cornerRadius: 20).fill(Color.white))
                
                HStack {
                    Spacer()
                    Button(action: {
                        // TODO: 退出语音
                    }){
                        Text("退出语音")
                            .font(.footnote)
                            .bold()
                            .padding(.vertical, 10)
                            .padding(.horizontal, 50)
                            .foregroundColor(Color.red)
                            .background(RoundedRectangle(cornerRadius: 8).fill(Color.white))
                    }
                }
            }
            .frame(width: geo.size.width - 20 - geo.size.height / 10)
            .padding()
            .background(Color.black)
        }
    }
}

struct SpeechRecogView_Previews: PreviewProvider {
    static var previews: some View {
        SpeechRecogView()
    }
}

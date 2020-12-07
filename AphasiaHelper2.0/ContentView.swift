//
//  ContentView.swift
//  AphasiaHelper2.0
//
//  Created by Xiaoqing Sun on 2020/12/6.
//

import SwiftUI

struct ContentView: View {
    
    @State var sentance: String = ""
    
    // 主语
    let subjects: [Word] = [
            Word(id: 1, name: "你"),
            Word(id: 2, name: "我"),
            Word(id: 3, name: "他"),
            Word(id: 4, name: "这些")
        ]
    
    // 谓语
    let predicates: [Word] = [
            Word(id: 1, name: "是"),
            Word(id: 2, name: "要"),
            Word(id: 3, name: "吃"),
            Word(id: 4, name: "喝"),
            Word(id: 5, name: "去")
        ]
    
    // 宾语
    let objects: [Word] = [
            Word(id: 1, name: "咖啡"),
            Word(id: 2, name: "苹果"),
            Word(id: 3, name: "洗手间"),
            Word(id: 4, name: "笔记本"),
            Word(id: 5, name: "花")
        ]
    
    // 常用动作
    let activities: [Word] = [
            Word(id: 1, name: "回家"),
            Word(id: 2, name: "洗澡"),
            Word(id: 3, name: "画画"),
            Word(id: 4, name: "睡觉")
        ]
        
    var body: some View {
        
        GeometryReader { geo in
            
            HStack {
                // 左侧栏
                VStack {
                    Spacer()
                    VStack {
                        Button(action: {}) {
                            Image(systemName: "camera").font(.system(size: 40, weight: .regular))
                        }
                        .frame(width: 100, height: 100)
                        Button(action: {}) {
                            Image(systemName: "mic.fill").font(.system(size: 40, weight: .regular))
                        }
                        .frame(width: 100, height: 100)
                        Button(action: {}) {
                            Image(systemName: "paintpalette").font(.system(size: 40, weight: .regular))
                        }
                        .frame(width: 100, height: 100)
                    }.padding(.bottom, 30)
                }
                .foregroundColor(Color.white)
                .background(Color.black)
                .shadow(radius: 10)
                .frame(width: 100)
                
                
                // 选词区域
                VStack {
                    HStack {
                        VStack {
                            VStack {
                                HStack {
                                    Text("主语")
                                        .font(.title2)
                                        .bold()
                                    Spacer()
                                }
                                .frame(alignment: .topLeading)
                                ScrollView(.horizontal, showsIndicators: true) {
                                    HStack {
                                        ForEach(subjects, id: \.id) { word in
                                            WordBtnView(word: word, sentance: self.$sentance)
                                        }
                                    }
                                }
                            }
                            .frame(width: (geo.size.width - 110) * 0.75 - 80, height: (geo.size.height * 0.8 - 40) / 4)
                            .background(Color.green)
                            VStack {
                                HStack {
                                    Text("谓语")
                                        .font(.title2)
                                        .bold()
                                    Spacer()
                                }
                                .frame(alignment: .topLeading)
                                ScrollView(.horizontal, showsIndicators: true) {
                                    HStack {
                                        ForEach(predicates, id: \.id) { word in
                                            WordBtnView(word: word, sentance: self.$sentance)
                                        }
                                    }
                                }
                            }
                            .frame(width: (geo.size.width - 110) * 0.75 - 80, height: (geo.size.height * 0.8 - 40) / 4)
                            .background(Color.green)
                            VStack {
                                HStack {
                                    Text("宾语")
                                        .font(.title2)
                                        .bold()
                                    Spacer()
                                }
                                .frame(alignment: .topLeading)
                                ScrollView(.horizontal, showsIndicators: true) {
                                    HStack {
                                        ForEach(objects, id: \.id) { word in
                                            WordBtnView(word: word, sentance: self.$sentance)
                                        }
                                    }
                                }
                            }
                            .frame(width: (geo.size.width - 110) * 0.75 - 80, height: (geo.size.height * 0.8 - 40) / 4)
                            .background(Color.green)
                            VStack {
                                HStack {
                                    Text("常用动作")
                                        .font(.title2)
                                        .bold()
                                    Spacer()
                                }
                                .frame(alignment: .topLeading)
                                ScrollView(.horizontal, showsIndicators: true) {
                                    HStack {
                                        ForEach(activities, id: \.id) { word in
                                            WordBtnView(word: word, sentance: self.$sentance)
                                        }
                                    }
                                }
                            }
                            .frame(width: (geo.size.width - 110) * 0.75 - 80, height: (geo.size.height * 0.8 - 40) / 4)
                            .background(Color.green)
                        }
                        .frame(width: (geo.size.width - 110) * 0.75, height: geo.size.height * 0.8)
                        .background(Color.pink)
                        
                        VStack {
                            Text("推荐词语")
                        }
                        .frame(width: (geo.size.width - 110) * 0.25, height: geo.size.height * 0.8, alignment: .center)
                        .background(Color.gray)
                    }
                    HStack {
                        Text(self.sentance)
                            .font(.largeTitle)
                            .frame(width: (geo.size.width - 110 - geo.size.height * 0.2 * 0.6 * 2 - 120), height: geo.size.height * 0.2 * 0.6, alignment: .center)
                            .background(Color.pink)
                            .padding(10)
                        Button(action: {
                            read(text: self.sentance)
                        }){
                            Image(systemName: "play.fill")
                                .font(.system(size: 60, weight: .bold))
                                .frame(width: geo.size.height * 0.2 * 0.6, height: geo.size.height * 0.2 * 0.6, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                        }
                        .foregroundColor(Color.white)
                        .background(Color.green)
                        .cornerRadius(25)
                        .shadow(color: .gray, radius: 5, x: 2, y: 2)
                        .padding(10)
                        Button(action: {
                            self.sentance = ""
                        }){
                            Image(systemName: "clear.fill")
                                .font(.system(size: 60, weight: .bold))
                                .frame(width: geo.size.height * 0.2 * 0.6, height: geo.size.height * 0.2 * 0.6, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                        }
                        .foregroundColor(Color.white)
                        .background(Color.secondary)
                        .cornerRadius(25)
                        .shadow(color: .gray, radius: 5, x: 2, y: 2)
                        .padding(10)
                    }
                    .frame(width: geo.size.width - 110, height: geo.size.height * 0.2, alignment: .center)
                    .background(Color.orange)
                }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

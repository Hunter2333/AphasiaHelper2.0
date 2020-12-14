//
//  ContentView.swift
//  AphasiaHelper2.0
//
//  Created by Xiaoqing Sun on 2020/12/6.
//

import SwiftUI

struct ContentView: View {
    
    @EnvironmentObject var makeUpSentance: MakeUpSentance
    
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
            Word(id: 5, name: "花"),
            Word(id: 6, name: "医院"),
            Word(id: 7, name: "女儿"),
        ]
    
    // 二级宾语分类
    let categories: [Category] = [
            Category(id: 1, name: "食物"),
            Category(id: 2, name: "饮料"),
            Category(id: 3, name: "身体"),
            Category(id: 4, name: "日用品"),
            Category(id: 5, name: "家具"),
            Category(id: 6, name: "感受"),
            Category(id: 7, name: "人物"),
            Category(id: 8, name: "地点")
        ]
    
    // 常用短语
    let phrases: [Phrase] = [
            Phrase(id: 1, name: "我要吃饭"),
            Phrase(id: 2, name: "我要喝水"),
            Phrase(id: 3, name: "我想去厕所"),
            Phrase(id: 4, name: "我不知道"),
            Phrase(id: 5, name: "我感觉不舒服"),
            Phrase(id: 6, name: "我需要帮助"),
            Phrase(id: 7, name: "谢谢"),
            Phrase(id: 8, name: "这是什么")
        ]
    
    
    
        
    var body: some View {
        
        GeometryReader { geo in
            
            VStack {
                
                // 标题
                HStack {
                    Spacer()
                    Text("选词造句")
                        .font(.title)
                        .bold()
                    Spacer()
                }
                .foregroundColor(Color.white)
                .background(Color(red: 59/255, green: 142/255, blue: 136/255).frame(width: geo.size.width, height: 60))
                .frame(width: geo.size.width, height: 60, alignment: .center)
                
                
                // 组成的一句话
                HStack {
                    
                    Spacer()
                    HStack {
                        HStack {
                            // TODO ............
                            Text(self.makeUpSentance.sentance)
                                .font(.title2)
                                .foregroundColor(Color.black)
                        }
                        .frame(width: geo.size.width * 0.6 - 70, height: 60, alignment: .leading)
                        .offset(x: 50)
                        
                        Button(action: {
                            // TODO 智能识别
                        }){
                            Image(systemName: "camera").font(.system(size: 28, weight: .bold))
                        }
                        .foregroundColor(Color(red: 59/255, green: 142/255, blue: 136/255))
                        .frame(width: 70, height: 60, alignment: .center)
                        .offset(x: -12)
                    }
                    .background(Color.white.frame(width: geo.size.width * 0.6, height: 60))
                    .frame(width: geo.size.width * 0.6, height: 60)
                    .cornerRadius(30)
                    
                    
                    Spacer()
                    Button(action: {
                        read(text: self.makeUpSentance.sentance)
                        // TODO: 添加到常用短语
                    }){
                        Image(systemName: "speaker.wave.2").font(.system(size: 28, weight: .bold))
                    }
                    .padding(15.25)
                    .foregroundColor(Color(red: 59/255, green: 142/255, blue: 136/255))
                    .background(Color.white)
                    .clipShape(Circle())
                    
                    
                    Button(action: {
                        // 一次只清除一个词
                        // TODO.......更改WordBtn样式
                        self.makeUpSentance.componentWords.removeLast()
                        self.makeUpSentance.sentance = ""
                        for componentWord in self.makeUpSentance.componentWords {
                            self.makeUpSentance.sentance.append(componentWord.name)
                        }
                    }){
                        Image(systemName: "clear").font(.system(size: 32, weight: .bold))
                    }
                    .padding(13)
                    .foregroundColor(Color(red: 59/255, green: 142/255, blue: 136/255))
                    .background(Color.white)
                    .clipShape(Circle())
                    
                    
                    Spacer()
                    HStack {
                        Button(action: {
                            // TODO 添加词语
                        }){
                            Image(systemName: "plus").font(.system(size: 34, weight: .bold))
                        }
                        .padding(13)
                        .foregroundColor(Color(red: 59/255, green: 142/255, blue: 136/255))
                        .background(Color.white)
                        .clipShape(Circle())
                    }
                    .frame(width: 120, height: 120, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                }
                .background(Color(red: 59/255, green: 142/255, blue: 136/255).frame(width: geo.size.width, height: 120))
                .frame(width: geo.size.width, height: 120)
                
                
                // 选词区域
                VStack {
                    
                    Spacer()
                    
                    HStack {
                        
                        Spacer()
                        
                        // 主语
                        ZStack {
                            
                            RoundedRectangle(cornerRadius: 6)
                                .fill(Color.white)
                                .shadow(radius: 2)
                            
                            VStack {
                                
                                HStack {
                                    Text("主语")
                                        .font(.title3)
                                        .bold()
                                        .padding(.leading, 15)
                                    Spacer()
                                }
                                
                                ScrollView(.horizontal, showsIndicators: true) {
                                    HStack {
                                        ForEach(subjects, id: \.id) { word in
                                            WordBtnView(word: word)
                                        }
                                    }
                                }.padding(.leading, 15)

                                ScrollView(.horizontal, showsIndicators: true) {
                                    HStack {
                                        ForEach(subjects, id: \.id) { word in
                                            WordBtnView(word: word)
                                        }
                                    }
                                }.padding(.leading, 15)
                            }
                        }
                        
                        Spacer()
                        
                        // 谓语
                        ZStack {
                            
                            RoundedRectangle(cornerRadius: 6)
                                .fill(Color.white)
                                .shadow(radius: 2)
                            
                            VStack {
                                
                                HStack {
                                    Text("谓语")
                                        .font(.title3)
                                        .bold()
                                        .padding(.leading, 15)
                                    Spacer()
                                }
                                
                                ScrollView(.horizontal, showsIndicators: true) {
                                    HStack {
                                        ForEach(predicates, id: \.id) { word in
                                            WordBtnView(word: word)
                                        }
                                    }
                                }.padding(.leading, 15)

                                ScrollView(.horizontal, showsIndicators: true) {
                                    HStack {
                                        ForEach(predicates, id: \.id) { word in
                                            WordBtnView(word: word)
                                        }
                                    }
                                }.padding(.leading, 15)
                            }
                        }
                        
                        Spacer()
                    }
                    .frame(width: geo.size.width, height: (geo.size.height - 180 - 60) / 3)
                    
                    Spacer()
                    
                    // 宾语
                    HStack {
                        
                        Spacer()
                        
                        ZStack {
                            
                            RoundedRectangle(cornerRadius: 6)
                                .fill(Color.white)
                                .shadow(radius: 2)
                            
                            HStack {
                                
                                VStack {
                                    
                                    HStack(alignment: .firstTextBaseline) {
                                        Text("宾语")
                                            .font(.title2)
                                            .bold()
                                        Text("  常用词")
                                            .font(.body)
                                        Spacer()
                                    }
                                    .padding(.leading, 15)
                                    
                                    ScrollView(.horizontal, showsIndicators: true) {
                                        HStack {
                                            ForEach(objects, id: \.id) { word in
                                                WordBtnView(word: word)
                                            }
                                        }
                                    }.padding(.leading, 15)

                                    ScrollView(.horizontal, showsIndicators: true) {
                                        HStack {
                                            ForEach(objects, id: \.id) { word in
                                                WordBtnView(word: word)
                                            }
                                        }
                                    }.padding(.leading, 15)
                                    
                                    ScrollView(.horizontal, showsIndicators: true) {
                                        HStack {
                                            ForEach(objects, id: \.id) { word in
                                                WordBtnView(word: word)
                                            }
                                        }
                                    }.padding(.leading, 15)
                                }
                                .frame(width: (geo.size.width - 40) / 2 - 15, height: (geo.size.height - 180 - 60) / 2)
                                
                                Spacer()
                                
                                Rectangle()
                                    .fill(Color.gray.opacity(0.5))
                                    .frame(width: 2)
                                    .padding(.trailing, 5)
                                
                                VStack {

                                    // 宾语二级分类
                                    ScrollView(.horizontal, showsIndicators: true) {
                                        HStack {
                                            ForEach(categories, id: \.id) { category in
                                                CategoryBtnView(category: category)
                                                    .padding(.trailing, 10)
                                            }
                                        }
                                    }.padding(.leading, 60)
                                    
                                    ScrollView(.horizontal, showsIndicators: true) {
                                        HStack {
                                            ForEach(objects, id: \.id) { word in
                                                WordBtnView(word: word)
                                            }
                                        }
                                    }

                                    ScrollView(.horizontal, showsIndicators: true) {
                                        HStack {
                                            ForEach(objects, id: \.id) { word in
                                                WordBtnView(word: word)
                                            }
                                        }
                                    }
                                    
                                    ScrollView(.horizontal, showsIndicators: true) {
                                        HStack {
                                            ForEach(objects, id: \.id) { word in
                                                WordBtnView(word: word)
                                            }
                                        }
                                    }
                                }
                                .frame(width: (geo.size.width - 40) / 2, height: (geo.size.height - 180 - 60) / 2)
                            }
                        }
                        
                        Spacer()
                    }
                    .frame(width: geo.size.width, height: (geo.size.height - 180 - 60) / 2)
                    
                    Spacer()
                    
                    // 常用短语
                    HStack {
                        
                        Spacer()
                        
                        ZStack {
                            
                            RoundedRectangle(cornerRadius: 6)
                                .fill(Color.white)
                                .shadow(radius: 2)
                            
                            VStack {
                                
                                HStack {
                                    Text("常用短语")
                                        .font(.title3)
                                        .bold()
                                        .padding(.leading, 15)
                                    Spacer()
                                }
                                
                                ScrollView(.horizontal, showsIndicators: true) {
                                    HStack {
                                        ForEach(phrases, id: \.id) { phrase in
                                            PhraseBtnView(phrase: phrase)
                                                .padding(.trailing, 5)
                                        }
                                    }
                                }.padding(.leading, 15)
                            }
                        }
                        
                        Spacer()
                    }
                    .frame(width: geo.size.width, height: (geo.size.height - 180 - 60) / 6)
                    
                    Spacer()
                }
                .background(Color(red: 249/255, green: 247/255, blue: 243/255).frame(width: geo.size.width, height: geo.size.height - 180))
                .frame(width: geo.size.width, height: geo.size.height - 180)
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    
    static var previews: some View {
        ContentView().environmentObject(MakeUpSentance())
    }
}

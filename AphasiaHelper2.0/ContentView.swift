//
//  ContentView.swift
//  AphasiaHelper2.0
//
//  Created by Xiaoqing Sun on 2020/12/6.
//

import SwiftUI

struct ContentView: View {
    
    @EnvironmentObject var makeUpSentanceManager: MakeUpSentanceManager
    
    @EnvironmentObject var selectCategoryManager: SelectCategoryManager
    
    // 主语
    @State var subjects: [Word] = [
            Word(name: "你"),
            Word(name: "我"),
            Word(name: "他"),
            Word(name: "这些"),
        ]
    
    // 谓语
    @State var predicates: [Word] = [
            Word(name: "是"),
            Word(name: "要"),
            Word(name: "吃"),
            Word(name: "喝"),
            Word(name: "去"),
        ]
    
    // 宾语常用词
    @State var frequentObjects: [Word] = [
            Word(name: "咖啡"),
            Word(name: "苹果"),
            Word(name: "洗手间"),
            Word(name: "笔记本"),
            Word(name: "花"),
            Word(name: "医院"),
            Word(name: "女儿"),
        ]
    
    // 二级分类下的宾语词
    @State var lv2Objects: [Word] = [
            Word(name: "米饭"),
            Word(name: "蛋糕"),
            Word(name: "鸡蛋"),
            Word(name: "鸡肉"),
            Word(name: "羊肉"),
            Word(name: "茄子"),
            Word(name: "土豆"),
        ]
    
    // 常用短语
    @State var phrases: [Phrase] = [
            Phrase(name: "我不知道"),
            Phrase(name: "我感觉不舒服"),
            Phrase(name: "我需要帮助"),
            Phrase(name: "谢谢"),
        ]
    
    
    // 词语分页
    func splitArr(step: Int, arr: [Word]) -> [[Word]] {
        
        var result = [[Word]]()
        var itemsRemaining: Int = arr.count
        var j = 0
        while(itemsRemaining > 0) {
            let endIndex = j + min(step, itemsRemaining)
            let increment = endIndex - j
            let itemArr = [Word](arr[j..<endIndex])
            itemsRemaining -= increment
            j += increment
            result.append(itemArr)
        }
        return result
    }
    
    
        
    var body: some View {
        
        GeometryReader { geo in
            
            VStack(spacing: 0) {
                
                // 标题
                HStack {
                    Spacer()
                    Text("选词造句")
                        .font(.title)
                        .bold()
                    Spacer()
                }
                .foregroundColor(Color.white)
                .frame(width: geo.size.width, height: 60)
                .background(Color(red: 59/255, green: 142/255, blue: 136/255))
                
                
                // 组成的一句话
                HStack {
                    
                    Spacer()
                    HStack {
                        
                        ScrollView(.horizontal, showsIndicators: true) {
                            HStack {
                                ForEach(makeUpSentanceManager.componentWords, id: \.id) { componentWord in
                                    ComponentWordView(word: componentWord)
                                }
                            }
                        }
                        .padding(.leading, 50)
                        .frame(width: geo.size.width * 0.6 - 70, height: 60)
                        
                        
                        Button(action: {
                            // TODO 智能识别
                        }){
                            Image(systemName: "camera").font(.system(size: 28, weight: .bold))
                        }
                        .foregroundColor(Color(red: 59/255, green: 142/255, blue: 136/255))
                        .frame(width: 70, height: 60)
                        .offset(x: -12)
                    }
                    .frame(width: geo.size.width * 0.6, height: 60)
                    .background(Color.white)
                    .cornerRadius(30)
                    
                    
                    Spacer()
                    Button(action: {
                        if(makeUpSentanceManager.sentance.count > 0) {
                            read(text: makeUpSentanceManager.sentance)
                            phrases.append(Phrase(name: makeUpSentanceManager.sentance))
                            // TODO 新建该常用短语到后端, 词频置为1
                        }
                    }){
                        Image(systemName: "speaker.wave.2").font(.system(size: 28, weight: .bold))
                    }
                    .padding(15.25)
                    .foregroundColor(Color(red: 59/255, green: 142/255, blue: 136/255))
                    .background(Color.white)
                    .clipShape(Circle())
                    
                    
                    Button(action: {
                        // 一次只清除一个词
                        makeUpSentanceManager.removeLastWord()
                        // TODO.......更改WordBtn样式
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
                    .frame(width: 120, height: 120)
                }
                .frame(width: geo.size.width, height: 120)
                .background(Color(red: 59/255, green: 142/255, blue: 136/255))
                
                
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
                                        ForEach(splitArr(step: 2, arr: subjects), id: \.self) {
                                            arrSlice in
                                            VStack {
                                                ForEach(arrSlice, id: \.id) {
                                                    word in WordBtnView(word: word)
                                                }
                                                Spacer()
                                            }
                                        }
                                    }
                                }
                                .padding(.leading, 15)
                                .frame(height: 180)
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
                                        ForEach(splitArr(step: 2, arr: predicates), id: \.self) {
                                            arrSlice in
                                            VStack {
                                                ForEach(arrSlice, id: \.id) {
                                                    word in WordBtnView(word: word)
                                                }
                                                Spacer()
                                            }
                                        }
                                    }
                                }
                                .padding(.leading, 15)
                                .frame(height: 180)
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
                                            ForEach(splitArr(step: 3, arr: frequentObjects), id: \.self) {
                                                arrSlice in
                                                VStack {
                                                    ForEach(arrSlice, id: \.id) {
                                                        word in WordBtnView(word: word)
                                                    }
                                                    Spacer()
                                                }
                                            }
                                        }
                                    }
                                    .padding(.leading, 15)
                                    .frame(height: 270)
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
                                            ForEach(selectCategoryManager.categories, id: \.id) { category in
                                                CategoryBtnView(category: category)
                                                    .padding(.trailing, 10)
                                            }
                                        }
                                    }.padding(.leading, 60)
                                    
                                    ScrollView(.horizontal, showsIndicators: true) {
                                        HStack {
                                            ForEach(splitArr(step: 3, arr: lv2Objects), id: \.self) {
                                                arrSlice in
                                                VStack {
                                                    ForEach(arrSlice, id: \.id) {
                                                        word in WordBtnView(word: word)
                                                    }
                                                    Spacer()
                                                }
                                            }
                                        }
                                    }
                                    .frame(height: 270)
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
                .frame(width: geo.size.width, height: geo.size.height - 180)
                .background(Color(red: 249/255, green: 247/255, blue: 243/255))
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    
    static var previews: some View {
        ContentView().environmentObject(MakeUpSentanceManager()).environmentObject(SelectCategoryManager())
    }
}

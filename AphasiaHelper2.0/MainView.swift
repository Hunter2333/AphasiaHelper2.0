//
//  MainView.swift
//  AphasiaHelper2.0
//
//  Created by Xiaoqing Sun on 2021/1/2.
//

import SwiftUI

struct MainView: View {
    
    @EnvironmentObject var mainController: MainController
    
    var body: some View {
        GeometryReader { geo in
            
            VStack {
                
                // 组成的一句话
                HStack {
                    
                    Spacer()
                    
                    HStack {
                        HStack {
                            
                            ScrollView(.horizontal, showsIndicators: true) {
                                HStack {
                                    ForEach(mainController.componentWords, id: \.id) { componentWord in
                                        ComponentWordView(word: componentWord)
                                    }
                                }
                            }
                            .frame(width: geo.size.width - geo.size.height / 10 - 320)
                            .padding(.leading, 8)
                            
                            Button(action: {
                                // 语音识别
                                //................
                            }){
                                Image(systemName: "mic.fill").font(.system(size: 18, weight: .regular))
                            }
                            .foregroundColor(Color.secondary)
                            // TODO: 选中改为黑色
                            .padding(10)
                            .padding(.leading, 10)
                            
                            Button(action: {
                                // 拍照识别
                                //................
                            }){
                                Image(systemName: "camera.fill").font(.system(size: 18, weight: .regular))
                            }
                            .foregroundColor(Color.secondary)
                            // TODO: 选中改为黑色
                            .padding(10)
                            .padding(.trailing, 20)
                        }
                        .frame(height: geo.size.height / 10 - 40)
                        .background(Color(red: 245/255, green: 246/255, blue: 251/255))
                        .cornerRadius(10)
                        .padding(.leading, 10)
                        
                        
                        Button(action: {
                            // 朗读句子 & 添加到常用短语
                            if(mainController.sentence.count > 0) {
                                read(text: mainController.sentence)
                                let serialQueue = DispatchQueue(label: "serial")
                                serialQueue.sync {
                                    mainController.addPhrase(phrase: mainController.sentence)
                                }
                                serialQueue.sync {
                                    mainController.loadAllPhrases()
                                }
                            }
                        }){
                            Image(systemName: "speaker.wave.2").font(.system(size: 22, weight: .regular))
                        }
                        .foregroundColor(Color.white)
                        .padding(5)
                        .padding(.leading, 5)
                        
                        
                        Button(action: {
                            // 一次只清除一个词
                            mainController.removeLastWord()
                        }){
                            Image(systemName: "clear").font(.system(size: 20, weight: .regular))
                        }
                        .foregroundColor(Color.white)
                        .padding(5)
                        
                        Button(action: {
                            // 清空组成的句子
                            // Test
                            mainController.removeAllWords()
                        }){
                            Image(systemName: "arrow.triangle.2.circlepath").font(.system(size: 18, weight: .regular))
                        }
                        .foregroundColor(Color.white)
                        .padding(5)
                        .padding(.trailing, 20)
                    }
                    .frame(width: geo.size.width - 20 - geo.size.height / 10, height: geo.size.height / 10 - 20)
                    .background(Color(red: 41/255, green: 118/255, blue: 224/255))
                    .cornerRadius(20)
                    
                    
                    Button(action: {
                        // 添加词语
                        //................
                    }){
                        Image(systemName: "plus").font(.system(size: 36, weight: .regular))
                    }
                    .frame(width: geo.size.height / 10 - 20, height: geo.size.height / 10 - 20, alignment: .center)
                    .foregroundColor(Color.white)
                    .background(Color.black)
                    .cornerRadius(20)
                    
                    Spacer()
                }
                .frame(width: geo.size.width, height: geo.size.height / 10)
                
                
                Spacer()
                
                
                // 主语
                HStack {
                    
                    HStack {
                        Text("主语")
                            .font(.headline)
                            .bold()
                            .padding(.vertical, 6)
                            .padding(.horizontal, 16)
                            .foregroundColor(Color.white)
                            .background(Color.black)
                            .cornerRadius(15)
                            .padding(.leading, 10)
                            .padding(.top, 10)
                    }
                    .frame(width: geo.size.height / 5 - 20, height: geo.size.height / 5 - 20, alignment: .topLeading)
                    
                    ScrollView(.horizontal, showsIndicators: true) {
                        HStack {
                            ForEach(mainController.subjects, id: \.id) {
                                word in WordBtnView(word: word)
                            }
                        }
                    }
                }
                .frame(width: geo.size.width - 30, height: geo.size.height / 5 - 20)
                .background(Color(red: 245/255, green: 246/255, blue: 251/255))
                .cornerRadius(20)
                
                
                Spacer()
                
                
                // 谓语
                HStack {
                    
                    HStack {
                        Text("谓语")
                            .font(.headline)
                            .bold()
                            .padding(.vertical, 6)
                            .padding(.horizontal, 16)
                            .foregroundColor(Color.white)
                            .background(Color.black)
                            .cornerRadius(15)
                            .padding(.leading, 10)
                            .padding(.top, 10)
                    }
                    .frame(width: geo.size.height / 5 - 20, height: geo.size.height / 5 - 20, alignment: .topLeading)
                    
                    ScrollView(.horizontal, showsIndicators: true) {
                        HStack {
                            ForEach(mainController.predicates, id: \.id) {
                                word in WordBtnView(word: word)
                            }
                        }
                    }
                }
                .frame(width: geo.size.width - 30, height: geo.size.height / 5 - 20)
                .background(Color(red: 245/255, green: 246/255, blue: 251/255))
                .cornerRadius(20)
                
                
                Spacer()
                
                
                // 宾语
                HStack {
                    
                    HStack {
                        Text("宾语")
                            .font(.headline)
                            .bold()
                            .padding(.vertical, 6)
                            .padding(.horizontal, 16)
                            .foregroundColor(Color.white)
                            .background(Color.black)
                            .cornerRadius(15)
                            .padding(.leading, 10)
                            .padding(.top, 10)
                    }
                    .frame(width: geo.size.height / 5 - 20, height: geo.size.height / 5 * 2 - 20, alignment: .topLeading)
                    
                    VStack {
                        ScrollView(.horizontal, showsIndicators: true) {
                            HStack {
                                ForEach(mainController.frequentObjects, id: \.id) {
                                    word in WordBtnView(word: word)
                                }
                            }
                        }.padding(.top, 15)
                        ScrollView(.horizontal, showsIndicators: true) {
                            HStack {
                                ForEach(mainController.categories, id: \.id) { category in
                                    CategoryBtnView(category: category)
                                }
                            }
                        }
                        ScrollView(.horizontal, showsIndicators: true) {
                            HStack {
                                ForEach(mainController.lv2Objects, id: \.id) {
                                    word in WordBtnView(word: word)
                                }
                            }
                            Spacer()
                        }
                    }
                    .frame(alignment: .topLeading)
                }
                .frame(width: geo.size.width - 30, height: geo.size.height / 5 * 2 - 20)
                .background(Color(red: 245/255, green: 246/255, blue: 251/255))
                .cornerRadius(20)
                
                
                Spacer()
                
                
                // 常用短语
                HStack {
                    
                    HStack {
                        Text("常用短语")
                            .font(.headline)
                            .bold()
                            .padding(.vertical, 6)
                            .padding(.horizontal, 16)
                            .foregroundColor(Color.white)
                            .background(Color.black)
                            .cornerRadius(15)
                            .padding(.leading, 10)
                            .padding(.top, 10)
                    }
                    .frame(width: geo.size.height / 5 - 20, height: geo.size.height / 10, alignment: .topLeading)
                    
                    ScrollView(.horizontal, showsIndicators: true) {
                        HStack {
                            ForEach(mainController.phrases, id: \.id) { phrase in
                                PhraseBtnView(phrase: phrase)
                                    .padding(.trailing, 10)
                            }
                        }
                    }
                }
                .frame(width: geo.size.width - 30, height: geo.size.height / 10)
                .background(Color(red: 245/255, green: 246/255, blue: 251/255))
                .cornerRadius(20)
                .padding(.bottom, 20)
            }
            .onAppear(perform: self.mainController.loadAll)
        }
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView().environmentObject(MainController())
    }
}

//
//  MainView.swift
//  AphasiaHelper2.0
//
//  Created by Xiaoqing Sun on 2021/1/2.
//

import SwiftUI

struct MainView: View {
    
    // 主语
    @ObservedObject var subjects = Subjects()
    
    // 谓语
    @ObservedObject var predicates = Predicates()
    
    // 宾语常用词
    @ObservedObject var frequentObjects = FrequentObjects()
    
    // 当前选中的那个宾语二级分类标签在categories中的下标
    @State var selectedCategoryIndex: Int = 0
    // 宾语二级分类的所有标签
    @ObservedObject var categories = Categories()
    
    // 二级宾语
    // TODO: default 80?
    @ObservedObject var lv2Objects = Lv2Objects(category_dbkey: 80, component_words: [Word]())
    
    // 形容词
    @ObservedObject var adjectives = Adjectives()
    
    // 其他词库词语
    @ObservedObject var otherWords = OtherWords()
    
    // 常用短语
    @ObservedObject var phrases = Phrases()
    
    // 组成的一句话
    @State var sentence: String = ""
    @State var componentWords = [Word]()
    
    
    // 添加词语 & 添加待办事项相关
    @State var showAddView: Bool = false
    @State var selectedTab: TabsInAdd = TabsInAdd.AddNewWord
    @State var name: String = ""
    @State var type: AddableType = AddableType.UNSET
    @State var expanded: Bool = false
    @State var selectedCategory: Category = Category(DBKey: -1, name: "null", isSelected: false)
    // TODO: 添加待办事项---确保至少上传了一张照片
    var finishBtnIsDisabled: Bool {
        return (name == "") || (type == AddableType.UNSET) || ((type == AddableType.second_object) && (selectedCategory.DBKey == -1))
    }
    
    
    // 拍照识别相关
    @State var showCameraView: Bool = false
    @State var showImagePicker: Bool = false
    @State var image: UIImage?
    @State var showImageSaveToLocalResult: Bool = false
    
    
    
    var body: some View {
        GeometryReader { geo in
            
            ZStack {
                
                VStack {
                    
                    // 组成的一句话
                    HStack {
                        
                        Spacer()
                        
                        HStack {
                            HStack {
                                
                                ScrollView(.horizontal, showsIndicators: true) {
                                    HStack {
                                        ForEach(componentWords, id: \.id) { componentWord in
                                            ComponentWordView(word: componentWord)
                                        }
                                    }
                                }
                                .frame(width: geo.size.width - geo.size.height / 10 - 320)
                                .padding(.leading, 8)
                                
                                Button(action: {
                                    // TODO: 语音识别
                                }){
                                    Image(systemName: "mic.fill").font(.system(size: 18, weight: .regular))
                                }
                                .foregroundColor(Color.secondary)
                                // TODO: 选中改为黑色
                                .padding(10)
                                .padding(.leading, 10)
                                
                                Button(action: {
                                    // 拍照识别
                                    showCameraView = true
                                    showImagePicker = true
                                    showAddView = false
                                    // TODO: 语音
                                }){
                                    Image(systemName: "camera.fill").font(.system(size: 18, weight: .regular))
                                }
                                .foregroundColor(showCameraView ? Color(red: 26/255, green: 26/255, blue: 55/255) : Color.secondary)
                                .padding(10)
                                .padding(.trailing, 20)
                                .disabled(showCameraView)
                            }
                            .frame(height: geo.size.height / 10 - 40)
                            .background(Color(red: 245/255, green: 246/255, blue: 251/255))
                            .cornerRadius(10)
                            .padding(.leading, 10)
                            
                            
                            Button(action: {
                                // 朗读句子 & 添加到常用短语
                                if(sentence.count > 0) {
                                    read(text: sentence)
                                    addItemToDB(type: AddableType.sentence, name: sentence, categoryDBKey: -1)
                                    // 更新前端常用短语显示
                                    phrases.clearOld()
                                    phrases.loadMorePhrases()
                                }
                            }){
                                Image(systemName: "speaker.wave.2").font(.system(size: 22, weight: .regular))
                            }
                            .foregroundColor(Color.white)
                            .padding(5)
                            .padding(.leading, 5)
                            
                            
                            Button(action: {
                                // 一次只清除一个词
                                removeLastWord()
                            }){
                                Image(systemName: "clear").font(.system(size: 20, weight: .regular))
                            }
                            .foregroundColor(Color.white)
                            .padding(5)
                            
                            Button(action: {
                                // 清空组成的句子
                                removeAllWords()
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
                            // 添加词语 & 待办事项
                            withAnimation {
                                showCameraView = false
                                showImagePicker = false
                                showAddView = true
                                // TODO: 语音
                            }
                        }){
                            Image(systemName: "plus").font(.system(size: 36, weight: .regular))
                        }
                        .frame(width: geo.size.height / 10 - 20, height: geo.size.height / 10 - 20, alignment: .center)
                        .foregroundColor(Color.white)
                        .background(Color(red: 26/255, green: 26/255, blue: 55/255))
                        .cornerRadius(20)
                        
                        Spacer()
                    }
                    .frame(width: geo.size.width, height: geo.size.height / 10)
                    
                    
                    Spacer()
                    
                    
                    VStack {
                        if showCameraView && !showImagePicker && (image != nil) {
                            // TODO: 拍照识别结果
                            HStack {
                                VStack(spacing: 0) {
                                    Text("识别结果1")
                                        .font(.title)
                                        .bold()
                                    Text("识别结果2")
                                        .font(.title)
                                        .bold()
                                        .padding(.bottom, 16)
                                    HStack {
                                        Button(action: {
                                            let imageSaver = ImageSaver()
                                            imageSaver.writeToPhotoAlbum(image: image!)
                                            // 提示图片保存成功
                                            showImageSaveToLocalResult = true
                                        }) {
                                            Text("保存照片")
                                                .font(.footnote)
                                                .bold()
                                                .padding(.vertical, 8)
                                                .padding(.horizontal, 12)
                                                .foregroundColor(Color.white)
                                                .background(RoundedRectangle(cornerRadius: 8).fill(Color(red: 41/255, green: 118/255, blue: 224/255)))
                                        }.alert(isPresented: $showImageSaveToLocalResult) { () -> Alert in Alert(title: Text("✅图片保存成功"), message: Text("图片已成功保存至本地相册"), dismissButton: .default(Text("确定")))
                                        }
                                        Button(action: {
                                            showImagePicker = true
                                        }) {
                                            Text("重新取词")
                                                .font(.footnote)
                                                .bold()
                                                .padding(.vertical, 8)
                                                .padding(.horizontal, 12)
                                                .foregroundColor(Color.white)
                                                .background(RoundedRectangle(cornerRadius: 8).fill(Color(red: 41/255, green: 118/255, blue: 224/255)))
                                                .padding(.leading, 6)
                                        }
                                    }.padding(.bottom, 10)
                                    Button(action: {
                                        showCameraView = false
                                        showImagePicker = false
                                    }) {
                                        Text("退出相机")
                                            .font(.footnote)
                                            .bold()
                                            .padding(.vertical, 8)
                                            .padding(.horizontal, 58)
                                            .foregroundColor(Color.red)
                                            .background(RoundedRectangle(cornerRadius: 8).fill(Color(red: 245/255, green: 246/255, blue: 251/255)))
                                    }
                                }
                                .frame(width: geo.size.width / 5 + 22, height: geo.size.height / 10 * 9 - 40)
                                .background(Color(red: 233/255, green: 238/255, blue:  251/255))
                                .cornerRadius(20)
                                .padding(.leading, 30)
                                .padding(.bottom, 30)
                                Spacer()
                                // TODO: image -> 画出了识别框的Image
                                Image(uiImage: image ?? UIImage(named: "PlaceHolder")!)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: geo.size.width / 5 * 4 - 32, height: geo.size.height / 10 * 9 - 40)
                                    .padding(.bottom, 30)
                            }
                        } else {
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
                                    LazyHStack {
                                        ForEach(subjects, id: \.id) { word in
                                            Button(action: {
                                                read(text: "\(word.name)")
                                                addWord(type: word.type, DBKey: word.DBKey)
                                            }){
                                                VStack {
                                                    UrlImageView(urlString: word.urlToImage)
                                                    Text("\(word.name)")
                                                        .foregroundColor(Color.black)
                                                        .font(.caption)
                                                        .bold()
                                                }
                                                .frame(width: 60, height: 90)
                                                .background(RoundedRectangle(cornerRadius: 10).fill(Color(red: 233/255, green: 238/255, blue:  251/255)))
                                                .overlay(word.isSelected ? RoundedRectangle(cornerRadius: 10).stroke(Color.black, lineWidth: 2) : RoundedRectangle(cornerRadius: 10).stroke(Color.black.opacity(0)))
                                            }
                                            .padding(10)
                                            .onAppear { subjects.loadMoreWords(currentItem: word) }
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
                                    LazyHStack {
                                        ForEach(predicates, id: \.id) { word in
                                            Button(action: {
                                                read(text: "\(word.name)")
                                                addWord(type: word.type, DBKey: word.DBKey)
                                            }){
                                                VStack {
                                                    UrlImageView(urlString: word.urlToImage)
                                                    Text("\(word.name)")
                                                        .foregroundColor(Color.black)
                                                        .font(.caption)
                                                        .bold()
                                                }
                                                .frame(width: 60, height: 90)
                                                .background(RoundedRectangle(cornerRadius: 10).fill(Color(red: 233/255, green: 238/255, blue:  251/255)))
                                                .overlay(word.isSelected ? RoundedRectangle(cornerRadius: 10).stroke(Color.black, lineWidth: 2) : RoundedRectangle(cornerRadius: 10).stroke(Color.black.opacity(0)))
                                            }
                                            .padding(10)
                                            .onAppear { predicates.loadMoreWords(currentItem: word) }
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
                                        LazyHStack {
                                            ForEach(frequentObjects, id: \.id) { word in
                                                Button(action: {
                                                    read(text: "\(word.name)")
                                                    addWord(type: word.type, DBKey: word.DBKey)
                                                }){
                                                    VStack {
                                                        UrlImageView(urlString: word.urlToImage)
                                                        Text("\(word.name)")
                                                            .foregroundColor(Color.black)
                                                            .font(.caption)
                                                            .bold()
                                                    }
                                                    .frame(width: 60, height: 90)
                                                    .background(RoundedRectangle(cornerRadius: 10).fill(Color(red: 233/255, green: 238/255, blue:  251/255)))
                                                    .overlay(word.isSelected ? RoundedRectangle(cornerRadius: 10).stroke(Color.black, lineWidth: 2) : RoundedRectangle(cornerRadius: 10).stroke(Color.black.opacity(0)))
                                                }
                                                .padding(10)
                                                .onAppear { frequentObjects.loadMoreWords(currentItem: word) }
                                            }
                                        }
                                    }.padding(.top, 15)
                                    ScrollView(.horizontal, showsIndicators: true) {
                                        HStack {
                                            ForEach(categories, id: \.id) { category in
                                                Button(action: {
                                                    updateCategoryBtnViews(selectedCategoryDBKey: category.DBKey)
                                                }){
                                                    Text("\(category.name)")
                                                        .font(.caption2)
                                                        .padding(.horizontal, 18)
                                                        .padding(.vertical, 4)
                                                        .foregroundColor(category.isSelected ? Color.white : Color.black)
                                                        .background(category.isSelected ? Color.black : Color(red: 233/255, green: 238/255, blue: 251/255))
                                                        .cornerRadius(5)
                                                }.padding(5)
                                            }
                                        }
                                    }
                                    // 确保加载完categories再加载Lv2ObjectsView
                                    if categories.doneLoading {
                                        ScrollView(.horizontal, showsIndicators: true) {
                                            LazyHStack {
                                                ForEach(lv2Objects, id: \.id) { word in
                                                    Button(action: {
                                                        read(text: "\(word.name)")
                                                        addWord(type: word.type, DBKey: word.DBKey)
                                                    }){
                                                        VStack {
                                                            UrlImageView(urlString: word.urlToImage)
                                                            Text("\(word.name)")
                                                                .foregroundColor(Color.black)
                                                                .font(.caption)
                                                                .bold()
                                                        }
                                                        .frame(width: 60, height: 90)
                                                        .background(RoundedRectangle(cornerRadius: 10).fill(Color(red: 233/255, green: 238/255, blue:  251/255)))
                                                        .overlay(word.isSelected ? RoundedRectangle(cornerRadius: 10).stroke(Color.black, lineWidth: 2) : RoundedRectangle(cornerRadius: 10).stroke(Color.black.opacity(0)))
                                                    }
                                                    .padding(10)
                                                    .onAppear { lv2Objects.loadMoreWords(currentItem: word) }
                                                }
                                            }
                                            Spacer()
                                        }
                                    } else {
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
                                    LazyHStack {
                                        ForEach(phrases, id: \.id) { phrase in
                                            PhraseBtnView(phrase: phrase).padding(.trailing, 10).onAppear { phrases.loadMorePhrases(currentItem: phrase) }
                                        }
                                    }
                                }
                            }
                            .frame(width: geo.size.width - 30, height: geo.size.height / 10)
                            .background(Color(red: 245/255, green: 246/255, blue: 251/255))
                            .cornerRadius(20)
                            .padding(.bottom, 20)
                        }
                    }
                }
                
                if showAddView {
                    VStack {
                        Spacer().frame(height: geo.size.height / 10)
                        HStack {
                            Spacer()
                            VStack(spacing: 0) {
                                
                                HStack {
                                    Spacer()
                                    Button(action: {
                                        // TODO: Animation?
                                        showAddView = false
                                    }){
                                        Image(systemName: "xmark").font(.system(size: 10, weight: .bold))
                                            .padding(5)
                                            .foregroundColor(Color(red: 26/255, green: 26/255, blue: 55/255))
                                            .background(Color.white.opacity(0.4))
                                            .clipShape(/*@START_MENU_TOKEN@*/Circle()/*@END_MENU_TOKEN@*/)
                                    }.padding(10)
                                }
                                
                                HStack {
                                    Button(action: {
                                        name = ""
                                        type = AddableType.UNSET
                                        expanded = false
                                        selectedCategory = Category(DBKey: -1, name: "null", isSelected: false)
                                        // TODO: 照片初始化为空
                                        
                                        selectedTab = TabsInAdd.AddNewWord
                                    }){
                                        Text("添加词语")
                                            .font(.system(size: 16))
                                            .bold()
                                            .frame(width: 116, height: 32, alignment: .center)
                                            .foregroundColor((selectedTab == TabsInAdd.AddNewWord) ? Color.white : Color.white.opacity(0.25))
                                            .background((selectedTab == TabsInAdd.AddNewWord) ? Color(red: 41/255, green: 118/255, blue: 224/255) : Color.white.opacity(0.1))
                                            .cornerRadius(8)
                                    }.padding(.trailing, 5)
                                    Button(action: {
                                        name = ""
                                        type = AddableType.UNSET
                                        expanded = false
                                        selectedCategory = Category(DBKey: -1, name: "null", isSelected: false)
                                        // TODO: 照片初始化为空
                                        
                                        selectedTab = TabsInAdd.AddTodoItem
                                    }){
                                        Text("待办事项")
                                            .font(.system(size: 16))
                                            .bold()
                                            .frame(width: 116, height: 32, alignment: .center)
                                            .foregroundColor((selectedTab == TabsInAdd.AddTodoItem) ? Color.white : Color.white.opacity(0.25))
                                            .background((selectedTab == TabsInAdd.AddTodoItem) ? Color(red: 41/255, green: 118/255, blue: 224/255) : Color.white.opacity(0.1))
                                            .cornerRadius(8)
                                    }
                                }
                                .padding(.top, 5)
                                .padding(.bottom, 20)
                                
                                VStack(spacing: 0){
                                    VStack {
                                        HStack {
                                            Text("词语")
                                                .font(.caption)
                                                .bold()
                                                .foregroundColor(Color.white)
                                                .padding(.leading, 28)
                                            Spacer()
                                        }
                                        ZStack(alignment: .leading) {
                                            if name.isEmpty {
                                                Text("请输入文本")
                                                    .padding(10)
                                                    .font(.caption)
                                                    .foregroundColor(Color.white.opacity(0.25))
                                                
                                            }
                                            TextField("", text: $name)
                                                .padding(10)
                                                .font(.caption)
                                                .frame(width: 245, height: 32)
                                                .foregroundColor(Color.white)
                                                .background(Color.white.opacity(0.1))
                                                .cornerRadius(8)
                                        }
                                    }.padding(.bottom, 20)
                                    
                                    VStack {
                                        HStack {
                                            Text("类别")
                                                .font(.caption)
                                                .bold()
                                                .foregroundColor(Color.white)
                                                .padding(.leading, 28)
                                            Spacer()
                                        }
                                        HStack {
                                            Button(action: {
                                                type = AddableType.subject
                                            }){
                                                Text("主语")
                                                    .font(.caption)
                                                    .padding(.horizontal, 12)
                                                    .padding(.vertical, 6)
                                                    .foregroundColor((type == AddableType.subject) ? Color.white : Color.white.opacity(0.25))
                                                    .background((type == AddableType.subject) ? Color(red: 41/255, green: 118/255, blue: 224/255) : Color.white.opacity(0.1))
                                                    .cornerRadius(8)
                                            }
                                            Button(action: {
                                                type = AddableType.predicate
                                            }){
                                                Text("谓语")
                                                    .font(.caption)
                                                    .padding(.horizontal, 12)
                                                    .padding(.vertical, 6)
                                                    .foregroundColor((type == AddableType.predicate) ? Color.white : Color.white.opacity(0.25))
                                                    .background((type == AddableType.predicate) ? Color(red: 41/255, green: 118/255, blue: 224/255) : Color.white.opacity(0.1))
                                                    .cornerRadius(8)
                                            }
                                            Button(action: {
                                                type = AddableType.second_object
                                            }){
                                                Text("宾语")
                                                    .font(.caption)
                                                    .padding(.horizontal, 12)
                                                    .padding(.vertical, 6)
                                                    .foregroundColor((type == AddableType.second_object) ? Color.white : Color.white.opacity(0.25))
                                                    .background((type == AddableType.second_object) ? Color(red: 41/255, green: 118/255, blue: 224/255) : Color.white.opacity(0.1))
                                                    .cornerRadius(8)
                                            }
                                            Button(action: {
                                                type = AddableType.sentence
                                            }){
                                                Text("常用短语")
                                                    .font(.caption)
                                                    .padding(.horizontal, 12)
                                                    .padding(.vertical, 6)
                                                    .foregroundColor((type == AddableType.sentence) ? Color.white : Color.white.opacity(0.25))
                                                    .background((type == AddableType.sentence) ? Color(red: 41/255, green: 118/255, blue: 224/255) : Color.white.opacity(0.1))
                                                    .cornerRadius(8)
                                            }
                                        }
                                    }.padding(.bottom, 20)
                                    
                                    if(type == AddableType.second_object) {
                                        VStack {
                                            HStack {
                                                Text("子类别")
                                                    .font(.caption)
                                                    .bold()
                                                    .foregroundColor(Color.white)
                                                    .padding(.leading, 28)
                                                Spacer()
                                            }
                                            DisclosureGroup((selectedCategory.DBKey == -1) ? "选择子类别" : selectedCategory.name, isExpanded: $expanded) {
                                                ScrollView(.vertical, showsIndicators: true) {
                                                    VStack {
                                                        if categories.doneLoading {
                                                            ForEach(categories, id: \.id) { category in
                                                                Button(action: {
                                                                    selectedCategory = category
                                                                    withAnimation {
                                                                        expanded.toggle()
                                                                    }
                                                                }) {
                                                                    HStack {
                                                                        Text(category.name)
                                                                            .padding(5)
                                                                            .font(.caption)
                                                                        Spacer()
                                                                    }.frame(maxWidth: .infinity)
                                                                }
                                                            }
                                                        } else {
                                                            Text("加载中...")
                                                        }
                                                    }.foregroundColor(Color.white)
                                                }.frame(height: 120)
                                            }
                                            .padding(.horizontal, 10)
                                            .padding(.vertical, 4.75)
                                            .font(.caption)
                                            .frame(width: 245)
                                            .accentColor(Color.white.opacity(0.25))
                                            .foregroundColor((selectedCategory.DBKey == -1) ? Color.white.opacity(0.25) : Color.white)
                                            .background(Color.white.opacity(0.1))
                                            .cornerRadius(8)
                                        }.padding(.bottom, 20)
                                    }
                                    
                                    if(selectedTab == TabsInAdd.AddTodoItem) {
                                        // TODO: 上传照片
                                        Text("上传照片: 建设中...")
                                            .foregroundColor(Color.white)
                                            .padding(.bottom, 80)
                                    }
                                    
                                    Button(action: {
                                        switch selectedTab {
                                        case TabsInAdd.AddNewWord:
                                            addItemToDB(type: type, name: name, categoryDBKey: selectedCategory.DBKey)
                                            // 刷新界面数据
                                            switch type {
                                            case AddableType.subject:
                                                subjects.clearOld()
                                                subjects.loadMoreWords()
                                            case AddableType.predicate:
                                                predicates.clearOld()
                                                predicates.loadMoreWords()
                                            case AddableType.second_object:
                                                frequentObjects.clearOld()
                                                frequentObjects.loadMoreWords()
                                                if(selectedCategory.DBKey == categories[selectedCategoryIndex].DBKey){
                                                    lv2Objects.clearOld(category_dbkey: selectedCategory.DBKey, component_words: componentWords)
                                                    lv2Objects.loadMoreWords()
                                                }
                                            case AddableType.sentence:
                                                phrases.clearOld()
                                                phrases.loadMorePhrases()
                                            case AddableType.UNSET:
                                                print("Cannot refresh: AddableType.UNSET ERROR!")
                                            }
                                        case TabsInAdd.AddTodoItem:
                                            // TODO: 调用添加待办事项的func
                                            print("调用添加待办事项的func")
                                        }
                                    }){
                                        Text("完成")
                                            .font(.caption)
                                            .bold()
                                            .frame(width: 245, height: 32, alignment: .center)
                                            .foregroundColor(Color.white)
                                            .background(RoundedRectangle(cornerRadius: 8).fill(Color(red: 41/255, green: 118/255, blue: 224/255)))
                                            .overlay(finishBtnIsDisabled ? RoundedRectangle(cornerRadius: 8).fill(Color.white.opacity(0.5)) : RoundedRectangle(cornerRadius: 8).fill(Color.white.opacity(0)))
                                    }
                                    .padding(.bottom, 30)
                                    .disabled(finishBtnIsDisabled)
                                    
                                    // TODO: 显示添加结果
                                }
                                
                            }
                            .frame(width: 300)
                            .background(Color(red: 26/255, green: 26/255, blue: 55/255))
                            .cornerRadius(20)
                            .padding(.trailing, 15)
                        }
                        Spacer()
                    }
                }
            }.fullScreenCover(isPresented: $showImagePicker) {
                // 调用摄像头拍照
                ImagePicker(image: self.$image, isShown: self.$showImagePicker, isShowCameraView: self.$showCameraView, sourceType: .camera)
            }
        }
    }
    
    
    
    //--------------------------functions-------------------------
    // 删除组成的句子中最后一个词
    func removeLastWord() -> Void {
        if(componentWords.count > 0) {
            
            switch componentWords[componentWords.count - 1].type {
            case .Subject:
                for i in 0..<subjects.count {
                    if(subjects[i].DBKey == componentWords[componentWords.count - 1].DBKey) {
                        subjects.setIsSelected(pos: i, val: false)
                        break
                    }
                }
            case .Predicate:
                for i in 0..<predicates.count {
                    if(predicates[i].DBKey == componentWords[componentWords.count - 1].DBKey) {
                        predicates.setIsSelected(pos: i, val: false)
                        break
                    }
                }
            case .Object:
                // 宾语常用词和二级宾语 isSelected 联动
                for i in 0..<frequentObjects.count {
                    if(frequentObjects[i].DBKey == componentWords[componentWords.count - 1].DBKey) {
                        frequentObjects.setIsSelected(pos: i, val: false)
                        break
                    }
                }
                for i in 0..<lv2Objects.count {
                    if(lv2Objects[i].DBKey == componentWords[componentWords.count - 1].DBKey) {
                        lv2Objects.setIsSelected(pos: i, val: false)
                        break
                    }
                }
            case .Adjective:
                for i in 0..<adjectives.count {
                    if(adjectives[i].DBKey == componentWords[componentWords.count - 1].DBKey) {
                        adjectives.setIsSelected(pos: i, val: false)
                        break
                    }
                }
            case .Other:
                for i in 0..<otherWords.count {
                    if(otherWords[i].DBKey == componentWords[componentWords.count - 1].DBKey) {
                        otherWords.setIsSelected(pos: i, val: false)
                        break
                    }
                }
            }
            
            componentWords.removeLast()
            sentence = ""
            for componentWord in componentWords {
                sentence.append(componentWord.name)
            }
        }
    }
    
    
    // 清空组成的句子
    func removeAllWords() -> Void {
        
        if(componentWords.count > 0) {
            for i in 0..<subjects.count {
                if(subjects[i].isSelected) {
                    subjects.setIsSelected(pos: i, val: false)
                }
            }
            for i in 0..<predicates.count {
                if(predicates[i].isSelected) {
                    predicates.setIsSelected(pos: i, val: false)
                }
            }
            for i in 0..<frequentObjects.count {
                if(frequentObjects[i].isSelected) {
                    frequentObjects.setIsSelected(pos: i, val: false)
                }
            }
            for i in 0..<lv2Objects.count {
                if(lv2Objects[i].isSelected) {
                    lv2Objects.setIsSelected(pos: i, val: false)
                }
            }
            for i in 0..<adjectives.count {
                if(adjectives[i].isSelected) {
                    adjectives.setIsSelected(pos: i, val: false)
                }
            }
            for i in 0..<otherWords.count {
                if(otherWords[i].isSelected) {
                    otherWords.setIsSelected(pos: i, val: false)
                }
            }
            
            componentWords.removeAll()
            sentence = ""
        }
    }
    
    
    // 切换标签: 同时只能有一个二级分类标签被选中, 初次打开页面时默认为第一个
    func updateCategoryBtnViews(selectedCategoryDBKey: Int) -> Void {
        
        if(categories[selectedCategoryIndex].DBKey != selectedCategoryDBKey) {
            
            categories.setIsSelected(pos: selectedCategoryIndex, val: false)
            
            for i in 0..<categories.count {
                if(categories[i].DBKey == selectedCategoryDBKey) {
                    categories.setIsSelected(pos: i, val: true)
                    selectedCategoryIndex = i
                    // 更新二级宾语列表
                    lv2Objects.clearOld(category_dbkey: selectedCategoryDBKey, component_words: componentWords)
                    lv2Objects.loadMoreWords()
                    break
                }
            }
        }
    }
    
    
    // 向组成的句子末添加词语
    func addWord(type: WordType, DBKey: Int) -> Void {
        
        switch type {
        case .Subject:
            for i in 0..<subjects.count {
                if(subjects[i].DBKey == DBKey) {
                    if(!subjects[i].isSelected) {
                        // 该词语未被选中, 更改 button 样式
                        subjects.setIsSelected(pos: i, val: true)
                        sentence.append("\(subjects[i].name)")
                        componentWords.append(subjects[i])
                    }
                    break
                }
            }
        case .Predicate:
            for i in 0..<predicates.count {
                if(predicates[i].DBKey == DBKey) {
                    if(!predicates[i].isSelected) {
                        // 该词语未被选中, 更改 button 样式
                        predicates.setIsSelected(pos: i, val: true)
                        sentence.append("\(predicates[i].name)")
                        componentWords.append(predicates[i])
                    }
                    break
                }
                
            }
        case .Object:
            // 宾语常用词和二级宾语 isSelected 联动
            var objectInFrequent: Bool = false
            for i in 0..<frequentObjects.count {
                if(frequentObjects[i].DBKey == DBKey) {
                    objectInFrequent = true
                    if(!frequentObjects[i].isSelected) {
                        // 该词语未被选中, 更改 button 样式
                        frequentObjects.setIsSelected(pos: i, val: true)
                        sentence.append("\(frequentObjects[i].name)")
                        componentWords.append(frequentObjects[i])
                        // 检查当前二级宾语中是否有该词语, 保持 button 样式统一
                        for j in 0..<lv2Objects.count {
                            if(lv2Objects[j].DBKey == DBKey) {
                                lv2Objects.setIsSelected(pos: j, val: true)
                                break
                            }
                        }
                        // 后端词频加一 (对于用户点击前为未选中状态的宾语词)
                        addFrequency(type: FrequencyUpdateType.object, DBKey: DBKey)
                    }
                    break
                }
            }
            // 用户点击的宾语词不在宾语常用词中, 在当前二级宾语中
            if(!objectInFrequent) {
                for i in 0..<lv2Objects.count {
                    if(lv2Objects[i].DBKey == DBKey) {
                        if(!lv2Objects[i].isSelected) {
                            // 该词语未被选中, 更改 button 样式
                            lv2Objects.setIsSelected(pos: i, val: true)
                            sentence.append("\(lv2Objects[i].name)")
                            componentWords.append(lv2Objects[i])
                            // To Test 后端词频加一 (对于用户点击前为未选中状态的宾语词)
                            addFrequency(type: FrequencyUpdateType.object, DBKey: DBKey)
                        }
                        break
                    }
                }
            }
        case .Adjective:
            for i in 0..<adjectives.count {
                if(adjectives[i].DBKey == DBKey) {
                    if(!adjectives[i].isSelected) {
                        // 该词语未被选中, 更改 button 样式
                        adjectives.setIsSelected(pos: i, val: true)
                        sentence.append("\(adjectives[i].name)")
                        componentWords.append(adjectives[i])
                    }
                    break
                }
            }
        case .Other:
            for i in 0..<otherWords.count {
                if(otherWords[i].DBKey == DBKey) {
                    if(!otherWords[i].isSelected) {
                        // 该词语未被选中, 更改 button 样式
                        otherWords.setIsSelected(pos: i, val: true)
                        sentence.append("\(otherWords[i].name)")
                        componentWords.append(otherWords[i])
                    }
                    break
                }
            }
        }
    }
}




struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}

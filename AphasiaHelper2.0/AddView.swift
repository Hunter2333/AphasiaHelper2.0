//
//  AddView.swift
//  AphasiaHelper2.0
//
//  Created by Xiaoqing Sun on 2021/1/21.
//

import SwiftUI

struct AddView: View {
    
    @EnvironmentObject var mainController: MainController
    
    @Binding var show: Bool
    
    @State var selectedTab: TabsInAdd = TabsInAdd.AddNewWord
    
    @State var name: String = ""
    @State var type: AddableType = AddableType.UNSET
    @State var expanded: Bool = false
    @State var selectedCategory: Category = Category(DBKey: -1, name: "null", isSelected: false)
    
    
    var body: some View {
        VStack(spacing: 0) {
            
            HStack {
                Spacer()
                Button(action: {
                    // TODO: Animation?
                    show = false
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
            
            VStack(spacing: 0) {
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
                                    if mainController.categories.doneLoading {
                                        ForEach(mainController.categories, id: \.id) { category in
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
                    if(type == AddableType.sentence) {
                        mainController.addPhrase(phrase: name)
                    } else {
                        mainController.addWordToDB(type: type, name: name, categoryDBKey: selectedCategory.DBKey)
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
                
                // TODO: 显示添加词语的结果
            }
            
        }
        .frame(width: 300)
        .background(Color(red: 26/255, green: 26/255, blue: 55/255))
        .cornerRadius(20)
    }
    
    var finishBtnIsDisabled: Bool {
        return (selectedTab == TabsInAdd.AddNewWord) && ((name == "") || (type == AddableType.UNSET) || ((type == AddableType.second_object) && (selectedCategory.DBKey == -1)))
    }
}

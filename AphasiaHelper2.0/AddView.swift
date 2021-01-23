//
//  AddView.swift
//  AphasiaHelper2.0
//
//  Created by Xiaoqing Sun on 2021/1/21.
//

import SwiftUI

struct AddView: View {
    
    //@EnvironmentObject var mainController: MainController
    
    @State var categoriesExp: [String] = ["食物", "饮品", "家具", "电子产品与电器", "日用品", "地区/地点"]
    
    @State var selectedTab: TabsInAdd = TabsInAdd.AddNewWord
    
    @State var name: String = ""
    @State var type: AddableType = AddableType.second_object
    @State var expanded: Bool = false
    @State var selectedCategoryName: String = ""
    
    var body: some View {
        VStack(spacing: 0) {
            
            HStack {
                Spacer()
                Button(action: {
                    // TODO: 关闭页面
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
                        // TODO........
                        VStack() {
                            HStack {
                                ZStack(alignment: .leading) {
                                    if(selectedCategoryName == "") {
                                        Text("选择子类别")
                                            .padding(10)
                                            .font(.caption)
                                            .foregroundColor(Color.white.opacity(0.25))
                                            
                                    }
                                    Text(selectedCategoryName)
                                        .padding(10)
                                        .font(.caption)
                                        .foregroundColor(Color.white)
                                }
                                Spacer()
                                Image(systemName: expanded ? "arrowtriangle.up.fill" : "arrowtriangle.down.fill")
                                    .resizable()
                                    .frame(width: 10, height: 6)
                                    .foregroundColor(Color.white.opacity(0.25))
                                    .padding(12)
                            }
                            .onTapGesture {
                                expanded.toggle()
                            }
                            .frame(width: 245, height: 32)
                            .background(Color.white.opacity(0.1))
                            .cornerRadius(8)
                            if expanded {
                                ForEach(categoriesExp, id: \.self) { category in
                                    Button(action: {
                                        expanded.toggle()
                                        selectedCategoryName = category
                                    }) {
                                        HStack {
                                            Text(category)
                                                .padding(10)
                                                .font(.caption)
                                                .foregroundColor(Color.white)
                                            Spacer()
                                        }
                                        .frame(width: 245, height: 26)
                                        .background(Color(red: 26/255, green: 26/255, blue: 55/255))
                                    }
                                }
                            }
                        }//.animation(.spring())
                    }.padding(.bottom, 20)
                }
                
                if(selectedTab == TabsInAdd.AddTodoItem) {
                    // TODO: 上传照片
                    Text("TODO: 上传照片").foregroundColor(Color.white)
                }
                
                Button(action: {
                    // TODO: 完成
                }){
                    Text("完成")
                        .font(.caption)
                        .bold()
                        .frame(width: 245, height: 32, alignment: .center)
                        .foregroundColor(Color.white)
                        .background(Color(red: 41/255, green: 118/255, blue: 224/255))
                        .cornerRadius(8)
                }.padding(.bottom, 30)
                
                // TODO: 显示添加词语结果
            }
            
        }
        .frame(width: 300)
        .background(Color(red: 26/255, green: 26/255, blue: 55/255))
        .cornerRadius(20)
    }
}

struct AddView_Previews: PreviewProvider {
    static var previews: some View {
        AddView()
    }
}

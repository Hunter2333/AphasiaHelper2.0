//
//  UrlImageView.swift
//  AphasiaHelper2.0
//
//  Created by Xiaoqing Sun on 2021/1/17.
//

import SwiftUI

struct UrlImageView: View {
    
    @ObservedObject var urlImageModel: UrlImageModel
    
    init(urlString: String?) {
        urlImageModel = UrlImageModel(urlString: urlString)
    }
    
    var body: some View {
        Image(uiImage: urlImageModel.image ?? UrlImageView.defaultImage!)
            .resizable()
            .frame(width: 60, height: 60)
    }
    
    static var defaultImage = UIImage(named: "PlaceHolder")
}

struct UrlImageView_Previews: PreviewProvider {
    static var previews: some View {
        UrlImageView(urlString: nil)
    }
}

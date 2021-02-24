//
//  LoadingView.swift
//  AphasiaHelper2.0
//
//  Created by Xiaoqing Sun on 2021/2/24.
//

import SwiftUI

struct LoadingView: View {
    @State private var isLoading = false
    
    var body: some View {
        ZStack {
            
            Circle()
                .stroke(Color(.systemGray5), lineWidth: 10)
                .frame(width: 50, height: 50)
            
            Circle()
                .trim(from: 0, to: 0.2)
                .stroke(Color.gray, lineWidth: 5)
                .frame(width: 50, height: 50)
                .rotationEffect(Angle(degrees: isLoading ? 360 : 0))
                .animation(Animation.linear(duration: 1).repeatForever(autoreverses: false))
                .onAppear() {
                    self.isLoading = true
                }
        }
    }
}

struct LoadingView_Previews: PreviewProvider {
    static var previews: some View {
        LoadingView()
    }
}

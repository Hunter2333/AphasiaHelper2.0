//
//  SoundVisualizerBarView.swift
//  AphasiaHelper2.0
//
//  Created by Xiaoqing Sun on 2021/2/15.
//

import SwiftUI

struct SoundVisualizerBarView: View {
    
    @State var value: CGFloat
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 20)
                .fill(LinearGradient(gradient: Gradient(colors: [.purple, .blue]),
                                     startPoint: .top,
                                     endPoint: .bottom))
                .frame(width: 2, height: value)
        }
    }
}

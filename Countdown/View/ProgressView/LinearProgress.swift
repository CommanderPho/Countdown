//
//  LinearProgress.swift
//  ProgressView
//
//  Created by funway on 2020/7/31.
//  Copyright © 2020 funwaywang. All rights reserved.
//

import SwiftUI

public struct LinearProgress: View {
    var progress: CGFloat
    var backgroundColor: Color
    var foregroundGradient: Gradient
    var animationTimeInterval: TimeInterval
    var backward: Bool
    
    
    public init(progress: CGFloat, backgroundColor : Color = .secondary,
                foregroundColor: Color = .pink, animationTimeInterval: TimeInterval = 0.5, backward: Bool = false) {
        self.progress = progress
        self.backgroundColor = backgroundColor
        self.foregroundGradient = Gradient(colors: [foregroundColor, foregroundColor])
        self.animationTimeInterval = animationTimeInterval
        self.backward = backward
    }
    
    public init(progress: CGFloat, backgroundColor : Color,
                foregroundGradient: Gradient, animationTimeInterval: TimeInterval = 0.5, backward: Bool = false) {
        self.progress = progress
        self.backgroundColor = backgroundColor
        self.foregroundGradient = foregroundGradient
        self.animationTimeInterval = animationTimeInterval
        self.backward = backward
    }
    
    public var body: some View {
        ZStack{
            GeometryReader { geometry in
                
                Rectangle().frame(width: geometry.size.width , height: geometry.size.height)
                    .foregroundColor(self.backgroundColor)
                    .cornerRadius(geometry.size.width/7)
                    .opacity(0.2)
                    .shadow(radius: 1)
                    
                VStack {
                    LinearGradient(gradient: self.foregroundGradient,
                               startPoint: .leading, endPoint: .trailing)
                    .frame(width: min(geometry.size.width*self.progress, geometry.size.width) , height: geometry.size.height)
                    .mask(Rectangle().cornerRadius(geometry.size.width/7))
                    .animation(.linear(duration: self.animationTimeInterval))
                }.frame(width: geometry.size.width, alignment: self.backward ? .trailing : .leading)
            }
        }
    }
}

struct LinearProgress_Previews: PreviewProvider {
    static var previews: some View {
        LinearProgress(progress: 0.9, backward: true).frame(width: 300, height: 100)
    }
}

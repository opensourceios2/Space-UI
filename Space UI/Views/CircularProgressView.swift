//
//  CircularProgressView.swift
//  Space UI
//
//  Created by Jayden Irwin on 2020-01-01.
//  Copyright © 2020 Jayden Irwin. All rights reserved.
//

import SwiftUI

struct CircularProgressView: View {
    
//    let inner: Inner
    
    @Binding var value: CGFloat
    @State var lineWidth: CGFloat?
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                Circle()
                    .stroke(Color(color: .primary, opacity: .low), style: StrokeStyle(lineWidth: self.lineWidth ?? geometry.size.width/8, dash: [(self.lineWidth ?? geometry.size.width/8)/3, (self.lineWidth ?? geometry.size.width/8)/3]))
                Circle()
                    .trim(from: 0, to: self.value)
                    .stroke(Color(color: .primary, opacity: .max), style: StrokeStyle(lineWidth: self.lineWidth ?? geometry.size.width/8, dash: [(self.lineWidth ?? geometry.size.width/8)/3, (self.lineWidth ?? geometry.size.width/8)/3]))
//                self.inner
//                    .frame(maxWidth: min(geometry.size.width, geometry.size.height) - self.lineWidth*2, maxHeight: min(geometry.size.width, geometry.size.height) - self.lineWidth*2)
            }
            .padding((self.lineWidth ?? geometry.size.width/8) / 2)
            .position(x: geometry.size.width/2, y: geometry.size.height/2)
        }
        .rotationEffect(Angle(degrees: -90))
        .animation(Animation.easeOut(duration: 0.5), value: value)
        .aspectRatio(1, contentMode: .fit)
    }
    
//    @inlinable public init(value: CGFloat, lineWidth: CGFloat, @ViewBuilder content: () -> Inner) {
//        self.inner = content()
//        self.value = State<CGFloat>(initialValue: value)
//        self.lineWidth = State<CGFloat>(initialValue: lineWidth)
//    }
}

struct CircularProgressView_Previews: PreviewProvider {
    
    @State static var value: CGFloat = 0.0
    
    static var previews: some View {
        CircularProgressView(value: $value)
            .onAppear(perform: {
                self.value = 0.66
            })
    }
}

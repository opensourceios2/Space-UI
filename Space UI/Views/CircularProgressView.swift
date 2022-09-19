//
//  CircularProgressView.swift
//  Space UI
//
//  Created by Jayden Irwin on 2020-01-01.
//  Copyright © 2020 Jayden Irwin. All rights reserved.
//

import SwiftUI

struct CircularProgressView<Inner: View>: View {
    
    let inner: Inner
    
    @Binding var value: Double
    @State var lineWidth: CGFloat?
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                Circle()
                    .stroke(Color(color: .primary, opacity: .low), style: StrokeStyle(lineWidth: actualLineWidth(size: geometry.size), dash: [(actualLineWidth(size: geometry.size))/3, (actualLineWidth(size: geometry.size))/3]))
                    .rotationEffect(Angle(degrees: -90))
                Circle()
                    .trim(from: 0, to: self.value)
                    .stroke(Color(color: .primary, opacity: .max), style: StrokeStyle(lineWidth: actualLineWidth(size: geometry.size), dash: [(actualLineWidth(size: geometry.size))/3, (actualLineWidth(size: geometry.size))/3]))
                    .rotationEffect(Angle(degrees: -90))
                self.inner
                    .multilineTextAlignment(.center)
                    .frame(maxWidth: min(geometry.size.width, geometry.size.height) - (actualLineWidth(size: geometry.size) * 2), maxHeight: min(geometry.size.width, geometry.size.height) - (actualLineWidth(size: geometry.size) * 2))
            }
            .padding((self.lineWidth ?? geometry.size.width/8) / 2)
            .position(x: geometry.size.width/2, y: geometry.size.height/2)
        }
        .animation(Animation.easeOut(duration: 0.5), value: value)
        .aspectRatio(1, contentMode: .fit)
    }
    
    @inlinable init(value: Binding<Double>, lineWidth: CGFloat? = nil, @ViewBuilder content: () -> Inner = { EmptyView() }) {
        self.inner = content()
        self._value = value
        self._lineWidth = State<CGFloat?>(initialValue: lineWidth)
    }
    
    func actualLineWidth(size: CGSize) -> CGFloat {
        lineWidth ?? size.width/8
    }
}

struct CircularProgressView_Previews: PreviewProvider {
    
    @State static var value: Double = 0.0
    
    static var previews: some View {
        CircularProgressView(value: $value)
            .onAppear(perform: {
                self.value = 0.66
            })
    }
}

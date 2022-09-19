//
//  ScrollView+FadeEdges.swift
//  Space UI
//
//  Created by Jayden Irwin on 2022-09-16.
//  Copyright © 2022 Jayden Irwin. All rights reserved.
//

import SwiftUI

struct FadeScrollEdges: ViewModifier {

    let length: CGFloat
    
    func body(content: Content) -> some View {
        content
            .mask {
                VStack(spacing: 0) {
                    LinearGradient(gradient: Gradient(colors: [Color.black.opacity(0), Color.black]), startPoint: .top, endPoint: .bottom)
                        .frame(height: length)
                    Color.black
                    LinearGradient(gradient: Gradient(colors: [Color.black, Color.black.opacity(0)]), startPoint: .top, endPoint: .bottom)
                        .frame(height: length)
                }
            }
    }
}

extension View {
    
    func fadeScrollEdges(length: CGFloat) -> some View {
        modifier(FadeScrollEdges(length: length))
    }
    
}

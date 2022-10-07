//
//  Section.swift
//  Space UI
//
//  Created by Jayden Irwin on 2022-10-06.
//  Copyright © 2022 Jayden Irwin. All rights reserved.
//

import SwiftUI

struct Section<Content: View>: View {
    
    let content: Content
    
    var body: some View {
        VStack {
            content
        }
        .frame(idealWidth: .infinity, maxWidth: .infinity)
        .background {
            RoundedRectangle(cornerRadius: system.cornerStyle == .sharp ? 0 : 24)
                .foregroundColor(Color(color: .primary, brightness: system.prefersButtonBorders ? .low : .medium))
        }
        .overlay {
            if system.prefersBorders {
                RoundedRectangle(cornerRadius: system.cornerStyle == .sharp ? 0 : 24)
                    .strokeBorder(Color(color: .primary, opacity: .high), style: StrokeStyle(lineWidth: system.mediumLineWidth, lineCap: system.lineCap, dash: system.lineDash(lineWidth: system.mediumLineWidth)))
            }
        }
    }
    
    @inlinable public init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }
}

struct Section_Previews: PreviewProvider {
    static var previews: some View {
        Section {
            Text("Hello")
        }
    }
}

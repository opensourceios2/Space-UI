//
//  NavigationButton.swift
//  Space UI
//
//  Created by Jayden Irwin on 2019-12-18.
//  Copyright © 2019 Jayden Irwin. All rights reserved.
//

import SwiftUI

struct NavigationButton<Label: View>: View {
    
    @Environment(\.shapeDirection) var shapeDirection: ShapeDirection
    
    let label: Label
    var page: Page
    
    var body: some View {
        if system.preferedButtonSizingMode == .fixed {
            Button(action: {
                AudioController.shared.play(.button)
                visiblePage = self.page
                NotificationCenter.default.post(name: NSNotification.Name("navigate"), object: nil)
            }, label: {
                label
            }).buttonStyle(ShapeButtonStyle(shapeDirection: shapeDirection))
        } else {
            Button(action: {
                AudioController.shared.play(.button)
                visiblePage = self.page
                NotificationCenter.default.post(name: NSNotification.Name("navigate"), object: nil)
            }, label: {
                label
            }).buttonStyle(FlexButtonStyle())
        }
    }
    
    init(to page: Page, @ViewBuilder label: () -> Label) {
        self.page = page
        self.label = label()
    }
}

struct NavigationButton_Previews: PreviewProvider {
    static var previews: some View {
        NavigationButton(to: .ticTacToe) {
            Text("Label")
        }
    }
}

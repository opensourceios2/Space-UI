//
//  KeyboardKeyView.swift
//  Space UI
//
//  Created by Jayden Irwin on 2020-01-09.
//  Copyright © 2020 Jayden Irwin. All rights reserved.
//

import SwiftUI

struct KeyboardKeyView: View {
    
    let key: String
    let height: CGFloat
    
    @Binding var string: String
    
    var body: some View {
        Button(action: {
            AudioController.shared.play(.action)
            self.string.append(self.key)
        }, label: { Text(key) })
        .buttonStyle(KeyboardButtonStyle(keyHeight: height))
    }
}

struct KeyboardKeyView_Previews: PreviewProvider {
    static var previews: some View {
        KeyboardKeyView(key: "A", height: 50, string: .constant("ABC"))
    }
}

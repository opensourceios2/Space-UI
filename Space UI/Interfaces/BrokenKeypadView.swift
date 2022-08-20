//
//  BrokenKeypadView.swift
//  Space UI
//
//  Created by Jayden Irwin on 2020-06-16.
//  Copyright © 2020 Jayden Irwin. All rights reserved.
//

import SwiftUI

struct UnlabeledKeypadView: View {
    
    let solution: String = {
        let chars = "abcdefghi"
        return String(chars.randomElement()!) + String(chars.randomElement()!) + String(chars.randomElement()!) + String(chars.randomElement()!)
    }()
    
    @State var keypadText = "****"
    @State var incorrectCodeEntered = false
    
    var body: some View {
        VStack {
            Text(solution)
                .font(Font.spaceFont(size: 40))
            Text(self.keypadText)
                .font(Font.spaceFont(size: 40))
                .foregroundColor(incorrectCodeEntered ? Color(color: .danger, opacity: .max) : nil)
            ZStack {
                GridShape(rows: 3, columns: 3, outsideCornerRadius: system.cornerRadius(forLength: 100))
                    .stroke(Color(color: .primary, opacity: .max), lineWidth: 2)
                VStack(spacing: 0) {
                    HStack(spacing: 0) {
                        makeButton(char: "a")
                        makeButton(char: "b")
                        makeButton(char: "c")
                    }
                    HStack(spacing: 0) {
                        makeButton(char: "d")
                        makeButton(char: "e")
                        makeButton(char: "f")
                    }
                    HStack(spacing: 0) {
                        makeButton(char: "g")
                        makeButton(char: "h")
                        makeButton(char: "i")
                    }
                }
                .clipShape(GridShape(rows: 3, columns: 3, outsideCornerRadius: system.cornerRadius(forLength: 100)))
            }
            .frame(width: 300, height: 300, alignment: .center)
        }
    }
    
    func makeButton(char: Character) -> some View {
        return Button(action: {
            self.selectCell(char: char)
        }) {
            ZStack {
                Rectangle()
                .foregroundColor(.clear)
            }
        }
        .frame(width: 100, height: 100, alignment: .center)
    }
    
    func selectCell(char: Character) {
        guard let nextIndex = keypadText.firstIndex(of: "*") else { return }
        keypadText.insert(char, at: nextIndex)
        keypadText.removeLast()
        if keypadText == solution {
            PeerSessionController.shared.send(message: .emergencyEnded)
            ShipData.shared.endEmergency()
        } else if !keypadText.contains("*") {
            incorrectCodeEntered = true
            Timer.scheduledTimer(withTimeInterval: 0.3, repeats: false) { (timer) in
                self.keypadText = "****"
                self.incorrectCodeEntered = false
            }
        }
    }
    
}

struct UnlabeledKeypadView_Previews: PreviewProvider {
    static var previews: some View {
        UnlabeledKeypadView()
    }
}

//
//  MessageContent.swift
//  Space UI
//
//  Created by Jayden Irwin on 2020-01-16.
//  Copyright © 2020 Jayden Irwin. All rights reserved.
//

import SwiftUI
import GameplayKit

struct MessageContent: Identifiable {
    
    enum Style {
        case regular, secondaryColor, tertiaryColor, filledBackground, filledBackgroundWithSecondaryTextColor, flashing, tagged1, tagged2
    }
    
    let sender: String
    let body: String
    let style: Style
    
    var id: UUID { UUID() }
    
    init(sender: String, body: String, style: Style) {
        self.sender = sender
        self.body = body
        self.style = style
    }
    
    init(index: Int) {
        sender = Lorem.word(index: index)
        body = Lorem.words(index: index, count: Int.random(in: 2...3)).uppercased()
        style = {
            switch Int.random(in: 0...44) {
            case 0, 1:
                return .secondaryColor
            case 2:
                return .filledBackground
            case 3:
                return .filledBackgroundWithSecondaryTextColor
            case 4, 5:
                return .flashing
            case 6:
                return .tagged1
            case 7:
                return .tagged2
            default:
                return .regular
            }
        }()
    }
    
}

final class MessagesState: ObservableObject {
    
    @Published private var internalMessages: [MessageContent] = {
        (0..<60).map({ MessageContent(index: $0) })
    }()
    var messages: [MessageContent] {
        internalMessages
    }
    
    func addMessage(_ message: MessageContent) {
        guard ShipData.shared.powerState.comsHavePower else { return }
        internalMessages.append(message)
    }
    
}

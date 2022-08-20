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
    
    static func random() -> MessageContent {
        MessageContent(sender: Lorem.word(), body: Lorem.words(Int.random(in: 2...3)).uppercased(), style: {
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
        }())
    }
    
    let sender: String
    let body: String
    let style: Style
    
    var id: UUID { UUID() }
    
}

final class MessagesState: ObservableObject {
    
    @Published private var internalMessages: [MessageContent] = {
        var messages = [MessageContent]()
        for _ in 0..<60 {
            messages.append(MessageContent.random())
        }
        return messages
    }()
    var messages: [MessageContent] {
        internalMessages
    }
    
    func addMessage(_ message: MessageContent) {
        guard ShipData.shared.powerState.comsHavePower else { return }
        internalMessages.append(message)
    }
    
}

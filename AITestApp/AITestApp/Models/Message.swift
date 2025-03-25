//
//  Message.swift
//  AITestApp
//
//  Created by L_0045_r.watanabe on 2025/03/25.
//


import Foundation
import SwiftyJSON

struct Message {
    enum Sender {
        case user
        case ai
    }

    let text: String
    let sender: Sender

    init(text: String, sender: Sender) {
        self.text = text
        self.sender = sender
    }

    init(json: JSON) {
        self.text = json["response"].stringValue
        self.sender = .ai
    }
}

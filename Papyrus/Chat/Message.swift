//
//  Message.swift
//  Papyrus
//
//  Created by Victor Shinya on 30/07/17.
//  Copyright © 2017 aKANJ. All rights reserved.
//

import NoChat

enum MessageDeliveryStatus {
    case Idle
    case Delivering
    case Delivered
    case Failure
    case Read
}

class Message: NSObject, NOCChatItem {
    
    var msgId: String = UUID().uuidString
    var msgType: String = "Text"
    
    var senderId: String = ""
    var date: Date = Date()
    var text: String = ""
    
    var isOutgoing: Bool = true
    var deliveryStatus: MessageDeliveryStatus = .Idle
    
    public func uniqueIdentifier() -> String {
        return self.msgId;
    }
    
    public func type() -> String {
        return self.msgType
    }
    
}

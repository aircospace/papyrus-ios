//
//  MessageManager.swift
//  Papyrus
//
//  Created by Victor Shinya on 30/07/17.
//  Copyright © 2017 aKANJ. All rights reserved.
//

import Foundation
import NOCProtoKit

protocol MessageManagerDelegate: class {
    func didReceiveMessages(messages: [Message], chatId: String)
}

class MessageManager: NSObject, NOCClientDelegate {
    
    private var delegates: NSHashTable<AnyObject>
    private var client: NOCClient
    
    private var messages: Dictionary<String, [Message]>
    
    override init() {
        delegates = NSHashTable<AnyObject>.weakObjects()
        client = NOCClient(userId: User.currentUser.userId)
        messages = [:]
        super.init()
        client.delegate = self
    }
    
    static let manager = MessageManager()
    
    func play() {
        client.open()
    }
    
    func fetchMessages(withChatId chatId: String, handler: ([Message]) -> Void) {
        if let msgs = messages[chatId] {
            handler(msgs)
        } else {
            var arr = [Message]()
            
            let msg = Message()
            msg.msgType = "Date"
            arr.append(msg)
            
            if chatId == "bot_89757" {
                let msg = Message()
                msg.msgType = "System"
                msg.text = "Welcome to Papyrus message"
                arr.append(msg)
            }
            
            saveMessages(arr, chatId: chatId)
            
            handler(arr)
        }
    }
    
    func sendMessage(_ message: Message, toChat chat: Chat) {
        let chatId = chat.chatId
        
        saveMessages([message], chatId: chatId)
        
        let dict = [
            "from": message.senderId,
            "to": chat.targetId,
            "type": message.msgType,
            "text": message.text,
            "ctype": chat.type
        ]
        
        client.sendMessage(dict)
    }
    
    func addDelegate(_ delegate: MessageManagerDelegate) {
        delegates.add(delegate)
    }
    
    func removeDelegate(_ delegate: MessageManagerDelegate) {
        delegates.remove(delegate)
    }
    
    func clientDidReceiveMessage(_ message: [AnyHashable : Any]) {
        guard let senderId = message["from"] as? String,
            let type = message["type"] as? String,
            let text = message["text"] as? String,
            let chatType = message["ctype"] as? String else {
                return;
        }
        
        if type != "Text" || chatType != "bot" {
            return;
        }
        
        let msg = Message()
        msg.senderId = senderId
        msg.msgType = type
        msg.text = text
        msg.isOutgoing = false
        
        let chatId = chatType + "_" + senderId
        
        saveMessages([msg], chatId: chatId)
        
        for delegate in delegates.allObjects {
            if let d = delegate as? MessageManagerDelegate {
                d.didReceiveMessages(messages: [msg], chatId: chatId)
            }
        }
    }
    
    private func saveMessages(_ messages: [Message], chatId: String) {
        var msgs = self.messages[chatId] ?? []
        msgs += messages
        self.messages[chatId] = msgs
    }
    
}


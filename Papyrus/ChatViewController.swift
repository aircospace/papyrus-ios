//
//  ViewController.swift
//  Papyrus
//
//  Created by Jean Paul Marinho on 29/07/17.
//  ChatViewController.swift
//  Papyrus
//
//  Created by Victor Shinya on 30/07/17.
//  Copyright © 2017 aKANJ. All rights reserved.
//

import UIKit
import MultipeerConnectivity
import NoChat

class ChatViewController: NOCChatViewController, UINavigationControllerDelegate, MessageManagerDelegate, PapyrusChatInputTextPanelDelegate, PapyrusTextMessageCellDelegate {
    
    var titleView = PapyrusTextView()
    var avatarButton = PapyrusAvatarButton()
    var targetID: String!
    var messageManager = MessageManager.manager
    var layoutQueue = DispatchQueue(label: "com.little2s.nochat-example.tg.layout", qos: DispatchQoS(qosClass: .default, relativePriority: 0))
    
    var chat: Chat!
    
    // MARK: Overrides
    
    override class func cellLayoutClass(forItemType type: String) -> Swift.AnyClass? {
        if type == "Text" {
            return PapyrusTextMessageCellLayout.self
        } else if type == "Date" {
            return PapyrusDateMessageCellLayout.self
        } else if type == "System" {
            return PapyrusSystemMessageCellLayout.self
        } else {
            return nil
        }
    }
    
    override class func inputPanelClass() -> Swift.AnyClass? {
        return PapyrusChatInputTextPanel.self
    }
    
    override func registerChatItemCells() {
        collectionView?.register(PapyrusTextMessageCell.self, forCellWithReuseIdentifier: PapyrusTextMessageCell.reuseIdentifier())
        collectionView?.register(PapyrusDateMessageCell.self, forCellWithReuseIdentifier: PapyrusDateMessageCell.reuseIdentifier())
        collectionView?.register(PapyrusSystemMessageCell.self, forCellWithReuseIdentifier: PapyrusSystemMessageCell.reuseIdentifier())
    }
    
    deinit {
        messageManager.removeDelegate(self)
        unregisterContentSizeCategoryDidChangeNotification()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.chat = Chat()
        self.chat.type = "text"
        self.chat.targetId = "\(self.targetID.characters.count)"
        self.chat.chatId = chat.type + "_" + chat.targetId
        self.chat.title = self.targetID!
        self.chat.detail = "nearby"

        messageManager.addDelegate(self)
        registerContentSizeCategoryDidChangeNotification()
        setupNavigationItems()
        
        navigationController?.navigationBar.backgroundColor = UIColor.white;
        backgroundView?.image = UIImage(named: "PapyrusWallpaper")
        navigationController?.delegate = self
        
        loadMessages()
    }
    
    // MARK: PapyrusChatInputTextPanelDelegate
    
    func inputTextPanel(_ inputTextPanel: PapyrusChatInputTextPanel, requestSendText text: String) {
        let msg = Message()
        msg.text = text
        sendMessage(msg)
    }
    
    // MARK: PapyrusTextMessageCellDelegate
    
    func didTapLink(cell: PapyrusTextMessageCell, linkInfo: [AnyHashable: Any]) {
        inputPanel?.endInputting(true)
        
        guard let command = linkInfo["command"] as? String else { return }
        let msg = Message()
        msg.text = command
        sendMessage(msg)
    }
    
    // MARK: MessageManagerDelegate
    
    func didReceiveMessages(messages: [Message], chatId: String) {
        if isViewLoaded == false { return }
        
        if chatId == chat.chatId {
            addMessages(messages, scrollToBottom: true, animated: true)
            
            SoundManager.manager.playSound(name: "notification.caf", vibrate: false)
        }
    }
    
    // MARK: UINavigationControllerDelegate
    
    func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
        if self === navigationController.topViewController {
            return
        }
        
        isInControllerTransition = true
        
        guard let tc = navigationController.topViewController?.transitionCoordinator else { return }
        tc.notifyWhenInteractionEnds { [weak self] (context) in
            guard let strongSelf = self else { return }
            if context.isCancelled {
                strongSelf.isInControllerTransition = false
            }
        }
    }
    
    // MARK: Private
    
    private func setupNavigationItems() {
        titleView.title = chat.title
        titleView.detail = chat.detail
        navigationItem.titleView = titleView
        
        let spacerItem = UIBarButtonItem(barButtonSystemItem: .fixedSpace, target: nil, action: nil)
        spacerItem.width = -12
        
        let rightItem = UIBarButtonItem(customView: avatarButton)
        
        navigationItem.rightBarButtonItems = [spacerItem, rightItem]
    }
    
    private func loadMessages() {
        layouts.removeAllObjects()
        
        messageManager.fetchMessages(withChatId: chat.chatId) { [weak self] (msgs) in
            if let strongSelf = self {
                strongSelf.addMessages(msgs, scrollToBottom: true, animated: false)
            }
        }
    }
    
    private func sendMessage(_ message: Message) {
        message.isOutgoing = true
        message.senderId = User.currentUser.userId
        message.deliveryStatus = .Read
        
        addMessages([message], scrollToBottom: true, animated: true)
        
        messageManager.sendMessage(message, toChat: chat)
        
        SoundManager.manager.playSound(name: "sent.caf", vibrate: false)
    }
    
    private func addMessages(_ messages: [Message], scrollToBottom: Bool, animated: Bool) {
        layoutQueue.async { [weak self] in
            guard let strongSelf = self else { return }
            let indexes = IndexSet(integersIn: 0..<messages.count)
            
            var layouts = [NOCChatItemCellLayout]()
            
            for message in messages {
                let layout = strongSelf.createLayout(with: message)!
                layouts.insert(layout, at: 0)
            }
            
            DispatchQueue.main.async {
                strongSelf.insertLayouts(layouts, at: indexes, animated: animated)
                if scrollToBottom {
                    strongSelf.scrollToBottom(animated: animated)
                }
            }
        }
    }
    
    // MARK: Dynamic font support
    
    private func registerContentSizeCategoryDidChangeNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(handleContentSizeCategoryDidChanged(notification:)), name: .UIContentSizeCategoryDidChange, object: nil)
    }
    
    private func unregisterContentSizeCategoryDidChangeNotification() {
        NotificationCenter.default.removeObserver(self, name: .UIContentSizeCategoryDidChange, object: nil)
    }
    
    @objc private func handleContentSizeCategoryDidChanged(notification: Notification) {
        if isViewLoaded == false {
            return
        }
        
        if layouts.count == 0 {
            return
        }
        
        // ajust collection display
        
        let collectionViewSize = containerView!.bounds.size
        
        let anchorItem = calculateAnchorItem()
        
        for layout in layouts {
            (layout as! NOCChatItemCellLayout).calculate()
        }
        
        collectionLayout!.invalidateLayout()
        
        let cellLayouts = layouts.map { $0 as! NOCChatItemCellLayout }
        
        var newContentHeight = CGFloat(0)
        let newLayoutAttributes = collectionLayout!.layoutAttributes(for: cellLayouts, containerWidth: collectionViewSize.width, maxHeight: CGFloat.greatestFiniteMagnitude, contentHeight: &newContentHeight)
        
        var newContentOffset = CGPoint.zero
        newContentOffset.y = -collectionView!.contentInset.top
        if anchorItem.index >= 0 && anchorItem.index < newLayoutAttributes.count {
            let attributes = newLayoutAttributes[anchorItem.index]
            newContentOffset.y += attributes.frame.origin.y - floor(anchorItem.offset * attributes.frame.height)
        }
        newContentOffset.y = min(newContentOffset.y, newContentHeight + collectionView!.contentInset.bottom - collectionView!.frame.height)
        newContentOffset.y = max(newContentOffset.y, -collectionView!.contentInset.top)
        
        collectionView!.reloadData()
        
        collectionView!.contentOffset = newContentOffset
        
        // fix navigation items display
        setupNavigationItems()
    }
    
    typealias AnchorItem = (index: Int, originY: CGFloat, offset: CGFloat, height: CGFloat)
    private func calculateAnchorItem() -> AnchorItem {
        let maxOriginY = collectionView!.contentOffset.y + collectionView!.contentInset.top
        let previousCollectionFrame = collectionView!.frame
        
        var itemIndex = Int(-1)
        var itemOriginY = CGFloat(0)
        var itemOffset = CGFloat(0)
        var itemHeight = CGFloat(0)
        
        let cellLayouts = layouts.map { $0 as! NOCChatItemCellLayout }
        
        let previousLayoutAttributes = collectionLayout!.layoutAttributes(for: cellLayouts, containerWidth: previousCollectionFrame.width, maxHeight: CGFloat.greatestFiniteMagnitude, contentHeight: nil)
        
        for i in 0..<layouts.count {
            let attributes = previousLayoutAttributes[i]
            let itemFrame = attributes.frame
            
            if itemFrame.origin.y < maxOriginY {
                itemHeight = itemFrame.height
                itemIndex = i
                itemOriginY = itemFrame.origin.y
            }
        }
        
        if itemIndex != -1 {
            if itemHeight > 1 {
                itemOffset = (itemOriginY - maxOriginY) / itemHeight
            }
        }
        
        return (itemIndex, itemOriginY, itemOffset, itemHeight)
    }
}



extension ChatViewController: MCManagerDelegate {
    
    func foundPeer() {
        messageManager.fetchMessages(withChatId: chat.chatId) { [weak self] (msgs) in
            if let strongSelf = self {
//                self?.mcManager.sendText(text: (msgs.last?.text)!)
            }
        }
    }
    
    func lostPeer() {
        
    }
    
    func receivedText(text: String) {
        
    }
}

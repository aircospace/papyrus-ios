//
//  PapyrusSystemMessageCellLayout.swift
//  Papyrus
//
//  Created by Victor Shinya on 30/07/17.
//  Copyright © 2017 aKANJ. All rights reserved.
//

import NoChat

class PapyrusSystemMessageCellLayout: NSObject, NOCChatItemCellLayout {
    
    var reuseIdentifier: String = "PapyrusSystemMessageCell"
    var chatItem: NOCChatItem
    var width: CGFloat
    var height: CGFloat = 0
    
    var message: Message {
        return chatItem as! Message
    }
    
    var backgroundImageViewFrame = CGRect.zero
    var backgroundImage: UIImage?
    var textLabelFrame = CGRect.zero
    var attributedText: NSAttributedString?
    
    required init(chatItem: NOCChatItem, cellWidth width: CGFloat) {
        self.chatItem = chatItem
        self.width = width
        super.init()
        setupBackgroundImage()
        setupAttributedText()
        calculate()
    }
    
    func calculate() {
        height = 0
        backgroundImageViewFrame = CGRect.zero
        textLabelFrame = CGRect.zero
        
        guard let at = attributedText, at.length > 0 else {
            return
        }
        
        let limitSize = CGSize(width: ceil(width * 0.75), height: CGFloat.greatestFiniteMagnitude)
        let textLabelSize = at.noc_sizeThatFits(size: limitSize)
        
        let vPadding = CGFloat(4)
        
        let textLabelInsets = Style.textInsets
        
        textLabelFrame = CGRect(x: width/2 - textLabelSize.width/2, y: vPadding, width: textLabelSize.width, height: textLabelSize.height)
        
        backgroundImageViewFrame = CGRect(x: textLabelFrame.origin.x - textLabelInsets.left, y: textLabelFrame.origin.y - textLabelInsets.top, width: textLabelFrame.width + textLabelInsets.left + textLabelInsets.right, height: textLabelFrame.height + textLabelInsets.top + textLabelInsets.bottom)
        
        height = vPadding * 2 + backgroundImageViewFrame.height
    }
    
    private func setupBackgroundImage() {
        backgroundImage = Style.systemMessageBackground
    }
    
    private func setupAttributedText() {
        let text = message.text
        let one = NSAttributedString(string: text, attributes: [NSAttributedStringKey.font: Style.textFont, NSAttributedStringKey.foregroundColor: Style.textColor])
        attributedText = one
    }
    
    struct Style {
        static let textInsets = UIEdgeInsets(top: 2, left: 7, bottom: 2, right: 5)
        static let textFont = UIFont.systemFont(ofSize: 13)
        static let textColor = UIColor.white
        static let textBackgroundColor = UIColor(white: 0.2, alpha: 0.25)
        
        static let systemMessageBackground: UIImage? = {
            if let rawImage = PapyrusGenerateSystemMessageBackground() {
                let image = rawImage.stretchableImage(withLeftCapWidth: Int(rawImage.size.width/2), topCapHeight: Int(rawImage.size.height/2))
                return image
            } else {
                return nil
            }
        }()
    }
    
}

fileprivate func PapyrusGenerateSystemMessageBackground() -> UIImage? {
    UIGraphicsBeginImageContextWithOptions(CGSize(width: 20, height: 20), false, 0)
    
    guard let context = UIGraphicsGetCurrentContext() else {
        return nil
    }
    
    let path = UIBezierPath(roundedRect: CGRect(x: 0, y: 0, width: 20, height: 20), cornerRadius: 10)
    
    let color = PapyrusSystemMessageCellLayout.Style.textBackgroundColor
    color.setFill()
    
    context.addPath(path.cgPath)
    context.fillPath()
    
    let image = UIGraphicsGetImageFromCurrentImageContext()
    
    UIGraphicsEndImageContext()
    
    return image
}

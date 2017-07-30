//
//  PapyrusSystemMessageCell.swift
//  Papyrus
//
//  Created by Victor Shinya on 30/07/17.
//  Copyright © 2017 aKANJ. All rights reserved.
//

import NoChat

class PapyrusSystemMessageCell: NOCChatItemCell {
    
    var backgroundImageView = UIImageView()
    var textLabel = UILabel()
    
    override class func reuseIdentifier() -> String {
        return "PapyrusSystemMessageCell"
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        itemView?.addSubview(backgroundImageView)
        
        textLabel.numberOfLines = 0
        itemView?.addSubview(textLabel)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override var layout: NOCChatItemCellLayout? {
        didSet {
            guard let cellLayout = layout as? PapyrusSystemMessageCellLayout else {
                fatalError("invalid layout type")
            }
            
            backgroundImageView.frame = cellLayout.backgroundImageViewFrame
            backgroundImageView.image = cellLayout.backgroundImage
            textLabel.frame = cellLayout.textLabelFrame
            textLabel.attributedText = cellLayout.attributedText
        }
    }
}

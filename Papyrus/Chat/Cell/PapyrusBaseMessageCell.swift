//
//  PapyrusBaseMessageCell.swift
//  Papyrus
//
//  Created by Victor Shinya on 30/07/17.
//  Copyright © 2017 aKANJ. All rights reserved.
//

import NoChat

class PapyrusBaseMessageCell: NOCChatItemCell {
    
    var bubbleView = UIView()
    
    var isHighlight = false
    
    override class func reuseIdentifier() -> String {
        return "PapyrusBaseMessageCell"
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        itemView?.addSubview(bubbleView)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override var layout: NOCChatItemCellLayout? {
        didSet {
            guard let cellLayout = layout as? PapyrusBaseMessageCellLayout else {
                fatalError("invalid layout type")
            }
            
            bubbleView.frame = cellLayout.bubbleViewFrame
        }
    }
}

//
//  PapyrusDateMessageCell.swift
//  Papyrus
//
//  Created by Victor Shinya on 30/07/17.
//  Copyright © 2017 aKANJ. All rights reserved.
//

import NoChat

class PapyrusDateMessageCell: NOCChatItemCell {
    
    var backgroundImageView = UIImageView()
    var dateLabel = UILabel()
    
    override class func reuseIdentifier() -> String {
        return "PapyrusDateMessageCell"
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        itemView?.addSubview(backgroundImageView)
        
        dateLabel.numberOfLines = 0
        itemView?.addSubview(dateLabel)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override var layout: NOCChatItemCellLayout? {
        didSet {
            guard let cellLayout = layout as? PapyrusDateMessageCellLayout else {
                fatalError("invalid layout type")
            }
            
            backgroundImageView.frame = cellLayout.backgroundImageViewFrame
            backgroundImageView.image = cellLayout.backgroundImage
            dateLabel.frame = cellLayout.dateLabelFrame
            dateLabel.attributedText = cellLayout.attributedDate
        }
    }
}

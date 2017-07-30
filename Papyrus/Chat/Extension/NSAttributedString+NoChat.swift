//
//  NSAttributedString+NoChat.swift
//  Papyrus
//
//  Created by Victor Shinya on 30/07/17.
//  Copyright © 2017 aKANJ. All rights reserved.
//

import UIKit

extension NSAttributedString {
    
    func noc_sizeThatFits(size: CGSize) -> CGSize {
        let rect = boundingRect(with: size, options: [.usesLineFragmentOrigin, .usesFontLeading ], context: nil)
        return rect.integral.size
    }
    
}


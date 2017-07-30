//
//  RoundedView.swift
//  Papyrus
//
//  Created by Jean Paul Marinho on 30/07/17.
//  Copyright © 2017 aKANJ. All rights reserved.
//

import UIKit

class RoundedView: UIImageView {
    
    override func awakeFromNib() {
        self.layer.cornerRadius = self.frame.width / 2.0
    }
}

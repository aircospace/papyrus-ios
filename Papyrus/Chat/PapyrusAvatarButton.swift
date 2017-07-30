//
//  PapyrusAvatarButton.swift
//  Papyrus
//
//  Created by Victor Shinya on 30/07/17.
//  Copyright © 2017 aKANJ. All rights reserved.
//

import UIKit

class PapyrusAvatarButton: UIButton {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setImage(UIImage(named: "PapyrusUserInfo"), for: .normal)
        regularLayout()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        if traitCollection.verticalSizeClass == .compact {
            compactLayout()
        } else {
            regularLayout()
        }
    }
    
    private func regularLayout() {
        frame = CGRect(x: 0, y: 0, width: 37, height: 37)
    }
    
    private func compactLayout() {
        frame = CGRect(x: 0, y: 0, width: 28, height: 28)
    }
}

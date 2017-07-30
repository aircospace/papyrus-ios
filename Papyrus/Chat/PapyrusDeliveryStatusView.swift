//
//  PapyrusDeliveryStatusView.swift
//  Papyrus
//
//  Created by Victor Shinya on 30/07/17.
//  Copyright © 2017 aKANJ. All rights reserved.
//

import UIKit

class PapyrusDeliveryStatusView: UIView {
    
    var clockView = PapyrusClockProgressView()
    var checkmark1ImageView = UIImageView(image: Constant.checkmark1Image)
    var checkmark2ImageView = UIImageView(image: Constant.checkmark2Image)
    
    var deliveryStatus: MessageDeliveryStatus = .Idle {
        didSet {
            updateUI()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(clockView)
        addSubview(checkmark1ImageView)
        addSubview(checkmark2ImageView)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        clockView.frame = bounds
        checkmark1ImageView.frame = CGRect(x: 0, y: 2, width: 12, height: 11)
        checkmark2ImageView.frame = CGRect(x: 3, y: 2, width: 12, height: 11)
    }
    
    private func updateUI() {
        if deliveryStatus == .Delivering {
            clockView.isHidden = false
            clockView.startAnimating()
            checkmark1ImageView.isHidden = true
            checkmark2ImageView.isHidden = true
        } else if (deliveryStatus == .Delivered) {
            clockView.stopAnimating()
            clockView.isHidden = true
            checkmark1ImageView.isHidden = false
            checkmark2ImageView.isHidden = true
        } else if (deliveryStatus == .Read) {
            clockView.stopAnimating()
            clockView.isHidden = true
            checkmark1ImageView.isHidden = false
            checkmark2ImageView.isHidden = false
        } else {
            clockView.stopAnimating()
            clockView.isHidden = true
            checkmark1ImageView.isHidden = true
            checkmark2ImageView.isHidden = true
        }
    }
    
    struct Constant {
        static let checkmark1Image = UIImage(named: "PapyrusMessageCheckmark1")!
        static let checkmark2Image = UIImage(named: "PapyrusMessageCheckmark2")!
    }

}

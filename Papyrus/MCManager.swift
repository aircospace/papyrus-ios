//
//  MCManager.swift
//  Papyrus
//
//  Created by Jean Paul Marinho on 30/07/17.
//  Copyright © 2017 aKANJ. All rights reserved.
//

import UIKit
import MultipeerConnectivity

class MCManager: NSObject {
    
    var session: MCSession!
    var peer: MCPeerID!
    var browser: MCNearbyServiceBrowser!
    var advertiser: MCNearbyServiceAdvertiser!
    var foundPeers = [MCPeerID]()
    var invitationHandler: ((Bool, MCSession?)->Void)!
    
    override init() {
        self.peer = MCPeerID(displayName: UIDevice.current.name)
    }
}


//extension MCManager: MCSessionDelegate {
//    
//}
//
//
//
//extension MCManager: MCNearbyServiceBrowserDelegate {
//    
//}
//
//
//
//extension MCManager: MCNearbyServiceAdvertiserDelegate {
//    
//}


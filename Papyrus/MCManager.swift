//
//  MCManager.swift
//  Papyrus
//
//  Created by Jean Paul Marinho on 30/07/17.
//  Copyright © 2017 aKANJ. All rights reserved.
//

import UIKit
import MultipeerConnectivity

protocol MCManagerDelegate {
    
    func foundPeer()
    func lostPeer()
    func invitationWasReceived(peer: MCPeerID)
    func connectedWithPeer(peer: MCPeerID)
}

class MCManager: NSObject {
    
    static let shared = MCManager()
    var session: MCSession!
    var peer: MCPeerID!
    var browser: MCNearbyServiceBrowser!
    var advertiser: MCNearbyServiceAdvertiser!
    var foundPeers = [MCPeerID]()
    var invitationHandler: ((Bool, MCSession?)->Void)!
    let serviceType = "com-papyrus"
    var delegate: MCManagerDelegate?
    
    override init() {
        super.init()
        self.peer = MCPeerID(displayName: UIDevice.current.name)
        self.session = MCSession(peer: self.peer)
        self.browser = MCNearbyServiceBrowser(peer: self.peer, serviceType: serviceType)
        self.browser.delegate = self
        self.advertiser = MCNearbyServiceAdvertiser(peer: self.peer, discoveryInfo: nil, serviceType: serviceType)
        
    }
}


//extension MCManager: MCSessionDelegate {
//    
//}
//
//
//
extension MCManager: MCNearbyServiceBrowserDelegate {
    
    func browser(_ browser: MCNearbyServiceBrowser, foundPeer peerID: MCPeerID, withDiscoveryInfo info: [String : String]?) {
        self.foundPeers.append(peerID)
        self.delegate?.foundPeer()
    }
    
    func browser(_ browser: MCNearbyServiceBrowser, lostPeer peerID: MCPeerID) {
        for (index, value) in self.foundPeers.enumerated() {
            if value == peerID {
                self.foundPeers.remove(at: index)
                break
            }
        }
        self.delegate?.lostPeer()
    }
    
    func browser(_ browser: MCNearbyServiceBrowser, didNotStartBrowsingForPeers error: Error) {
        print(error.localizedDescription)
    }
}



extension MCManager: MCNearbyServiceAdvertiserDelegate {
    
    func advertiser(_ advertiser: MCNearbyServiceAdvertiser, didReceiveInvitationFromPeer peerID: MCPeerID, withContext context: Data?, invitationHandler: @escaping (Bool, MCSession?) -> Void) {
        self.invitationHandler = invitationHandler
        self.delegate?.invitationWasReceived(peer: peerID)
    }
    
}


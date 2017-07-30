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
    func receivedText(text: String)
}

class MCManager: NSObject {
    
    static let shared = MCManager()
    let session = MCSession(peer: MCPeerID(displayName: UIDevice.current.name))
    var browser: MCNearbyServiceBrowser?
    var advertiser: MCNearbyServiceAdvertiser?
    var delegate: MCManagerDelegate?
    var foundPeers = [MCPeerID]()

    override init() {
        super.init()
        self.session.delegate = self
        self.updateState(.notConnected)
    }
    
    func start() {
        self.startBrowsing()
    }
    
    func startBrowsing() {
        self.startAdvertising()
        self.browser = MCNearbyServiceBrowser(peer: self.session.myPeerID, serviceType: "app1234")
        self.browser?.delegate = self
        self.browser?.startBrowsingForPeers()
        self.updateState(.browsing)
    }
    
    func stopBrowsing() {
        self.browser?.stopBrowsingForPeers()
        self.browser = nil
    }
    
    func startAdvertising() {
        self.stopBrowsing()
        self.advertiser = MCNearbyServiceAdvertiser(peer: self.session.myPeerID, discoveryInfo: nil, serviceType: "app1234")
        self.advertiser?.delegate = self
        self.advertiser?.startAdvertisingPeer()
        self.updateState(.advertising)
    }
    
    func stopAdvertising() {
        self.advertiser?.stopAdvertisingPeer()
        self.advertiser = nil
    }
    
    enum State {
        case notConnected
        case browsing
        case advertising
        case connecting
        case connected
    }
    
    func updateState(_ state: State, peerName: String? = nil) {
        DispatchQueue.main.async {
            switch state {
            case .notConnected:
                print("  + state = Not Connected")
                UIApplication.shared.isNetworkActivityIndicatorVisible = false
            case .browsing:
                print("  + state = Browsing")
                UIApplication.shared.isNetworkActivityIndicatorVisible = true
            case .advertising:
                print("  + state = Advertising")
                UIApplication.shared.isNetworkActivityIndicatorVisible = true
            case .connecting:
                print("  + state = Connecting")
                UIApplication.shared.isNetworkActivityIndicatorVisible = true
            case .connected:
                print("  + state = Connected")
                self.stopBrowsing()
                self.stopAdvertising()
                UIApplication.shared.isNetworkActivityIndicatorVisible = false
            }
        }
    }
    
    func sendText(text: String) {
        let text = text
        guard let textData = (text as NSString).data(using: String.Encoding.utf8.rawValue) else { return }
        do {
            try self.session.send(textData, toPeers: self.session.connectedPeers, with: .reliable)
            //            self.messages.append((text: "Olá! Teste", mine: true))
            //            self.tableView.reloadData()
        }
        catch {
        }
    }
}



extension MCManager: MCSessionDelegate {
    
    func session(_ session: MCSession, peer peerID: MCPeerID, didChange state: MCSessionState) {
        print("[MCSessionDelegate] session:peerID:didChangeState:")
        print("  + peerID = \(peerID.displayName)")
        switch state {
        case .notConnected:
            self.updateState(.notConnected)
        case .connecting:
            self.updateState(.connecting)
        case .connected:
            self.updateState(.connected, peerName: peerID.displayName)
        }
    }
    
    func session(_ session: MCSession, didReceive data: Data, fromPeer peerID: MCPeerID) {
        print("[MCSessionDelegate] session:didReceiveData:fromPeer:")
        print("  + peerID = \(peerID.displayName)")
        guard let text = NSString(data: data, encoding: String.Encoding.utf8.rawValue) as String? else { return }
        guard !text.isEmpty else { return }
        print("  + data = \(text)")
        self.delegate?.receivedText(text: text)
        //        self.messages.append((text: text, mine: false))
        DispatchQueue.main.async {
            //            self.tableView.reloadData()
        }
    }
    
    func session(_ session: MCSession, didReceiveCertificate certificate: [Any]?, fromPeer peerID: MCPeerID, certificateHandler: @escaping (Bool) -> Void) {
        certificateHandler(true)
    }
    
    func session(_ session: MCSession, didReceive stream: InputStream, withName streamName: String, fromPeer peerID: MCPeerID) {
    }
    
    func session(_ session: MCSession, didStartReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, with progress: Progress) {
    }
    
    func session(_ session: MCSession, didFinishReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, at localURL: URL?, withError error: Error?) {
    }
}



extension MCManager: MCNearbyServiceBrowserDelegate {
    
    func browser(_ browser: MCNearbyServiceBrowser, foundPeer peerID: MCPeerID, withDiscoveryInfo info: [String : String]?) {
        print("[MCNearbyServiceBrowserDelegate] browser:foundPeer:withDiscoveryInfo:")
        print("  + peerID = \(peerID.displayName)")
        print("  + info = \(String(describing: info))")
        self.foundPeers.append(peerID)
        browser.invitePeer(peerID, to: self.session, withContext: nil, timeout: 10)
        self.delegate?.foundPeer()
    }
    
    func browser(_ browser: MCNearbyServiceBrowser, lostPeer peerID: MCPeerID) {
        print("[MCNearbyServiceBrowserDelegate] browser:lostPeer:")
        print("  + peerID = \(peerID.displayName)")
    }
}



extension MCManager: MCNearbyServiceAdvertiserDelegate {
    func advertiser(_ advertiser: MCNearbyServiceAdvertiser, didReceiveInvitationFromPeer peerID: MCPeerID, withContext context: Data?, invitationHandler: @escaping (Bool, MCSession?) -> Void) {
        invitationHandler(true, self.session)
    }
}


//
//  ViewController.swift
//  Papyrus
//
//  Created by Jean Paul Marinho on 29/07/17.
//  Copyright © 2017 aKANJ. All rights reserved.
//

import UIKit
import MultipeerConnectivity

class ChatViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    let service_type = "PeerChat"
    let session = MCSession(peer: MCPeerID(displayName: UIDevice.current.name))
    var browser: MCNearbyServiceBrowser?
    var advertiser: MCNearbyServiceAdvertiser?

    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.session.delegate = self
        self.updateState(.notConnected)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.startBrowsing()
    }
    
    func startBrowsing() {
        self.startAdvertising()
        self.browser = MCNearbyServiceBrowser(peer: self.session.myPeerID, serviceType: service_type)
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
        self.advertiser = MCNearbyServiceAdvertiser(peer: self.session.myPeerID, discoveryInfo: nil, serviceType: service_type)
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
                self.navigationItem.title = "Not Connected"
                UIApplication.shared.isNetworkActivityIndicatorVisible = false
            case .browsing:
                print("  + state = Browsing")
                self.navigationItem.title = "Browsing..."
                UIApplication.shared.isNetworkActivityIndicatorVisible = true
            case .advertising:
                print("  + state = Advertising")
                self.navigationItem.title = "Advertising..."
                UIApplication.shared.isNetworkActivityIndicatorVisible = true
            case .connecting:
                print("  + state = Connecting")
                self.navigationItem.title = "Connecting..."
                self.navigationItem.rightBarButtonItem = nil
                UIApplication.shared.isNetworkActivityIndicatorVisible = true
            case .connected:
                print("  + state = Connected")
                self.stopBrowsing()
                self.stopAdvertising()
                self.navigationItem.title = peerName ?? "(Unknown Name)"
                UIApplication.shared.isNetworkActivityIndicatorVisible = false
            }
        }
    }

    @IBAction func actionPressed(_ sender: UIBarButtonItem) {
    }
}



extension ChatViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")
        return cell!
    }
}



extension ChatViewController: UITableViewDelegate {
    
}



extension ChatViewController: MCSessionDelegate {
    
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
        DispatchQueue.main.async {
            self.tableView.reloadData()
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



extension ChatViewController: MCNearbyServiceBrowserDelegate {
    
    func browser(_ browser: MCNearbyServiceBrowser, foundPeer peerID: MCPeerID, withDiscoveryInfo info: [String : String]?) {
        print("[MCNearbyServiceBrowserDelegate] browser:foundPeer:withDiscoveryInfo:")
        print("  + peerID = \(peerID.displayName)")
        print("  + info = \(String(describing: info))")
        browser.invitePeer(peerID, to: self.session, withContext: nil, timeout: 10)
    }
    
    func browser(_ browser: MCNearbyServiceBrowser, lostPeer peerID: MCPeerID) {
        print("[MCNearbyServiceBrowserDelegate] browser:lostPeer:")
        print("  + peerID = \(peerID.displayName)")
    }

}




extension ChatViewController: MCNearbyServiceAdvertiserDelegate {
    func advertiser(_ advertiser: MCNearbyServiceAdvertiser, didReceiveInvitationFromPeer peerID: MCPeerID, withContext context: Data?, invitationHandler: @escaping (Bool, MCSession?) -> Void) {
                print("[MCNearbyServiceAdvertiserDelegate] advertiser:didReceiveInvitationFromPeer:withContext:invitationHandler:")
                print("  + peerID = \(peerID.displayName)")
        
                let alert = UIAlertController(title: "Invitation", message: "from \(peerID.displayName)", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Accept", style: .default) { action in
                    invitationHandler(true, self.session)
                })
                alert.addAction(UIAlertAction(title: "Decline", style: .cancel) { action in
                    invitationHandler(false, self.session)
                })
                self.present(alert, animated: true, completion: nil)
    }

}

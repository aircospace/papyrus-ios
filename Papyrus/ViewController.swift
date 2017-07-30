//
//  ViewController.swift
//  Papyrus
//
//  Created by Jean Paul Marinho on 29/07/17.
//  Copyright © 2017 aKANJ. All rights reserved.
//

import UIKit
import MultipeerConnectivity

class ViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        MCManager.shared.delegate = self
        MCManager.shared.browser.startBrowsingForPeers()
    }
}



extension ViewController: UITableViewDataSource {
    
}



extension ViewController: UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return MCManager.shared.foundPeers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")
        cell?.textLabel?.text = MCManager.shared.foundPeers[indexPath.row].displayName
        return cell!
    }
}


extension ViewController: MCManagerDelegate {
    
    func foundPeer() {
        self.tableView.reloadData()
    }
    
    func lostPeer() {
        self.tableView.reloadData()
    }
    
    func invitationWasReceived(peer: MCPeerID) {
    }
    
    func connectedWithPeer(peer: MCPeerID) {
    }
}

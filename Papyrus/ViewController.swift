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
    var isAdvertising: Bool!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        MCManager.shared.delegate = self
        MCManager.shared.browser.startBrowsingForPeers()
        MCManager.shared.advertiser.startAdvertisingPeer()
        self.isAdvertising = true
    }
    
    @IBAction func actionPressed(_ sender: UIBarButtonItem) {
    }
}



extension ViewController: UITableViewDataSource {
    
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



extension ViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let selectedPeer = MCManager.shared.foundPeers[indexPath.row] as MCPeerID
        MCManager.shared.browser.invitePeer(selectedPeer, to: MCManager.shared.session, withContext: nil, timeout: 20)
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
        
        let alert = UIAlertController(title: "", message: "\(peer.displayName) wants to chat with you.", preferredStyle: UIAlertControllerStyle.alert)
        
        let acceptAction: UIAlertAction = UIAlertAction(title: "Accept", style: UIAlertActionStyle.default) { (alertAction) -> Void in
            MCManager.shared.invitationHandler(true, MCManager.shared.session)
        }
        
        let declineAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel) { (alertAction) -> Void in
            MCManager.shared.invitationHandler(false, nil)
        }
        
        alert.addAction(acceptAction)
        alert.addAction(declineAction)
        
        OperationQueue.main.addOperation { () -> Void in
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func connectedWithPeer(peer: MCPeerID) {
        OperationQueue.main.addOperation { () -> Void in
            print("Procimo")
//            self.performSegue(withIdentifier: "idSegueChat", sender: self)
        }
    }
}

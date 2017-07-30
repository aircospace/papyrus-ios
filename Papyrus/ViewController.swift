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
    @IBOutlet weak var textField: UITextField!
    var mcManager: MCManager!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.mcManager = MCManager()
        self.mcManager.delegate = self
        self.mcManager.start()
        
        
    }
    
    @IBAction func sendPressed(_ sender: UIButton) {
        self.mcManager.sendText(text: self.textField.text!)
    }
    @IBAction func actionPressed(_ sender: UIBarButtonItem) {
    }
}



extension ViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let value = (self.mcManager?.foundPeers.count)  else {
            return 0
        }
        return value
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")
        cell?.textLabel?.text = self.mcManager?.foundPeers[indexPath.row].displayName
        return cell!
    }
}



extension ViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let selectedPeer = self.mcManager?.foundPeers[indexPath.row] as! MCPeerID
        self.mcManager?.browser?.invitePeer(selectedPeer, to: (self.mcManager?.session)!, withContext: nil, timeout: 20)
    }
}


extension ViewController: MCManagerDelegate {
    
    func foundPeer() {
        self.tableView.reloadData()
    }
    
    func lostPeer() {
        self.tableView.reloadData()
    }
    
    func receivedText(text: String) {
        let alert = UIAlertController(title: "Message", message: text, preferredStyle: .alert)
        let okButton = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(okButton)
        self.present(alert, animated: true, completion: nil)
    }
}


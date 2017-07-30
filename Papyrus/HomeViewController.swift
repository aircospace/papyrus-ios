//
//  ContactViewController.swift
//  Papyrus
//
//  Created by Jean Paul Marinho on 30/07/17.
//  Copyright © 2017 aKANJ. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let vc = segue.destination as! ChatViewController
        vc.targetID = (sender! as! [String : Any])["name"] as! String
        vc.profileImageView = (sender! as! [String : Any])["image"] as! UIImage
        let isDestination = (sender! as! [String : Any])["isDestination"] as! Int
        if isDestination == 0 {
            vc.isDestination = true
        }
        else {
            vc.isDestination = false
        }
    }
}



extension HomeViewController: UITableViewDelegate {
    
}



extension HomeViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! HomeCell
        cell.profileImageView.image = UIImage(named: "profile\(indexPath.row)")
        switch indexPath.row {
        case 0:
            cell.nameLabel.text = "Jean Paul Marinho"
        case 1:
            cell.nameLabel.text = "Matheus Catossi"
        case 2:
            cell.nameLabel.text = "Victor Shynia"
        default:
            cell.nameLabel.text = "Carol"
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! HomeCell
        let dic = ["image":cell.profileImageView.image as Any, "name":cell.nameLabel.text!, "isDestination":indexPath.row] as [String : Any]
        self.performSegue(withIdentifier: "ToChatVC", sender: dic)
    }
}

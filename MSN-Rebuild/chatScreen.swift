//
//  ChatScreen.swift
//  MSN-Rebuild
//
//  Created by Albert on 28/08/19.
//  Copyright © 2019 Albert. All rights reserved.
//

import UIKit


enum UserStatus: String {
    case online =  "Online"
    case offline = "Offline"
    case busy = "Busy"
    case unavailable = "Unavailable"
}

class ChatScreenController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    var messages = Msgs.getAllMsgs()
    
    var user: String?
    var userMessage: [Message]?

    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Chats"
        
        tableView.delegate = self
        tableView.dataSource = self
        
        
    }
    
    //    MARK: É UMA GAMBIARRA
    
    override func viewWillAppear(_ animated: Bool) {
        tableView.reloadData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? ConversationScreen {
            vc.user = user
            vc.messages = userMessage
        }
    }
}

extension ChatScreenController {
   
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellId", for: indexPath)
    
        cell.textLabel?.text = messages[indexPath.row].user
        
        cell.detailTextLabel?.text = messages[indexPath.row].msg
        
        let userStatus = messages[indexPath.row].userStatus
        
        setStatus(cell: cell, status: userStatus!)
        let image = UIImage(named: messages[indexPath.row].userProfile)
        
        if let imageView = cell.imageView {
            imageView.image = image
            imageView.layer.cornerRadius = 35
            imageView.layer.borderWidth = 4
            imageView.layer.borderColor = UIColor.white.cgColor
            imageView.layer.masksToBounds = true
            imageView.clipsToBounds = true
        }
        return cell
    }
    
    fileprivate func setStatus(cell: UITableViewCell, status: UserStatus){
        switch status {
        case .online:
            let image = UIImageView(image: UIImage(named: "greenCircle"))
            image.frame = CGRect(x: 20, y: 20, width: 20, height: 20)
            cell.accessoryView = image
        case .offline:
            let image = UIImageView(image: UIImage(named: "redCircle"))
            image.frame = CGRect(x: 20, y: 20, width: 20, height: 20)
            cell.accessoryView = image
        case .busy:
            let image = UIImageView(image: UIImage(named: "yellowCircle"))
            image.frame = CGRect(x: 20, y: 20, width: 20, height: 20)
            cell.accessoryView = image
        default:
            let image = UIImageView(image: UIImage(named: "redCircle"))
            image.frame = CGRect(x: 20, y: 20, width: 20, height: 20)
            cell.accessoryView = image
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        user = messages[indexPath.row].user
        userMessage = messages.filter { (message) -> Bool in
            return message.user == user
        }
        
        performSegue(withIdentifier: "segue", sender: self)
    }
    
}




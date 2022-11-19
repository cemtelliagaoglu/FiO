//
//  ChatViewController.swift
//  FiO
//
//  Created by admin on 30.07.2022.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore


class ChatViewController:UIViewController{
    
    @IBOutlet weak var messageTextField: UITextField!
    @IBOutlet weak var tableView: UITableView!
    
    let defaults = UserDefaults.standard
    let db = Firestore.firestore()
    let currentUser = Auth.auth().currentUser!.email!
    
    var messages: [Message] = []
    var userNickname = ""
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(UINib(nibName: "MessageCell", bundle: nil), forCellReuseIdentifier: "Cell")
        tableView.dataSource = self
        tableView.delegate = self
        messageTextField.delegate = self
        navigationItem.hidesBackButton = true
        getUserData()
        loadMessages()
    }
    
    @IBAction func logOutButtonPressed(_ sender: UIBarButtonItem) {
        // Turn off Auto-login, and navigate to rootViewController
        do {
            try Auth.auth().signOut()
            defaults.removeObject(forKey: "email")
            defaults.removeObject(forKey: "password")
            navigationController?.popToRootViewController(animated: true)
            
        } catch let signOutError as NSError {
            print("Error signing out: %@", signOutError)
        }
    }
    
    func getUserData(){
        // Gets the nickname of authenticated user from FireStore
        
        let uid = Auth.auth().currentUser!.uid
        
        db.collection("users").document(uid).getDocument { documentSnapshot, error in
            if let e = error{
                print("Error while getting user's nickname: \(e)")
            }else{
                if let nickname = documentSnapshot?.data()?["nickname"] as? String{
                    self.userNickname = nickname
                }
            }
        }
        
    }
    
    @IBAction func sendButtonPressed(_ sender: UIButton) {
        sendMessage()
    }
    
    
    //MARK: - Writing / Reading Methods
    
    private func sendMessage(){
        if messageTextField.text != ""{

            db.collection("messages").addDocument(data: ["sender": currentUser,"senderNickname":userNickname, "body": messageTextField.text!, "date": Date().timeIntervalSince1970])
            
            DispatchQueue.main.async {
                self.messageTextField.text = ""
                self.tableView.reloadData()
            }
        }
    }
    
    func loadMessages(){
        //Load the messages by date order, and scroll to the last message
        
        db.collection("messages").order(by: "date").addSnapshotListener({(querySnapshot, error) in
            self.messages = []
            
            if let e = error{
                print("Couldn't get the messages from FireBase \(e)")
            }else{
                if let snapShot = querySnapshot?.documents{
                    for docs in snapShot{
                        let data = docs.data()
                        if let messageSender = data["sender"] as? String, let messageBody = data["body"] as? String, let nickname = data["senderNickname"] as? String{
                            let newMessage = Message(sender: messageSender, senderNickname: nickname, body: messageBody)
                            self.messages.append(newMessage)
                            
                            DispatchQueue.main.async {
                                self.tableView.reloadData()
                                let indexPath = IndexPath(row: self.messages.count - 1, section: 0)
                                self.tableView.scrollToRow(at: indexPath, at: .bottom, animated: true)
                            }
                        }
                    }
                }
            }
                
        })
    }
    
}
//MARK: - TextField Delegate

extension ChatViewController: UITextFieldDelegate{
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        sendMessage()
        return true
    }
}


//MARK: - TableView Methods

extension ChatViewController: UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! MessageCell
        
        let message = messages[indexPath.row]
        cell.messageLabel.text = message.body
        cell.nicknameLabel.text = message.senderNickname
        if currentUser == message.sender{
            cell.bubbleView.backgroundColor = .systemIndigo
            cell.setConstraints(isSender: true)
        }else{
            cell.bubbleView.backgroundColor = UIColor(named: "ChatColor")
            cell.setConstraints()
        }
        
        
        return cell
        
    }
    
}

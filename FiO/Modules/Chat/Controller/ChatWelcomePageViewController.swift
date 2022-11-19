//
//  ChatWelcomePage.swift
//  FiO
//
//  Created by admin on 22.09.2022.
//

import UIKit
import FirebaseAuth

class ChatWelcomePageViewController: UIViewController{
    let defaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    override func viewWillAppear(_ animated: Bool) {
        // Check if the user has already logged in, if yes then performSegue to Chat page

        if let email = defaults.object(forKey: "email") as? String, let pw = defaults.object(forKey: "password") as? String{
            Auth.auth().signIn(withEmail: email, password: pw) { [weak self] authResult, error in
                guard let strongSelf = self else { return }
                if error != nil{
                    print(error!)
                }else{
                    strongSelf.performSegue(withIdentifier: "HomeToChat", sender: strongSelf)
                }
            }
        }
    }
    
}

//
//  ChatRegisterPageViewController.swift
//  FiO
//
//  Created by admin on 22.09.2022.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore


class ChatRegisterPageViewController:UIViewController{

    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var nicknameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    let defaults = UserDefaults.standard
    let db = Firestore.firestore()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    @IBAction func registerButtonPressed(_ sender: UIButton) {
        // If registered successfully, save user data to UserDefaults
        // Then perform segue
        
        if let email = emailTextField.text , let pw = passwordTextField.text, let nickname = nicknameTextField.text{
            Auth.auth().createUser(withEmail: email, password: pw) { [weak self] authResult, error in
                guard let strongSelf = self else { return }
                if error != nil{
                    print(error!)
                    strongSelf.resetUI()
                }else{
                    strongSelf.defaults.set(email, forKey: "email")
                    strongSelf.defaults.set(pw, forKey: "password")
                    strongSelf.performSegue(withIdentifier: "RegisterToChat", sender: nil)
                }
            }
            
        }
        
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // After the user is registered successfully, saves the nickname of the account to FireStore
        
        if let uid = Auth.auth().currentUser?.uid, let nickname = nicknameTextField.text{
            db.collection("users").document(uid).setData(["nickname": nickname])
        }
    }
    
    func resetUI(){
        emailTextField.text = ""
        passwordTextField.text = ""
    }
    
    
}

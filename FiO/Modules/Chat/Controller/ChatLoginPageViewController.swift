//
//  LoginPageViewController.swift
//  FiO
//
//  Created by admin on 22.09.2022.
//

import UIKit
import FirebaseAuth

class ChatLoginPageViewController: UIViewController, UITextFieldDelegate{
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    var defaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        passwordTextField.delegate = self
    }
    
    @IBAction func loginButtonPressed(_ sender: UIButton) {
        tryLogin()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        tryLogin()
        return true
    }
    
    func tryLogin(){
        // If the user logs in successfully, save email & pw to UserDefaults
        // Then perform segue
        if let email = emailTextField.text , let pw = passwordTextField.text{
            Auth.auth().signIn(withEmail: email, password: pw) { [weak self] authResult, error in
                guard let strongSelf = self else { return }
                if error != nil{
                    print(error!)
                }else{
                    strongSelf.defaults.set(email, forKey: "email")
                    strongSelf.defaults.set(pw, forKey: "password")
                    
                    strongSelf.performSegue(withIdentifier: "LoginToChat", sender: strongSelf)
                    
                }
            }
        }
    }
}


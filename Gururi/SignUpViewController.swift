//
//  SignUpViewController.swift
//  Gururi
//
//  Created by Naoki Muroya on 2019/02/18.
//  Copyright © 2019 Gururi. All rights reserved.
//

import UIKit
import SVProgressHUD

class SignUpViewController: UIViewController, UITextFieldDelegate {

    // MARK: Components
    @IBOutlet weak var fullNameTextField: UITextField!
    @IBOutlet weak var shopNameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var signUpButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // validation check
        fullNameTextField.addTarget(self, action: #selector(formValidation), for: .editingChanged)
        shopNameTextField.addTarget(self, action: #selector(formValidation), for: .editingChanged)
        emailTextField.addTarget(self, action: #selector(formValidation), for: .editingChanged)
        passwordTextField.addTarget(self, action: #selector(formValidation), for: .editingChanged)

        // button layout
        signUpButton.isEnabled = false
        signUpButton.backgroundColor = UIColor(red: 149/255, green: 204/255, blue: 244/255, alpha: 1)
        signUpButton.layer.cornerRadius = 20.0
        
        // set delegate
        fullNameTextField.delegate = self
        shopNameTextField.delegate = self
        emailTextField.delegate = self
        passwordTextField.delegate = self
    }
    
    // MARK: Button Action
    @IBAction func signUpButtonPressed(_ sender: UIButton) {
        
        SVProgressHUD.show()
        
        auth.createUser(withEmail: emailTextField.text!, password: passwordTextField.text!) { (user, error) in
            if error != nil {
                print(error!)
                self.showAlert(message: "Failed to save!")
            } else {
                print("Signup Successful!")
                
                // create user document
                let user = auth.currentUser
                
                if let user = user {
                    db.collection("users").document(user.uid).setData([
                        "Name" : self.fullNameTextField.text!,
                        "Shop Name" : self.shopNameTextField.text!,
                        ])
                }
                SVProgressHUD.dismiss()
                if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
                    appDelegate.showTimelineStoryboard()
                }
            }
        }
    }
    
    // MARK: function
    // close keyboard
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        fullNameTextField.resignFirstResponder()
        shopNameTextField.resignFirstResponder()
        emailTextField.resignFirstResponder()
        passwordTextField.resignFirstResponder()
        return true
        
    }
    
    // validation check
    @objc func formValidation() {
        
        guard
            fullNameTextField.hasText,
            shopNameTextField.hasText,
            emailTextField.hasText,
            passwordTextField.hasText else {
                // handle case for above conditions not met
                signUpButton.isEnabled = false
                signUpButton.backgroundColor = UIColor(red: 149/255, green: 204/255, blue: 244/255, alpha: 1)
                return
        }
        
        // handle case for conditions were met
        signUpButton.isEnabled = true
        signUpButton.backgroundColor = UIColor(red: 17/255, green: 154/255, blue: 237/255, alpha: 1)
        
    }
    

}

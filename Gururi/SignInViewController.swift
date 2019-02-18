//
//  ViewController.swift
//  Gururi
//
//  Created by Naoki Muroya on 2019/02/12.
//  Copyright © 2019 Gururi. All rights reserved.
//

import UIKit
import Firebase
import SVProgressHUD

class SignInViewController: UIViewController, UITextFieldDelegate {
    
    //MARK: Components
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var signInButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // validation check
        emailTextField.addTarget(self, action: #selector(formValidation), for: .editingChanged)
        passwordTextField.addTarget(self, action: #selector(formValidation), for: .editingChanged)
        formValidation()
        
        // when already logged in
        if auth.currentUser != nil {
            if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
                appDelegate.showTimelineStoryboard()
            }
        }
        
        // button layout
        signInButton.isEnabled = false
        signInButton.backgroundColor = UIColor(red: 149/255, green: 204/255, blue: 244/255, alpha: 1)
        signInButton.layer.cornerRadius = 20.0
        
        // set delegate
        emailTextField.delegate = self
        passwordTextField.delegate = self
    }
    
    // MARK: Button Action
    // don't have an account
    @IBAction func signUpButtonPressed(_ sender: UIButton) {
        performSegue(withIdentifier: "goToSignUp", sender: nil)
    }
    
    // signin
    @IBAction func signInButtonPressed(_ sender: UIButton) {
        
        SVProgressHUD.show()
        
        if emailTextField.text != "" && passwordTextField.text != "" {
            
            auth.signIn(withEmail: emailTextField.text!, password: passwordTextField.text!) { (user, error) in
                
                if error != nil {
                    print(error!)
                } else {
                    print("Login Successful!")
                    SVProgressHUD.dismiss()
                    if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
                        appDelegate.showTimelineStoryboard()
                    }
                }
            }
        } else {
            // text filed is nil
            SVProgressHUD.dismiss()
            self.showAlert(message: "You need to fill everything!")
            return
        }
    }
    
    // MARK: function
    // close keyboard
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        emailTextField.resignFirstResponder()
        passwordTextField.resignFirstResponder()
        return true
        
    }
    
    // validation check
    @objc func formValidation() {
        
        guard
            emailTextField.hasText,
            passwordTextField.hasText else {
                // handle case for above conditions not met
                signInButton.isEnabled = false
                signInButton.backgroundColor = UIColor(red: 149/255, green: 204/255, blue: 244/255, alpha: 1)
                return
        }
        
        // handle case for conditions were met
        signInButton.isEnabled = true
        signInButton.backgroundColor = UIColor(red: 17/255, green: 154/255, blue: 237/255, alpha: 1)
        
    }
    
    
}


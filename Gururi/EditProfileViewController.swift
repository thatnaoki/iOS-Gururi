//
//  EditProfileViewController.swift
//  Gururi
//
//  Created by Naoki Muroya on 2019/02/24.
//  Copyright © 2019 Gururi. All rights reserved.
//

import UIKit

class EditProfileViewController: UIViewController, UITextFieldDelegate {

    // properties
    var shopName : String?
    var fullName : String?
    
    @IBOutlet weak var shopNameTextField: UITextField!
    @IBOutlet weak var fullNameTextField: UITextField!
    @IBOutlet weak var doneButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // validation check
        fullNameTextField.addTarget(self, action: #selector(formValidation), for: .editingChanged)
        shopNameTextField.addTarget(self, action: #selector(formValidation), for: .editingChanged)
        
        // button layout
        doneButton.backgroundColor = UIColor(red: 17/255, green: 154/255, blue: 237/255, alpha: 1)
        doneButton.layer.cornerRadius = 15.0
        cancelButton.layer.cornerRadius = 15.0
        
        // set delegate
        shopNameTextField.delegate = self
        fullNameTextField.delegate = self
        
        configureTextFields()
    }
    
    // MARK: button actions
    @IBAction func doneButtonPressed(_ sender: UIButton) {
        updateData()
        self.navigationController?.popToViewController((self.navigationController?.viewControllers[0])!, animated: true)
    }
    
    @IBAction func cancelButtonPressed(_ sender: Any) {
        self.navigationController?.popToViewController((self.navigationController?.viewControllers[0])!, animated: true)
    }
    

    // MARK: functions
    func configureTextFields() {
        guard let shopName = shopName else {return}
        guard let fullName = fullName else {return}
        shopNameTextField.text = shopName
        fullNameTextField.text = fullName
    }
    
    func updateData() {
        
        guard
            let shopName = shopNameTextField.text,
            let fullName = fullNameTextField.text,
            let uid = auth.currentUser?.uid else {return}
        
        db.collection("staff").document(uid).updateData([
            "name" : fullName,
            "shopName" : shopName
        ])
        
    }
    
    @objc func formValidation() {
        
        guard
            fullNameTextField.hasText,
            shopNameTextField.hasText else {
                // handle case for above conditions not met
                doneButton.isEnabled = false
                doneButton.backgroundColor = UIColor(red: 149/255, green: 204/255, blue: 244/255, alpha: 1)
                return
        }
        
        // handle case for conditions were met
        doneButton.isEnabled = true
        doneButton.backgroundColor = UIColor(red: 17/255, green: 154/255, blue: 237/255, alpha: 1)
        
    }
    
}

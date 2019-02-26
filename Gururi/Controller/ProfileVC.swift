//
//  ProfileViewController.swift
//  Gururi
//
//  Created by Naoki Muroya on 2019/02/18.
//  Copyright © 2019 Gururi. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController {

    // components
    @IBOutlet weak var shopNameLabel: UILabel!
    @IBOutlet weak var fullNameLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var numOfAllInvitationsLabel: UILabel!
    @IBOutlet weak var numOfWaitingInvitationsLabel: UILabel!
    @IBOutlet weak var numOfDoneInvitationsLabel: UILabel!
    @IBOutlet weak var changeButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // button layout
        changeButton.backgroundColor = UIColor(red: 17/255, green: 154/255, blue: 237/255, alpha: 1)
        changeButton.layer.cornerRadius = 20.0
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        configureLabels()
    }
    
    
    // MARK: button actions
    @IBAction func editButton(_ sender: UIButton) {
        performSegue(withIdentifier: "goToEditNames", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? EditProfileViewController {
            guard let shopName = shopNameLabel.text,
                  let fullName = fullNameLabel.text else {return}
            vc.shopName = shopName
            vc.fullName = fullName
        }
    }
    
    
    // MARK: functions
    // configure labels
    func configureLabels() {
        
        guard let user = auth.currentUser else {return}
        
        let uid = user.uid
        
        db.collection("staff").document(uid).getDocument { (document, error) in
            if let error = error {
                print("error occured" + error.localizedDescription)
                return
            }
            
            if let data = document?.data() {
                print("this is user data \(data)")
                
                if  let email = data["email"] as? String,
                    let fullName = data["name"] as? String,
                    let shopName = data["shopName"] as? String {
                    
                    self.emailLabel.text = email
                    self.fullNameLabel.text = fullName
                    self.shopNameLabel.text = shopName
                    
                }
            }
        }
    }
    
    
}

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
    @IBOutlet weak var profileImage: UIImageView!
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
        
        // configure labels
        configureLabels()
        
    }
    
    
    // MARK: button actions
    
    
    // MARK: functions
    // configure labels
    func configureLabels() {
        
        guard let user = auth.currentUser else {return}
        
        let uid = user.uid
        
        db.collection("users").document(uid).getDocument { (document, error) in
            if let error = error {
                print("error occured" + error.localizedDescription)
                return
            }
            
            if let data = document?.data() {
                print("this is user data \(data)")
            }
        }
    }
    
    
}

//
//  DetailReservationViewController.swift
//  Gururi
//
//  Created by Naoki Muroya on 2019/02/26.
//  Copyright © 2019 Gururi. All rights reserved.
//

import UIKit

class DetailReservationViewController: UIViewController {

    // MARK: properties
    @IBOutlet weak var shopNameLabel: UILabel!
    @IBOutlet weak var staffNameLabel: UILabel!
    @IBOutlet weak var guestNameLabel: UILabel!
    @IBOutlet weak var peopleLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var telLabel: UILabel!
    
    var reservation: Invitation?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // configure labels
        configureLabels()
    }
    
    // MARK: functions
    // configure labels
    func configureLabels() {
        guard let invitation = self.reservation else {return}
        getShopNameAndStaffName { shopName, staffName in
            self.shopNameLabel.text = shopName
            self.staffNameLabel.text = "\(String(describing: staffName!))さんからの招待"
        }
        guestNameLabel.text = "\(invitation.guestName!)様"
        peopleLabel.text = "\(invitation.people!)名様"
        dateLabel.text = invitation.date
        timeLabel.text = invitation.time
        telLabel.text = invitation.tel
    }
    
    // get shop and staff name
    func getShopNameAndStaffName(handler: @escaping(String?, String?)->Void){
        if let uid = auth.currentUser?.uid {
            db.collection("staff").document(uid).getDocument { documentSnapshot, error in
                if let data = documentSnapshot?.data() {
                    guard
                        let shopName = data["shopName"] as? String,
                        let staffName = data["name"] as? String else {return}
                    handler(shopName, staffName)
                }
            }
        }
    }
}

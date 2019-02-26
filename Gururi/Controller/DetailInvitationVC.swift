//
//  InvitationDetailViewController.swift
//  Gururi
//
//  Created by Naoki Muroya on 2019/02/26.
//  Copyright © 2019 Gururi. All rights reserved.
//

import UIKit

class DetailInvitationViewController: UIViewController {

    // MARK: properties
    @IBOutlet weak var shopNameLabel: UILabel!
    @IBOutlet weak var staffNameLabel: UILabel!
    @IBOutlet weak var guestNameLabel: UILabel!
    @IBOutlet weak var peopleLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var telLabel: UILabel!
    @IBOutlet weak var changeButton: UIButton!
    @IBOutlet weak var sendButton: UIButton!
    
    var invitation: Invitation?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // button layout
        changeButton.layer.cornerRadius = 15.0
        sendButton.layer.cornerRadius = 15.0
        
        // configure labels
        configureLabels()
    }

    // MARK: button actions
    // go to edit
    @IBAction func editButtonPressed(_ sender: UIButton) {
        performSegue(withIdentifier: "goToEdit", sender: self.invitation)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? EditInvitationViewController {
            vc.invitation = sender as? Invitation
        }
    }
    
    // send by LINE
    @IBAction func sendButtonPressed(_ sender: UIButton) {
        
        // unwrap
        guard let invitationId = self.invitation?.invitationId else {return}
        
        // URL scheme
        var urlScheme = "line://msg/text/?代行で予約しておいたので、予約内容の確認だけお願いします。【予約代行完了|ランデブー】https://reserve-beta.firebaseapp.com//invitepage/\(invitationId)"
        
        // encode
        urlScheme = urlScheme.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed)!
        
        // create URL
        guard let url = URL(string: urlScheme) else {
            print("cannot create URL")
            return
        }
        
        if UIApplication.shared.canOpenURL(url) {
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(url, options: [:], completionHandler: { (succes) in
                    
                })
            }else{
                UIApplication.shared.openURL(url)
            }
        }else {
            // if line is not installed
            let alertController = UIAlertController(title: "エラー",
                                                    message: "LINEがインストールされていません",
                                                    preferredStyle: UIAlertController.Style.alert)
            alertController.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default))
            present(alertController,animated: true,completion: nil)
        
        }
    
    }
    
    // MARK: functions
    // configure labels
    func configureLabels() {
        guard let invitation = self.invitation else {return}
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

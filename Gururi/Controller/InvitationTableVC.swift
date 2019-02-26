//
//  InvitationTableViewController.swift
//  Gururi
//
//  Created by Naoki Muroya on 2019/02/25.
//  Copyright © 2019 Gururi. All rights reserved.
//

import UIKit
import SVProgressHUD

class InvitationTableViewController: UITableViewController {

    // MARK: properties
    var invitations: [Invitation] = [Invitation]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureTableview()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        updateView()
    }
    
    // MARK: functions
    func updateView() {
        SVProgressHUD.show()
        fetchInvitationData() { invitations in
            self.invitations = invitations
            print("in updateView() -> \(self.invitations)")
            self.tableView.reloadData()
            SVProgressHUD.dismiss()
        }
    }
    
    
    func fetchInvitationData(completion: @escaping([Invitation])->Void) {
        
        var invitationList: [Invitation] = []
        
        guard let uid = auth.currentUser?.uid else {return}
        
        let group = DispatchGroup()
    
        db.collection("invite").whereField("from_uid", isEqualTo: uid).getDocuments() { querySnapshot, error in
            if let error = error {
                print(error)
                return
            }
            if let querySnapshot = querySnapshot {
                for document in querySnapshot.documents {
                    group.enter()
                    let data = document.data()
                    let invitationId = document.documentID
                    guard
                        let date = data["date"] as? String,
                        let time = data["time"] as? String,
                        let fromUid = data["from_uid"] as? String,
                        let guestName = data["guestName"] as? String,
                        let people = data["people"] as? String,
                        let tel = data["tel"] as? String,
                        let inviteFlag = data["inviteFlag"] as? Bool,
                        let staffName = data["staffName"] as? String else {return}
                    // create invitation instance
                    let invitation = Invitation(
                        invitationId: invitationId,
                        date: date,
                        time: time,
                        fromUid: fromUid,
                        guestName: guestName,
                        people: people,
                        tel: tel,
                        inviteFlag: inviteFlag,
                        staffName: staffName
                    )
                    // append invitaion instance
                    invitationList.append(invitation)
                    group.leave()
                }
                // closure
                group.notify(queue: .main) {
                    completion(invitationList)
                }
            }
        }
    }
}

extension InvitationTableViewController {
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return invitations.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! InvitationTableViewCell
        
        cell.invitation = self.invitations[indexPath.row]
        
        return cell
        
    }
    
}

extension InvitationTableViewController {
    
    // MARK: - Table view delegate
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToDetail", sender: invitations[indexPath.row])
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? DetailInvitationViewController {
            vc.invitation = sender as? Invitation
        }
    }
    
}

// MARK: configure tableview
extension InvitationTableViewController {
    func configureTableview() {
        tableView.register(UINib(nibName: "InvitationTableViewCell", bundle: nil), forCellReuseIdentifier: "cell")
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 140
    }
    
}

//
//  ReservationTableViewController.swift
//  Gururi
//
//  Created by Naoki Muroya on 2019/02/26.
//  Copyright © 2019 Gururi. All rights reserved.
//

import UIKit
import SVProgressHUD

class ReservationTableViewController: UITableViewController {

    // MARK: properties
    var reservations: [Invitation] = [Invitation]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        updateView()
        configureTableview()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        updateView()
    }
    
    // MARK: functions
    func updateView() {
        SVProgressHUD.show()
        fetchInvitationData() { reservations in
            self.reservations = reservations
            print("in updateView() -> \(self.reservations)")
            self.tableView.reloadData()
            SVProgressHUD.dismiss()
        }
    }
    
    
    func fetchInvitationData(completion: @escaping([Invitation])->Void) {
        
        var reservationList: [Invitation] = []
        
        guard let uid = auth.currentUser?.uid else {return}
        
        let group = DispatchGroup()
        
        db.collection("invite").whereField("from_uid", isEqualTo: uid).whereField("inviteFlag", isEqualTo: false).getDocuments() { querySnapshot, error in
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
                    reservationList.append(invitation)
                    group.leave()
                }
                // closure
                group.notify(queue: .main) {
                    completion(reservationList)
                }
            }
        }
    }
}

extension ReservationTableViewController {
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return reservations.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! ReservationTableViewCell
        
        cell.reservation = self.reservations[indexPath.row]
        
        return cell
        
    }
    
}

extension ReservationTableViewController {
    
    // MARK: - Table view delegate
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToDetail", sender: reservations[indexPath.row])
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? DetailReservationViewController {
            vc.reservation = sender as? Invitation
        }
    }
}

// MARK: configure tableview
extension ReservationTableViewController {
    func configureTableview() {
        tableView.register(UINib(nibName: "ReservationTableViewCell", bundle: nil), forCellReuseIdentifier: "cell")
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 140
    }
    
}

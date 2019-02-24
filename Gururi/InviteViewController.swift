//
//  InviteViewController.swift
//  Gururi
//
//  Created by Naoki Muroya on 2019/02/19.
//  Copyright © 2019 Gururi. All rights reserved.
//

import UIKit

class InviteViewController: UIViewController {
    
    // properties
    @IBOutlet weak var shopNameTextField: UITextField!
    @IBOutlet weak var dateTextField: PickerTextField!
    @IBOutlet weak var timeTextField: PickerTextField!
    @IBOutlet weak var guestNameTextField: UITextField!
    @IBOutlet weak var peopleTextField: PickerTextField!
    @IBOutlet weak var telTextField: UITextField!
    @IBOutlet weak var addButton: UIButton!
    
    let datePicker = UIPickerView()
    let timePicker = UIPickerView()
    
    // prepare lists for picker view
    var timeList : [String] = ["18:00", "18:30", "19:00", "19:30", "20:00", "20:30", "21:00", "21:30", "22:00", "22:30", "23:00"]
    var peopleList : [String] = ["1", "2", "3", "4", "5", "6", "7", "8"]
    var dateList : [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // button layout
        addButton.isEnabled = false
        addButton.backgroundColor = UIColor(red: 149/255, green: 204/255, blue: 244/255, alpha: 1)
        addButton.layer.cornerRadius = 20.0
        
        // validation check
        shopNameTextField.addTarget(self, action: #selector(formValidation), for: .editingChanged)
        dateTextField.addTarget(self, action: #selector(formValidation), for: .editingChanged)
        timeTextField.addTarget(self, action: #selector(formValidation), for: .editingChanged)
        guestNameTextField.addTarget(self, action: #selector(formValidation), for: .editingChanged)
        peopleTextField.addTarget(self, action: #selector(formValidation), for: .editingChanged)
        telTextField.addTarget(self, action: #selector(formValidation), for: .editingChanged)
        
        // init shop name
        getShopName { shopName in
            self.shopNameTextField.text = shopName
        }
        
        // configure picker views
        configurePickerViews()

    }
    
    // MARK: functions
    // close keyboard
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        shopNameTextField.resignFirstResponder()
        guestNameTextField.resignFirstResponder()
        telTextField.resignFirstResponder()
        return true
        
    }
    
    @objc func formValidation() {
        
        guard
            shopNameTextField.hasText,
            dateTextField.hasText,
            timeTextField.hasText,
            guestNameTextField.hasText,
            peopleTextField.hasText,
            telTextField.hasText else {
                // handle case for above conditions not met
                addButton.isEnabled = false
                addButton.backgroundColor = UIColor(red: 149/255, green: 204/255, blue: 244/255, alpha: 1)
                return
        }
        
        // handle case for conditions were met
        addButton.isEnabled = true
        addButton.backgroundColor = UIColor(red: 17/255, green: 154/255, blue: 237/255, alpha: 1)
        
    }
    
    // get shop name
    func getShopName(handler: @escaping(String?)->Void){
        if let uid = auth.currentUser?.uid {
            db.collection("staff").document(uid).getDocument { documentSnapshot, error in
                if let data = documentSnapshot?.data() {
                    guard let shopName = data["shopName"] as? String else {return}
                    handler(shopName)
                }
            }
        }
    }
    
    // configure PickerViews
    func configurePickerViews() {
        // prepare date picker
        prepareDateList()
        dateTextField.setup(dataList: dateList)
        dateTextField.text = dateList[0]
        // prepare time picker views
        timeTextField.setup(dataList: timeList)
        timeTextField.text = timeList[0]
        // prepare people picker view
        peopleTextField.setup(dataList: peopleList)
        peopleTextField.text = peopleList[0]
    }
    
    // prepare for date picker view
    func prepareDateList() {
        
        let today = Date()
        let tomorrow = today + 60*60*24
        
        let formatter = DateFormatter()
        formatter.dateFormat = "MM月dd日"
        let todayString = "\(formatter.string(from: today))"
        let tomorrowString = "\(formatter.string(from: tomorrow))"
        
        dateList = [todayString, tomorrowString]
    }

}

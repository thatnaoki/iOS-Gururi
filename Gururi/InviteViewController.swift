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
    @IBOutlet weak var dateTextField: UITextField!
    @IBOutlet weak var timeTextField: PickerTextField!
    @IBOutlet weak var guestNameTextField: UITextField!
    @IBOutlet weak var peopleTextField: PickerTextField!
    @IBOutlet weak var telTextField: UITextField!
    @IBOutlet weak var addButton: UIButton!
    
    // prepare lists for picker view
    var timeList : [String] = ["18:00", "19:00", "20:00", "21:00"]
    var peopleList : [String] = ["2", "3", "4", "5", "6", "7"]
    
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
        
        // prepare date picker views
        prepareDatePicker()
        // prepare time picker views
        timeTextField.setup(dataList: timeList)
        // prepare people picker view
        peopleTextField.setup(dataList: peopleList)

    }
    
    // functions
    func prepareDatePicker() {
        
        let datePicker = UIDatePicker()
        datePicker.datePickerMode = UIDatePicker.Mode.date
        datePicker.timeZone = NSTimeZone.local
        datePicker.locale = Locale.current
        
        let toolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: 35))
        let spaceItem = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
        let doneItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneForDatePicker))
        toolbar.setItems([spaceItem, doneItem], animated: true)
        
        dateTextField.inputView = datePicker
        dateTextField.inputAccessoryView = toolbar
        
    }
    
    // func called when item choosen
    @objc func doneForDatePicker() {
        dateTextField.endEditing(true)
        
        // date format
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        dateTextField.text = "\(formatter.string(from: Date()))"
    }
    
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

}



// extension for time picker
extension InviteViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    
    func prepareTimePicker() {
        
        let timePicker = UIPickerView()
        timePicker.delegate = self
        timePicker.dataSource = self
        timePicker.showsSelectionIndicator = true
        
        let toolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: 35))
        let spaceItem = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
        let doneItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneForTimePicker))
        toolbar.setItems([spaceItem, doneItem], animated: true)
        
        timeTextField.inputView = timePicker
        timeTextField.inputAccessoryView = toolbar
        
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return timeList.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return timeList[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        timeTextField.text = timeList[row]
    }
    
    @objc func doneForTimePicker() {
        timeTextField.endEditing(true)
    }
    
}

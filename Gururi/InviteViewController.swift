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
    @IBOutlet weak var dateTextField: UITextField!
    @IBOutlet weak var timeTextField: UITextField!
    @IBOutlet weak var addButton: UIButton!
    
    // prepare date and time picker
    let datePicker = UIDatePicker()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // button layout
        addButton.backgroundColor = UIColor(red: 17/255, green: 154/255, blue: 237/255, alpha: 1)
        addButton.layer.cornerRadius = 20.0
        
        prepareDatePicker()

    }
    
    // functions
    func prepareDatePicker() {
        
        datePicker.datePickerMode = UIDatePicker.Mode.date
        datePicker.timeZone = NSTimeZone.local
        datePicker.locale = Locale.current
        
        let toolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: 35))
        let spacelItem = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
        let doneItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(done))
        toolbar.setItems([spacelItem, doneItem], animated: true)
        
        dateTextField.inputView = datePicker
        dateTextField.inputAccessoryView = toolbar
        
    }
    
    @objc func done() {
        dateTextField.endEditing(true)
        
        // 日付のフォーマット
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        dateTextField.text = "\(formatter.string(from: Date()))"
    }

}

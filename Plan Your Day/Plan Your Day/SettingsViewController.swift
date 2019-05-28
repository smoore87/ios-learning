//
//  SettingsViewController.swift
//  Plan Your Day
//
//  Created by Sandra Moore on 5/21/19.
//  Copyright © 2019 Sandra Moore. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController {
    @IBOutlet weak var timeZonePicker: UIPickerView!
    @IBOutlet weak var homeAddress: UITextView!
    @IBOutlet weak var workAddress: UITextView!
    @IBOutlet weak var weatherZip: UITextView!
    
    let timeZoneOptions = ["EST", "CST", "MST", "PST"]
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
}

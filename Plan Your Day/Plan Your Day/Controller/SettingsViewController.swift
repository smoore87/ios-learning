//
//  SettingsViewController.swift
//  Plan Your Day
//
//  Created by Sandra Moore on 5/21/19.
//  Copyright © 2019 Sandra Moore. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    @IBOutlet weak var timeZonePicker: UIPickerView!
    @IBOutlet weak var homeStreet: UITextView!
    @IBOutlet weak var homeCity: UITextView!
    @IBOutlet weak var homeState: UITextView!
    @IBOutlet weak var homeZipCode: UITextView!
    
    var timeZoneOptions: [String] = [String]()
    var modelController: ModelController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        homeZipCode.text = modelController.zipCode
        // TODO: Select timezone in picker
        
        // Connect data:
        self.timeZonePicker.delegate = self
        self.timeZonePicker.dataSource = self
        timeZoneOptions = ["EST", "CST", "MST", "PST"]
    }
    
    /********************************************************************
     Methods that need to be overwritten because of using UIPicker
     ********************************************************************/
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // Number of columns of data
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    // The number of rows of data
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return timeZoneOptions.count
    }
    
    // The data to return fopr the row and component (column) that's being passed in
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return timeZoneOptions[row]
    }
    
    /********************************************************************
     Pass information back to the Dashboard via segue
     ********************************************************************/
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if let dashboardViewController = segue.destination as? DashboardViewController {
            modelController.zipCode = homeZipCode.text
            //TODO set time zone value
            dashboardViewController.modelController = modelController
        }
    }
}

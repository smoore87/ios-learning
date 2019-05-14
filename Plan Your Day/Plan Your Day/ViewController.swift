//
//  ViewController.swift
//  Plan Your Day
//
//  Created by Sandra Moore on 5/14/19.
//  Copyright © 2019 Sandra Moore. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var welcomeLabel: UILabel!
    
    var timer = Timer()
    var date = Date()
    let dateFormatter = DateFormatter()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setWelcomeLabel()
        timeLabel.text = getTime(date: date)
        dateLabel.text = getDate(date: date)
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector:#selector(self.tick) , userInfo: nil, repeats: true)
    }
    
    func getTime(date : Date) -> String {
        dateFormatter.dateFormat = "h:mm a"
        return dateFormatter.string(from : date)
    }
    
    func getDate(date : Date) -> String {
        dateFormatter.dateFormat = "EEEE, MMM d, yyyy"
        return dateFormatter.string(from : date)
    }
    
    func setWelcomeLabel() {
        let calendar = Calendar.current
        let hour = calendar.component(.hour, from: date)
        if(hour < 12){
            welcomeLabel.text = "Good Morning Sandie!"
        }
        else if(hour < 17){
            welcomeLabel.text = "Good Afternoon Sandie!"
        }
        else{
            welcomeLabel.text = "Good Evening Sandie!"
        }
    }
    
    @objc func tick() {
        date = Date();
        timeLabel.text = getTime(date: date)
    }

}


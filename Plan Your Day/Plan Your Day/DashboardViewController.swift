//
//  ViewController.swift
//  Plan Your Day
//
//  Created by Sandra Moore on 5/14/19.
//  Copyright © 2019 Sandra Moore. All rights reserved.
//

import UIKit

class DashboardViewController: UIViewController {
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var welcomeLabel: UILabel!
    @IBOutlet weak var timeIcon: UIImageView!
    @IBOutlet weak var settingsButton: UIButton!
    
    var timer = Timer()
    var date = Date()
    let dateFormatter = DateFormatter()
    let nightImage = UIImage(named: "icons8-partly_cloudy_night")
    let dayImage = UIImage(named: "icons8-sun")
    let BEGIN_MORNING_HOUR = 7
    let BEGIN_AFTERNOON_HOUR = 12
    let BEGIN_EVENING_HOUR = 17
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initializeDashboard()
    }
    
    func initializeDashboard() {
        timeLabel.text = getTime(date: date)
        dateLabel.text = getDate(date: date)
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector:#selector(self.tick) , userInfo: nil, repeats: true)
        setWelcomeLabel()
        setTimeOfDayIcon()
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
        if(hour > BEGIN_MORNING_HOUR && hour < BEGIN_AFTERNOON_HOUR){
            welcomeLabel.text = "Good Morning Sandie!"
        }
        else if(hour > BEGIN_AFTERNOON_HOUR && hour < BEGIN_EVENING_HOUR){
            welcomeLabel.text = "Good Afternoon Sandie!"
        }
        else{
            welcomeLabel.text = "Good Evening Sandie!"
        }
    }
    
    func setTimeOfDayIcon() {
        let calendar = Calendar.current
        let hour = calendar.component(.hour, from: date)
        timeIcon.image = dayImage
        if(hour < BEGIN_MORNING_HOUR || hour > BEGIN_EVENING_HOUR){
            timeIcon.image = nightImage
        }
    }
    
    @objc func tick() {
        //dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        date = Date();
        timeLabel.text = getTime(date: date)
    }
    
    func setWeather() {
        
    }

}


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
    
    var timer = Timer()
    var date = Date()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        timeLabel.text = getTime(date: date)
        dateLabel.text = getDate(date: date)
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector:#selector(self.tick) , userInfo: nil, repeats: true)

    }
    
    func getTime(date : Date) -> String {
        let dateFormatter : DateFormatter = DateFormatter()
        dateFormatter.dateFormat = "h:mm a"
        return dateFormatter.string(from : date)
    }
    
    func getDate(date : Date) -> String {
        let dateFormatter : DateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE, MMM d, yyyy"
        return dateFormatter.string(from : date)
    }
    
    @objc func tick() {
        date = Date();
        timeLabel.text = getTime(date: date)
    }

}


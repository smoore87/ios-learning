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
    @IBOutlet weak var toDoView: UIView!
    @IBOutlet weak var weatherLocationLabel: UILabel!
    @IBOutlet weak var weatherHighTempLabel: UILabel!
    @IBOutlet weak var weatherLowTempLabel: UILabel!
    @IBOutlet weak var weatherCurrentTempLabel: UILabel!
    @IBOutlet weak var weatherStatusLabel: UILabel!
    
    var timer = Timer()
    var date = Date()
    let dateFormatter = DateFormatter()
    let nightImage = UIImage(named: "icons8-partly_cloudy_night")
    let dayImage = UIImage(named: "icons8-sun")
    let BEGIN_MORNING_HOUR = 7
    let BEGIN_AFTERNOON_HOUR = 12
    let BEGIN_EVENING_HOUR = 17
    
    var toDoList: [ToDoItem] = []
    var userSelectedTimeZone = "CST"
    var homeCity = "Phoenix"
    var homeState = "AZ"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initializeDashboard()
    }
    
    func initializeDashboard() {
        timeLabel.text = getTime(date: date)
        dateLabel.text = getDate(date: date)
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector:#selector(self.tick) , userInfo: nil, repeats: true)
        weatherLocationLabel.text = homeCity
        getWeatherForCity(city: homeCity)
        setWelcomeLabel()
        setTimeOfDayIcon()
        showToDoList()
    }
    
    func getTime(date : Date) -> String {
        dateFormatter.timeZone = TimeZone(abbreviation: userSelectedTimeZone)
        dateFormatter.dateFormat = "h:mm a zz"
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
    
    // TODO: Do something else with this or remove it. It's redundant with the weather icons
    func setTimeOfDayIcon() {
        let calendar = Calendar.current
        let hour = calendar.component(.hour, from: date)
        timeIcon.image = dayImage
        if(hour < BEGIN_MORNING_HOUR || hour > BEGIN_EVENING_HOUR){
            timeIcon.image = nightImage
        }
    }
    
    @objc func tick() {
        date = Date();
        timeLabel.text = getTime(date: date)
    }
    
    //TODO: DRY up this code calling the APIs
    func getWeatherForCity(city : String) {
        print("Requesting weather id for city: ", homeCity)

        let url = URL(string: "https://www.metaweather.com/api/location/search/?query=" + homeCity)
        let task = URLSession.shared.dataTask(with: url!) { (data, response, error) in
            guard let dataResponse = data,
                error == nil else {
                    print(error?.localizedDescription ?? "Response Error")
                    return }
            do{
                //here dataResponse received from a network request
                let jsonResponse = try JSONSerialization.jsonObject(with:
                    dataResponse, options: [])
                guard let jsonArray = jsonResponse as? [[String: Any]] else {
                    return
                }
                //Now get weather id value
                guard let woeid = jsonArray[0]["woeid"] as? Int else { return }
                print("Weather id: " , woeid)
                self.getWeather(weatherId: woeid)
                
            } catch let parsingError {
                print("Error", parsingError)
            }
        }
        task.resume()
    }
    
    func getWeather(weatherId : Int) {
        let url = URL(string: "https://www.metaweather.com/api/location/" + String(weatherId))
        print("Requesting weather information by id")
        let task = URLSession.shared.dataTask(with: url!) { (data, response, error) in
            guard let dataResponse = data,
                error == nil else {
                    print(error?.localizedDescription ?? "Response Error")
                    return }
            do{
                //here dataResponse received from a network request
                let jsonResponse = try JSONSerialization.jsonObject(with:
                    dataResponse, options: [])
                guard let jsonArray = jsonResponse as? [String: Any] else {
                    return
                }
                
                guard let consolidatedWeather = jsonArray["consolidated_weather"] as? NSArray else { return }
                
                guard let todayWeather = consolidatedWeather[0] as? NSDictionary else { return }
                
            
                let minTemp = todayWeather["min_temp"] as? Double
                let maxTemp = todayWeather["max_temp"] as? Double
                let currentTemp = todayWeather["the_temp"] as? Double
                let description = todayWeather["weather_state_name"] as? String
                self.setWeather(todayWeather : Weather(id : weatherId, description: description!, currentTemp: currentTemp!, minTemp : minTemp!, maxTemp : maxTemp!))
                
            } catch let parsingError {
                print("Error", parsingError)
            }
        }
        task.resume()
    }
    
    func setWeather(todayWeather : Weather) {
        weatherStatusLabel.text = todayWeather.getDescription()
        weatherLowTempLabel.text = convertToFahrenheit(celcius: todayWeather.getMinTemp())
        weatherHighTempLabel.text = convertToFahrenheit(celcius: todayWeather.getMaxTemp())
        weatherCurrentTempLabel.text = convertToFahrenheit(celcius: todayWeather.getCurrentTemp())
        //TODO *Sigh* this works but doesn't populate the labels. Time to learn Swift Promises/Futures? Refreshing the component doesn't seem like the right thing to do. Pick up here next time.
    }
    
    func convertToFahrenheit(celcius : Double) -> String {
        let fahrenheitTemperature = celcius * 9 / 5 + 32
        return String(round(fahrenheitTemperature))
    }
    
    func showToDoList() {
        var yIndex = 50
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "M-dd h:mm a"
        for item in toDoList {
            let label = UILabel()
            label.numberOfLines = 0
            label.text = dateFormatter.string(from: item.getDueDate()) + "\t\t" + item.getText()
            label.textColor = UIColor.white
            label.textAlignment =  NSTextAlignment.left
            label.frame = CGRect(x : 10, y : yIndex, width : 330, height : 40)
            self.toDoView.addSubview(label)
            label.sizeToFit()
            yIndex = yIndex + 25
        }
    }

}


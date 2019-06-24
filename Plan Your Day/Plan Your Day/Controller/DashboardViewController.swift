//
//  ViewController.swift
//  Plan Your Day
//
//  Created by Sandra Moore on 5/14/19.
//  Copyright © 2019 Sandra Moore. All rights reserved.
//

import UIKit
import CoreLocation
import Alamofire
import SwiftyJSON

class DashboardViewController: UIViewController, CLLocationManagerDelegate {
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var welcomeLabel: UILabel!
    @IBOutlet weak var timeIcon: UIImageView!
    @IBOutlet weak var settingsButton: UIButton!
    @IBOutlet weak var toDoView: UIView!
    @IBOutlet weak var weatherLocationLabel: UILabel!
    @IBOutlet weak var weatherCurrentTempLabel: UILabel!
    @IBOutlet weak var weatherStatusLabel: UILabel!
    @IBOutlet weak var weatherIcon: UIImageView!
    
    var timer = Timer()
    var date = Date()
    let dateFormatter = DateFormatter()
    let nightImage = UIImage(named: "icons8-partly_cloudy_night")
    let dayImage = UIImage(named: "icons8-sun")
    let BEGIN_MORNING_HOUR = 7
    let BEGIN_AFTERNOON_HOUR = 12
    let BEGIN_EVENING_HOUR = 17
    let WEATHER_URL = "http://api.openweathermap.org/data/2.5/weather"
    let APP_ID = "93302ee5d8b59c25f118427aee3ef7e5"
    let locationManager = CLLocationManager()

    var weatherData = Weather()
    var toDoList: [ToDoItem] = []
    var userSelectedTimeZone = ""
    var zipCode = ""
    var modelController: ModelController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set up location
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters //make sure that this is appropriate for the location usage
        locationManager.requestWhenInUseAuthorization() //triggers the location auth pop-up
        locationManager.startUpdatingLocation()
        
        initializeDashboard()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        weatherData = modelController.weather
        toDoList = modelController.toDoList
        zipCode = modelController.zipCode
        userSelectedTimeZone = modelController.timeZone
        initializeDashboard()
    }
    
    func initializeDashboard() {
        timeLabel.text = getTime(date: date)
        dateLabel.text = getDate(date: date)
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector:#selector(self.tick) , userInfo: nil, repeats: true)
        setWelcomeLabel()
        setTimeOfDayIcon()
        showToDoList()
  
        if(!self.zipCode.isEmpty) {
            let params : [String : String] = ["zip" : self.zipCode, "appid" : APP_ID]
            print("Calling getWeatherData() from initializeDashboard() with zipCode", self.zipCode)
            getWeatherData(url: WEATHER_URL, parameters: params)
        }
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
    
    func getWeatherData(url : String, parameters : [String : String]) {
        print(parameters)
        Alamofire.request(url, method: .get, parameters : parameters).responseJSON {
            response in // <-- indicates a closure
            if response.result.isSuccess {
                print("Success! Got the weather data!")
                let weatherJSON : JSON = JSON(response.result.value!)
                self.updateWeatherData(json: weatherJSON)
                print(weatherJSON)
            }
            else {
                print("Error \(String(describing: response.result.error))")
                self.weatherLocationLabel.text = "Connection Issues"
            }
        }
    }
    
    func updateWeatherData( json : JSON) {
        if let tempResult = json["main"]["temp"].double { // Check that this value isn't nil before proceeding
            weatherLocationLabel.text = json["name"].stringValue
            weatherData.setCurrentTemp(currentTemp: self.convertToFahrenheit(celcius: tempResult - 273.15))
            weatherData.setCondition(condition: json["weather"][0]["id"].intValue)
            weatherData.setIconName( iconName : weatherData.updateWeatherIcon(condition: weatherData.condition))
            weatherData.setDescription(description: weatherData.updateWeatherDescription(condition: weatherData.condition))
            setWeather()
        }
        else {
            self.weatherLocationLabel.text = "Weather Unavailable"
        }
    }

    //didUpdateLocations method
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        // the last value in the array is the most accurate
        let location = locations[locations.count - 1]
        if location.horizontalAccuracy > 0 {
            // stop updating location as soon as you have a valid result
            locationManager.stopUpdatingLocation()
            let latitude = String(location.coordinate.latitude)
            let longitude = String(location.coordinate.longitude)
            
            let params : [String : String] = ["lat" : latitude, "lon" : longitude, "appid" : APP_ID]
            if(self.zipCode.isEmpty){
                print("Calling getWeatherData() from location Manager")
                getWeatherData(url: WEATHER_URL, parameters: params)
            }
        }
    }
    
    
    //Write the didFailWithError method here:
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
        self.weatherLocationLabel.text = "Location Unavailable"
    }
    
    func setWeather() {
        weatherStatusLabel.text = weatherData.getDescription()
        weatherCurrentTempLabel.text = String(weatherData.getCurrentTemp())
        weatherIcon.image = UIImage(named : weatherData.getIconName())
        weatherStatusLabel.text = weatherData.getDescription()
    }
    
    func convertToFahrenheit(celcius : Double) -> Double {
        let fahrenheitTemperature = celcius * 9 / 5 + 32
        return round(fahrenheitTemperature)
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        modelController.toDoList = toDoList
        modelController.weather = weatherData
        modelController.zipCode = zipCode
        modelController.timeZone = userSelectedTimeZone
        if let toDoViewController = segue.destination as? ToDoViewController {
            toDoViewController.modelController = modelController
        }
        else if let settingsController = segue.destination as? SettingsViewController {
            settingsController.modelController = modelController
        }
    }

}


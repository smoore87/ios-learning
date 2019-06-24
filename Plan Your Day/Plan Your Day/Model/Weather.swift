//
//  Weather.swift
//  Plan Your Day
//
//  Created by Sandra Moore on 5/29/19.
//  Copyright © 2019 Sandra Moore. All rights reserved.
//

import UIKit

class Weather {
    var description = String()
    var currentTemp = Double()
    var condition = Int()
    var iconName = ""

    func getDescription() -> String {
        return self.description
    }
    
    func setDescription(description : String) {
        self.description = description
    }
    
    func getCurrentTemp() -> Double {
        return self.currentTemp
    }
    
    func setCurrentTemp(currentTemp : Double) {
        self.currentTemp = currentTemp
    }
    
    func getIconName() -> String {
        return self.iconName
    }
    
    func setIconName(iconName : String) {
        self.iconName = iconName
    }
    
    func getCondition() -> Int {
        return self.condition
    }
    
    func setCondition(condition : Int) {
        self.condition = condition
    }
    
    func updateWeatherIcon(condition: Int) -> String {
        
        switch (condition) {
            
        case 0...300 :
            return "icons8-storm"
            
        case 301...600 :
            return "icons8-rain"
            
        case 601...700 :
            return "icons8-snow"
            
        case 701...771 :
            return "icons8-cloud"
            
        case 772...799 :
            return "icons8-storm"
            
        case 800 :
            return "icons8-sun"
            
        case 801...804 :
            return "icons8-cloud"
            
        case 900...903, 905...1000  :
            return "icons8-storm"
            
        case 903 :
            return "icons8-snow"
            
        case 904 :
            return "icons8-sun"
            
        default :
            return "dunno"
        }
        
    }
    
    func updateWeatherDescription(condition : Int) -> String {
        switch (condition) {
            
        case 0...300 :
            return "Thunderstorms"
            
        case 301...600 :
            return "Rainy"
            
        case 601...700 :
            return "Snow"
            
        case 701...771 :
            return "Fog"
            
        case 772...799 :
            return "Thunderstorms"
            
        case 800 :
            return "Sunny"
            
        case 801...804 :
            return "Cloudy"
            
        case 900...903, 905...1000  :
            return "Thunderstorms"
            
        case 903 :
            return "Snow"
            
        case 904 :
            return "Sunny"
            
        default :
            return "dunno"
        }
    }
}

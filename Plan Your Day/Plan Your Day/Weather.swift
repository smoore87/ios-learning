//
//  Weather.swift
//  Plan Your Day
//
//  Created by Sandra Moore on 5/29/19.
//  Copyright © 2019 Sandra Moore. All rights reserved.
//

import UIKit

class Weather {
    var id = Int()
    var description = String()
    var currentTemp = Double()
    var minTemp = Double()
    var maxTemp = Double()
    
    init(id : Int, description : String, currentTemp: Double, minTemp : Double, maxTemp : Double) {
        self.id = id
        self.description = description
        self.currentTemp = currentTemp
        self.minTemp = minTemp
        self.maxTemp = maxTemp
    }
    
    func getId() -> Int {
        return self.id
    }
    
    func setId(id : Int) {
        self.id = id
    }
    
    func getDescription() -> String {
        return self.description
    }
    
    func setDescription(description : String) {
        self.description = description
    }
    
    func getMinTemp() -> Double {
        return self.minTemp
    }
    
    func setMinTemp(minTemp : Double) {
        self.minTemp = minTemp
    }
    
    func getMaxTemp() -> Double {
        return self.maxTemp
    }
    
    func setMaxTemp(maxTemp : Double) {
        self.maxTemp = maxTemp
    }
    
    func getCurrentTemp() -> Double {
        return self.currentTemp
    }
    
    func setCurrentTemp(currentTemp : Double) {
        self.currentTemp = currentTemp
    }
    
}

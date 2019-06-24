//
//  ModelController.swift
//  Plan Your Day
//
//  Created by Sandra Moore on 6/24/19.
//  Copyright © 2019 Sandra Moore. All rights reserved.
//

class ModelController {
    var weather = Weather()
    var toDoList : [ToDoItem] = []
    var timeZone = String()
    var zipCode = String()
    
    init() {
        weather = Weather()
        toDoList = []
        timeZone = "CST"
        zipCode = ""
    }
}

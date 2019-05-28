//
//  File.swift
//  Plan Your Day
//
//  Created by Sandra Moore on 5/28/19.
//  Copyright © 2019 Sandra Moore. All rights reserved.
//

import UIKit

class ToDoItem {
    var dueDate : Date
    var text : String
    
    init(dueDate: Date, text: String){
        self.dueDate = dueDate
        self.text = text
    }
    
    func getDueDate() -> Date {
        return self.dueDate
    }
    
    func setDueDate(dueDate : Date){
        self.dueDate = dueDate
    }
    
    func getText() -> String {
        return self.text
    }
    
    func setText(text : String) {
        self.text = text
    }
}

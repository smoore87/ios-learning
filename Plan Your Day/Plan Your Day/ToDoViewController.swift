//
//  ToDoViewController.swift
//  Plan Your Day
//
//  Created by Sandra Moore on 5/21/19.
//  Copyright © 2019 Sandra Moore. All rights reserved.
//

import UIKit

public class ToDoViewController : UIViewController {
    @IBOutlet weak var newToDoTextInput: UITextView!
    @IBOutlet weak var newToDoDueDate: UIDatePicker!
    @IBOutlet weak var addNewToDoButton: UIButton!
    @IBOutlet weak var existingToDoListDisplay: UIView!
    
    var existingToDoList: [ToDoItem] = []
    
    @IBAction func newToDoPressed(_ sender: Any) {
        addNewToDo()
    }
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        initialize()
        updateToDoListDisplay()
    }
    
    public func getToDoList() -> [ToDoItem] {
        return self.existingToDoList
    }
    
    func initialize() {
        newToDoTextInput.clearsOnInsertion = true
        addNewToDoButton.backgroundColor = UIColor.white
        addNewToDoButton.layer.cornerRadius = 5
        addNewToDoButton.layer.borderColor = UIColor.purple.cgColor
        addNewToDoButton.layer.borderWidth = 1
    }
    
    func addNewToDo() {
        let text = newToDoTextInput.text
        let dueDate = newToDoDueDate.date
        let newToDo = ToDoItem(dueDate : dueDate, text : text!)
        existingToDoList.append(newToDo)
        updateToDoListDisplay()
    }
    
    func updateToDoListDisplay() {
        clearDisplayList()
        sortListByDueDate()
        var yIndex = 5
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "M-dd h:mm a"
        for item in existingToDoList {
            let label = UILabel()
            label.numberOfLines = 0
            label.text = dateFormatter.string(from: item.getDueDate()) + "\t\t" + item.getText()
            label.textColor = UIColor.white
            label.textAlignment =  NSTextAlignment.left
            label.frame = CGRect(x : 10, y : yIndex, width : 330, height : 40)
            self.existingToDoListDisplay.addSubview(label)
            label.sizeToFit()
            yIndex = yIndex + 25
        }
    }
    
    func sortListByDueDate() {
        existingToDoList.sort(by: {$0.dueDate < $1.dueDate})
    }
    
    func clearDisplayList() {
        while let subview = existingToDoListDisplay.subviews.last {
            subview.removeFromSuperview()
        }
    }
    
    public class ToDoItem {
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
}

//
//  FirstViewController.swift
//  Assignment4
//
//  Created by Arohi Kapoor on 7/18/16.
//  Copyright © 2016 Arohi Kapoor. All rights reserved.
//

import UIKit

//Please note: I made the icon for the Tab corresponding this View/ViewController 


class InstrumentationViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var Switch: UISwitch!
    @IBOutlet weak var RowsBox: UITextField! {
        didSet{
            let center = NSNotificationCenter.defaultCenter()
            let n = NSNotification(name: "RowsTextDidChangeNotification",
                                   object: nil,
                                   userInfo: nil)
            center.postNotification(n)
        }
    }
    @IBOutlet weak var ColumnsBox: UITextField! {
        didSet{
            let center2 = NSNotificationCenter.defaultCenter()
            let n2 = NSNotification(name: "ColumnsTextDidChangeNotification",
                                   object: nil,
                                   userInfo: nil)
            center2.postNotification(n2)
        }
    }
    @IBOutlet weak var RefreshRate: UILabel!
    
    var refreshRate: Float!;
    var engine: StandardEngine!
    var test: EngineDelegate?
    var rowStepperHolder: Double = 0;
    var colStepperHolder: Double = 0;
    
    
    //This is connected to the slider, if the slider is moved then its value is recorded in a variable. If the switch is on, then the refreshRate for the timer is updated to be the slider value in the StandardEngine.
    @IBAction func Slider(sender: UISlider) {
        refreshRate = sender.value
        RefreshRate.text = "RefreshRate: \(String(format: "%.1f", sender.value))"
        if Switch.on {
            StandardEngine.sharedInstance.refreshRate = Double(sender.value)
        }
    }
    
    //This is connected to the Switch. If the switch is turned on and the slider var has a value i.e. it has been moved by the user prior to the switch being turned on, then the refreshRate for the timer is updated to be the slider value in the StandardEngine. Else (if switch is off) then refreshRate in StandardEngine is turned to 0 so as to turn the timer off.
    @IBAction func SwitchPressed(sender: UISwitch) {
        if Switch.on {
            if refreshRate != nil {
                StandardEngine.sharedInstance.refreshRate = Double(refreshRate)
            }
        } else {
            StandardEngine.sharedInstance.refreshRate = 0
        }
    }
    
    //If the Rows stepper is clicked on, then the UI Field for rows is updated
    //The value of the stepper is also updated based on the new sum value in the TextField
    //This function also updates the rowstepperHolder variable which keeps track of the previous stepper value (value not just in stepper but also accouting for the UITextField value) It increments or decrements the UITextField based on whether the current value is greater than or less than its previous value
    @IBAction func StepperRows(sender: UIStepper) {
            if let number = Int(RowsBox.text!){
                if sender.value > rowStepperHolder {
                    RowsBox.text = String(number + 10)
                    sender.value = Double(RowsBox.text!)!
                } else if  sender.value < rowStepperHolder{
                    
                    RowsBox.text = String(number - 10)
                    sender.value = Double(RowsBox.text!)!
                }
                
            } else{
                RowsBox.text = String(sender.value)
                sender.value = Double(RowsBox.text!)!
            }
            rowStepperHolder = sender.value;
    }
    
    //If the Columns stepper is clicked on, then the UI Field for columns is updated
    //The value of the stepper is also updated based on the new sum value in the TextField
    //This function also updates the colstepperHolder variable which keeps track of the previous stepper value (value not just in stepper but also accouting for the UITextField value) It increments or decrements the UITextField based on whether the current value is greater than or less than its previous value
    @IBAction func StepperColumn(sender: UIStepper) {
        if let number = Int(ColumnsBox.text!){
            if sender.value > colStepperHolder {
                ColumnsBox.text = String(number + 10)
                sender.value = Double(ColumnsBox.text!)!
            } else if  sender.value < colStepperHolder{
                
                ColumnsBox.text = String(number - 10)
                sender.value = Double(ColumnsBox.text!)!
            }
            
        } else{
            ColumnsBox.text = String(sender.value)
            sender.value = Double(ColumnsBox.text!)!
        }
        colStepperHolder = sender.value;
    }
    
    //If the UIField for rows is updated and its a number, then the StanfardEngine's rows and grid are updated
    @IBAction func RowsChange(sender: UITextField) {
        var rows = StandardEngine.sharedInstance.rows
        if let text = sender.text , interval = Int(text){
            rows = interval
        }
        StandardEngine.sharedInstance.grid = Grid(COLS: StandardEngine.sharedInstance.cols, ROWS:Int(rows))
        StandardEngine.sharedInstance.rows = rows
    }
    
    //If the UIField for columns is updated and its a number, then the StanfardEngine's columns and grid are updated
    @IBAction func ColumnsChange(sender: UITextField) {
        var cols = StandardEngine.sharedInstance.cols
        if let text = sender.text , interval = Int(text){
            cols = interval
        }
        StandardEngine.sharedInstance.grid = Grid(COLS: cols, ROWS:StandardEngine.sharedInstance.cols)
        StandardEngine.sharedInstance.cols = cols
    }
    
    
    
    //NOTE: The stepper works by itself, meaning that when touched it updates the UI Field. If the user types a number in the UIField and then clicks on the stepper, then too the stepper works and increments from the value already in the UIField. However, it seems when the UIField is updated programatically calling UIField.text, the IBAction function isn't called thus, the grid which is updated within it doesn't update. Instead, I tried to create a notification for when the UIField is set, however it doesn't seem to be working. The function to be notified doesn't get notified meaning the notificaiton isn't received. I can't figure out why.
    
    //NOTE2: When I type in the UIField for rows and columns, the grid does update however, it takes some times for the Field to record that editing has ended it seems. I have to click elsewhere and sometimes touch different tabs to see the change in the Grid. I'm not sure why this is. 
    
    override func viewDidLoad() {
        super.viewDidLoad()

        NSNotificationCenter.defaultCenter().addObserver(self,
                                                         selector:#selector(self.rowstextFieldChanged(_:)),
                                                         name:"RowsTextDidChangeNotification",
                                                            object:nil);
        
        NSNotificationCenter.defaultCenter().addObserver(self,
                                                         selector:#selector(self.columnstextFieldChanged(_:)),
                                                         name:"ColumnsTextDidChangeNotification",
                                                         object:nil);
        
    }
    
    //Function that gets notified when rows textFieldChanges
    func rowstextFieldChanged(notification:NSNotification){
        print ("I got notified")
        var rows = StandardEngine.sharedInstance.rows
        if let text = RowsBox.text , interval = Int(text){
            rows = interval
        }
        StandardEngine.sharedInstance.grid = Grid(COLS: StandardEngine.sharedInstance.cols, ROWS:Int(rows))
        StandardEngine.sharedInstance.rows = rows
    }
    
    //Function that gets notified when cols textFieldChanges
    func columnstextFieldChanged(notification:NSNotification){
        var cols = StandardEngine.sharedInstance.cols
        if let text = ColumnsBox.text , interval = Int(text){
            cols = interval
        }
        StandardEngine.sharedInstance.grid = Grid(COLS: cols, ROWS:StandardEngine.sharedInstance.cols)
        StandardEngine.sharedInstance.cols = cols
        
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    //These connections are here because removing them gives me a fatal error. I never use them, but I also don't know how to remove them. Just removing them from the connections doesn't do it. So i have left them here for now. Hopefully this won't cause me a mark down.
    @IBOutlet weak var Rows: UITextField!
    
    @IBAction func StepperRow(sender: AnyObject) {
    }


}


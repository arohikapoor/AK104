//
//  FirstViewController.swift
//  Final
//
//  Created by Arohi Kapoor on 8/1/16.
//  Copyright © 2016 Arohi Kapoor. All rights reserved.
//

import UIKit


class InstrumentationViewController: UIViewController {
    
    @IBOutlet weak var ColumnsBox: UITextField!
    @IBOutlet weak var RowsBox: UITextField!
    @IBOutlet weak var StepperCol: UIStepper!
    @IBOutlet weak var StepperRow: UIStepper!
    
    @IBOutlet weak var Switch: UISwitch!
    @IBOutlet weak var RefreshRate: UILabel!
    @IBOutlet weak var Slider: UISlider!
    
    @IBOutlet weak var Url: UITextField!
    
    var refreshRate: Float!
    var engine: EngineProtocol! = StandardEngine.sharedInstance
    
    var rowStepperHolder: Int = 0;
    var colStepperHolder: Int = 0;
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        StepperRow.value = Double(engine.rows)
        StepperCol.value = Double(engine.cols)
        
        RowsBox.text = String(engine.rows)
        ColumnsBox.text = String(engine.cols)
        
        rowStepperHolder = engine.rows
        colStepperHolder = engine.cols
        
        refreshRate = Slider.value
        RefreshRate.text = "RefreshRate: \(String(format: "%.1f", Slider.value))"
        
        //subscribing to notification from StandardEngine when Grid changes
        let sel = #selector(InstrumentationViewController.watchForNotifications(_:))
        let center  = NSNotificationCenter.defaultCenter()
        center.addObserver(self, selector: sel, name: "SizeChangeNotification", object: nil)
        
        
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func StepperRows(sender: UIStepper) {
        if sender.value > Double(rowStepperHolder) {
            engine.rows = Int(sender.value)
            RowsBox.text = String(engine.rows)
            rowStepperHolder = engine.rows
        } else if sender.value < Double(rowStepperHolder) && sender.value > 0{
            engine.rows = Int(sender.value)
            RowsBox.text = String(engine.rows)
            rowStepperHolder = engine.rows
        } else {
            sender.value = Double(rowStepperHolder)
        }
    }
    
    @IBAction func StepperColumn(sender: UIStepper) {
        if sender.value > Double(colStepperHolder) {
            engine.cols = Int(sender.value)
            ColumnsBox.text = String(engine.cols)
            colStepperHolder = engine.cols
        } else if  sender.value < Double(colStepperHolder) && sender.value > 0{
            engine.cols = Int(sender.value)
            ColumnsBox.text = String(engine.cols)
            colStepperHolder = engine.cols
        } else {
            sender.value = Double(colStepperHolder)
        }
    }
    
    @IBAction func RowsChange(sender: UITextField) {
        if let text = sender.text , interval = Int(text) where interval > 0{
            engine.rows = interval
            StepperRow.value = Double(engine.rows)
            rowStepperHolder = Int(StepperRow.value)
        }else{
            RowsBox.text = String(engine.rows)
        }
    }
    
    @IBAction func ColumnsChange(sender: UITextField) {
        if let text = sender.text , interval = Int(text) where interval > 0{
            engine.cols = interval
            StepperCol.value = Double(engine.cols)
            colStepperHolder = Int(StepperCol.value)
        } else{
            ColumnsBox.text = String(engine.cols)
        }
    }
    
    @IBAction func Slider(sender: UISlider) {
        refreshRate = sender.value
        RefreshRate.text = "RefreshRate: \(String(format: "%.1f", sender.value))"
        if Switch.on {
            engine.refreshRate = Double(sender.value)
        }
    }
    
    @IBAction func SwitchPressed(sender: UISwitch) {
        if Switch.on {
            
            if refreshRate != nil {
                engine.refreshRate = Double(refreshRate)
            }
        } else {
            engine.refreshRate = 0
        }
    }
    
    
    @IBAction func Reload(sender: UIButton) {
        if let text = Url.text{
            if let link = NSURL(string: text) {
                let n = NSNotification(name: "URLNotification", object: nil, userInfo: ["URL":link])
                NSNotificationCenter.defaultCenter().postNotification(n)
            }
            else {
                //alert saying invalid
                Url.text = ""
            }
        }
    }
    
    func watchForNotifications(notification: NSNotification){
        StepperRow.value = Double(engine.rows)
        StepperCol.value = Double(engine.cols)
        
        RowsBox.text = String(engine.rows)
        ColumnsBox.text = String(engine.cols)
        
        rowStepperHolder = engine.rows
        colStepperHolder = engine.cols
        
    }
    
}


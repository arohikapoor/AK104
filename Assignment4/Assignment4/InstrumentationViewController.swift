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
    
    @IBOutlet weak var StepperRow: UIStepper!
    @IBOutlet weak var StepperCol: UIStepper!
    
    @IBOutlet weak var RowsBox: UITextField!
    @IBOutlet weak var ColumnsBox: UITextField!
    
    @IBOutlet weak var Switch: UISwitch!
    @IBOutlet weak var RefreshRate: UILabel!
    
    var refreshRate: Float!;
    
    var engine: EngineProtocol! = StandardEngine.sharedInstance
    
    var rowStepperHolder: Int = 0;
    var colStepperHolder: Int = 0;
    
    
    @IBAction func StepperRows(sender: UIStepper) {
        if sender.value > Double(rowStepperHolder) {
            engine.rows += 10
            RowsBox.text = String(engine.rows)
            rowStepperHolder = engine.rows
        } else if sender.value < Double(rowStepperHolder) && sender.value > 0{
                engine.rows -= 10
                RowsBox.text = String(engine.rows)
                rowStepperHolder = engine.rows
            
        } else {
            sender.value = Double(rowStepperHolder)
        }
    }
    
    @IBAction func StepperColumn(sender: UIStepper) {
            if sender.value > Double(colStepperHolder) {
                engine.cols += 10
                ColumnsBox.text = String(engine.cols)
                colStepperHolder = engine.cols
            } else if  sender.value < Double(colStepperHolder) && sender.value > 0{
                engine.cols -= 10
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        StepperRow.value = Double(engine.rows)
        StepperCol.value = Double(engine.cols)
        
        RowsBox.text = String(engine.rows)
        ColumnsBox.text = String(engine.cols)
        
        rowStepperHolder = engine.rows
        colStepperHolder = engine.cols
        
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

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
}


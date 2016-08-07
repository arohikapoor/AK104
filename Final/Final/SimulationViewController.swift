//
//  SimulationViewController.swift
//  Final
//
//  Created by Arohi Kapoor on 8/4/16.
//  Copyright © 2016 Arohi Kapoor. All rights reserved.
//

import UIKit

class SimulationViewController: UIViewController, EngineDelegate {
    
    @IBOutlet weak var MyGrid: GridView!
    
    var engine: EngineProtocol!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("I loaded")
        engine = StandardEngine.sharedInstance
        engine.delegate = self
        print(MyGrid.points)
        
        //This exists to update the simulation grid once viewLoad so it can account for changes made to grid before the tab was clicked. I'm not entirely sure why it needs to be called twice - but that's the only way it allows the Simulation tab to take the configuration points from Instrumentation without tapping on the tab first
        self.engineDidUpdate(StandardEngine.sharedInstance.grid)
        self.engineDidUpdate(StandardEngine.sharedInstance.grid)
    }
    
    //MARK: Standard Engine Functionality
    @IBAction func Step(sender: AnyObject) {
        engine.step()
    }
    @IBAction func Tapped(sender: AnyObject) {
        let a = sender.locationInView(MyGrid)
        StandardEngine.sharedInstance.tapped(a, cellWidth: MyGrid.cellWidth, cellHeight: MyGrid.cellHeight)
    }
    func engineDidUpdate(withGrid: GridProtocol){
        print("I was called")
        MyGrid.update(withGrid)
    }
    
    @IBAction func Reset(sender: AnyObject) {
        StandardEngine.sharedInstance.reset()
    }
    
    @IBAction func Save(sender: AnyObject) {
        
        //Converts points an name in NS objects so that it can be sent back in Notification dictionary
        let array = NSMutableArray()
        for i in MyGrid.points {
            array.addObject([i.Col, i.Row])
        }
        
        //Alert for user input on Name
        let alert = UIAlertController(title: "Name",
                                      message:"Please name this generation",
                                      preferredStyle: .Alert)
        alert.addTextFieldWithConfigurationHandler { (textField) -> Void in
        }
        
        var name: String = ""
        alert.addAction(UIAlertAction(title: "OK", style: .Default) { _ in
            
            if let textF = alert.textFields {
                if let textInF = textF[0].text where !textInF.isEmpty{
                    name = textInF
                    let nameArray = NSMutableArray()
                    nameArray.addObject(name)
                    //Notification with name and points
                    let n = NSNotification(name: "SaveNotification", object: nil, userInfo: ["points":array, "name": nameArray])
                    NSNotificationCenter.defaultCenter().postNotification(n)
                }
            }
            
            else {
                name = "no name"
                let nameArray = NSMutableArray()
                nameArray.addObject(name)
                //Notification with name and points
                let n = NSNotification(name: "SaveNotification", object: nil, userInfo: ["points":array, "name": nameArray])
                NSNotificationCenter.defaultCenter().postNotification(n)
            }})
        alert.addAction(UIAlertAction(title: "Cancel", style: .Default) { _ in })
        self.presentViewController(alert, animated: true){}
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
}

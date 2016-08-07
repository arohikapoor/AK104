//
//  SecondViewController.swift
//  Final
//
//  Created by Arohi Kapoor on 8/1/16.
//  Copyright © 2016 Arohi Kapoor. All rights reserved.
//

import UIKit

class StatisticsViewController: UIViewController {

    @IBOutlet weak var Empty: UITextView!
    @IBOutlet weak var Died: UITextView!
    @IBOutlet weak var Born: UITextView!
    @IBOutlet weak var Alive: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        Empty.text = String(StandardEngine.sharedInstance.grid.states[.Empty]!)
        Born.text = String(StandardEngine.sharedInstance.grid.states[.Born]!)
        Alive.text = String(StandardEngine.sharedInstance.grid.states[.Alive]!)
        Died.text = String(StandardEngine.sharedInstance.grid.states[.Died]!)
        
        //subscribing to notification from StandardEngine when Grid changes
        let sel = #selector(StatisticsViewController.watchForNotifications(_:))
        let center  = NSNotificationCenter.defaultCenter()
        center.addObserver(self, selector: sel, name: "GridChangeNotification", object: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func watchForNotifications(notification: NSNotification){
        Empty.text = String(StandardEngine.sharedInstance.grid.states[.Empty]!)
        Born.text = String(StandardEngine.sharedInstance.grid.states[.Born]!)
        Alive.text = String(StandardEngine.sharedInstance.grid.states[.Alive]!)
        Died.text = String(StandardEngine.sharedInstance.grid.states[.Died]!)
        
    }


}


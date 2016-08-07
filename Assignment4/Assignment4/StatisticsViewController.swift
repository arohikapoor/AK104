//
//  StatisticsViewController.swift
//  Assignment4
//
//  Created by Arohi Kapoor on 7/18/16.
//  Copyright © 2016 Arohi Kapoor. All rights reserved.
//

import UIKit

//Please note: I made the icon for the Tab corresponding this View/ViewController 

class StatisticsViewController: UIViewController {
    
    @IBOutlet weak var Died: UILabel!
    @IBOutlet weak var Empty: UILabel!
    @IBOutlet weak var Born: UILabel!
    @IBOutlet weak var Living: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //subscribing to notification from StandardEngine when Grid changes
        let sel = #selector(StatisticsViewController.watchForNotifications(_:))
        let center  = NSNotificationCenter.defaultCenter()
        center.addObserver(self, selector: sel, name: "GridChangeNotification", object: nil)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //When Grid Changes, the Grid's cellState values are counted and labels are updated
    func watchForNotifications(notification:NSNotification) {
//        var DiedCount: Int = 0
//        var LivingCount: Int = 0
//        var BornCount: Int = 0
//        var EmptyCount: Int = 0
//        
//        let DiedCount2: Int = StandardEngine.sharedInstance.grid.died
//        let LivingCount2: Int = StandardEngine.sharedInstance.grid.alive
//        let BornCount2: Int = StandardEngine.sharedInstance.grid.born
//        let EmptyCount2: Int = StandardEngine.sharedInstance.grid.empty
//        
//        for i in 0..<StandardEngine.sharedInstance.cols {
//            for j in 0..<StandardEngine.sharedInstance.rows {
//                if StandardEngine.sharedInstance.grid[i,j] == .Born {
//                    BornCount += 1
//                } else if StandardEngine.sharedInstance.grid[i,j] == .Living {
//                    LivingCount += 1
//                    
//                } else if StandardEngine.sharedInstance.grid[i,j] == .Died {
//                    DiedCount += 1
//                } else if StandardEngine.sharedInstance.grid[i,j] == .Empty {
//                    EmptyCount += 1
//                }
//            }
//        }
//        
//        
//        
//
//        Died.text = String("Died: old: \(DiedCount) or new: \(DiedCount2)")
//        Living.text = String("Alive: old: \(LivingCount) or new: \(LivingCount2)")
//        Empty.text = String("Empty: old: \(EmptyCount) or new: \(EmptyCount2)")
//        Born.text = String("Born: old: \(BornCount) or new: \(BornCount2)")
    }

}

//
//  SecondViewController.swift
//  Assignment4
//
//  Created by Arohi Kapoor on 7/18/16.
//  Copyright © 2016 Arohi Kapoor. All rights reserved.
//

import UIKit

class SimulationViewController: UIViewController, EngineDelegate {
    
    
    
    //Handles user touch on grid
    @IBAction func Tapped(sender: UITapGestureRecognizer) {
        
            let a = sender.locationInView(MyGrid)
        
            StandardEngine.sharedInstance.tapped(a, cellWidth: MyGrid.cellWidth, cellHeight: MyGrid.cellHeight)
    }
    
    @IBAction func StepButton(sender: AnyObject) {
        engine.step()
    }
    
    @IBOutlet weak var MyGrid: GridView!
  
    
    var engine: EngineProtocol!
    override func viewDidLoad() {
        super.viewDidLoad()
        engine = StandardEngine.sharedInstance
        engine.delegate = self        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func engineDidUpdate(withGrid: GridProtocol){
        MyGrid.update(withGrid)
    }
    
}


//
//  SecondViewController.swift
//  Assignment4
//
//  Created by Arohi Kapoor on 7/18/16.
//  Copyright © 2016 Arohi Kapoor. All rights reserved.
//

import UIKit

//Please note: I made the icon for the Tab corresponding this View/ViewController 

class SimulationViewController: UIViewController, EngineDelegate {
    
    
    
    //Handles user touch on grid
    @IBAction func Tapped(sender: UITapGestureRecognizer) {
        
            let a = sender.locationInView(MyGrid)
        
            //Calculating corresponding rect on grid:
            var xInGrid: Int = 0
            var yInGrid: Int = 0
            for i in 0..<engine.grid.cols{
                if (a.x > CGFloat (i) * MyGrid.cellWidth) && (a.x < CGFloat (i + 1) * MyGrid.cellWidth) {
                        xInGrid = i
                        break
                    }
            }
        
            for i in 0..<engine.grid.rows{
            if (a.y > CGFloat (i) * MyGrid.cellHeight) && (a.y < CGFloat (i + 1) * MyGrid.cellHeight) {
                    yInGrid = i
                    break
                }
            }
        
            //creating a temporaryGrid to hold changed Grid
            var tempGrid: GridProtocol = Grid(COLS: engine.grid.cols,ROWS: engine.grid.rows)
        
            for i in 0..<engine.grid.cols{
                for j in 0..<engine.grid.rows{
                    tempGrid[i,j] = StandardEngine.sharedInstance.grid[i,j]
                }
            }
        
            tempGrid.grid[xInGrid][yInGrid] = tempGrid.grid[xInGrid][yInGrid].toggle(tempGrid.grid[xInGrid][yInGrid])
        
            //updating Grid, which then calls the delegate method which updates the visual Grid
            StandardEngine.sharedInstance.grid = tempGrid
    }
    
    
    //Handles user click on step button by generating a new grid and then calling the delegate method which updates the visual Grid accordingly
    @IBAction func StepButton(sender: AnyObject) {
        engine.grid = engine.step()
    }
    
    @IBOutlet weak var MyGrid: GridView!
  
    
    var engine: StandardEngine!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Singleton:
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


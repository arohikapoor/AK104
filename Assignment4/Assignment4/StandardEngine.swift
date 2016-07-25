//
//  StandardEngine.swift
//  Assignment4
//
//  Created by Arohi Kapoor on 7/18/16.
//  Copyright © 2016 Arohi Kapoor. All rights reserved.
//

import Foundation
import UIKit

class StandardEngine: EngineProtocol{
    
    private static var _sharedInstance = StandardEngine(COLS: 10, ROWS: 10)
    static var sharedInstance: StandardEngine {
        get {
            return _sharedInstance
        }
    }
    
    var delegate: EngineDelegate?
    var rows: Int;
    var cols: Int;
    
    var grid: GridProtocol {
        didSet{
            print ("Grid: I got changed")
            if let delegate = delegate {
                print ("Delegate: I got delegated")
                delegate.engineDidUpdate(self.grid)
                let center = NSNotificationCenter.defaultCenter()
                let n = NSNotification(name: "GridChangeNotification",
                                       object: nil,
                                       userInfo: nil)
                center.postNotification(n)            }
        }
    }
    
    var refreshTimer:NSTimer?
    var refreshRate: Double {
        didSet{
            if refreshRate != 0 {
                        if let timer = refreshTimer { timer.invalidate() }
                        let sel = #selector(StandardEngine.timerDidFire(_:))
                        refreshTimer = NSTimer.scheduledTimerWithTimeInterval(refreshRate,
                            target: self,
                            selector: sel,
                            userInfo: nil,
                            repeats: true)
                    }
                    else if let refreshTimer = refreshTimer {
                        refreshTimer.invalidate()
                        self.refreshTimer = nil
            }
        }
    }
    
    required init(COLS: Int, ROWS: Int) {
        self.rows = ROWS;
        self.cols = COLS;
        self.grid = Grid(COLS: COLS, ROWS: ROWS);
        refreshRate = 0;
    }
    
    //MY STEP METHOD
    //This method is divided into two parts: 1 for handling the case where the Grid is empty and the first generation of cells needs to be created and 2 for handling the case where the Grid is non-empty
    func step() -> GridProtocol {
        
        var tempGrid: GridProtocol = Grid(COLS: cols, ROWS: rows)
        
        //Checking if Grid is empty
        var empty = true;
        for i in 0..<cols{
            for j in 0..<rows{
                if self.grid[i,j] != .Empty {
                    empty = false
                    break
                }
            }
        }
        
        //If the grid in passed in gridProtocol is empty, then 1/3rd of tempGrid's cells will be given a Living cellstate
        if empty {
            
            for i in 0..<cols{
                for j in 0..<rows{
                    if arc4random_uniform(3) == 1{
                        tempGrid[i,j] = .Born
                    }
                }
            }
            
        }
        
        //Otherwise, the next generation of grid will be assigned to tempGrid using the game's logic
        else {
        
            var alive: Int = 0
            
            //For each cell in passed in Grid:
            for i in 0..<cols{
                for j in 0..<rows{
                    
                    let neighbour = self.grid.neighbors((col:i, row:j))
                    
                    //I check to see how many of the cell's neighbors are alive
                    for n in neighbour{
                        if (self.grid[n.col, n.row] == .Living ) || (self.grid[n.col, n.row] == .Born ) {
                            alive += 1
                        }
                    }
                    
                    //current Cell's cellState
                    let current:CellState = self.grid[i,j]
                    
                    
                    //if the Current Cell is alive (born/living) and less than 2 of its neighbors are alive, then it dies in the next generation. If current state is .Died then it will be Empty in the next generation. If the current state is .Empty then it continues to be so.
                    if alive < 2 {
                        if current == .Living || current == .Born{
                             tempGrid[i,j] = .Died
                        } else if current == .Died{
                            tempGrid[i,j] = .Empty
                        }
                            
                    }
                        
                    else if alive == 2 || alive == 3 {
                        //if the Current Cell is newly .Born and 2 or 3 of its neighbors are alive, then it become .Living in the next generation
                        if current == .Born {
                            tempGrid[i,j] = .Living
                        }
                        //if the Current Cell is newly .Died  or .Empty and 2 or 3 of its neighbors are alive, then it becomes .Born in the next generation
                        else if current == .Died || current == .Empty {
                            tempGrid[i,j] = .Born
                        }
                        //No else for .Living because that will continue to be .Living
                        
                    }
                        
                    //if the Current Cell is alive (born/living) and more than 3 of its neighbors are alive, then it dies in the next generation. If current state is .Died then it will be Empty in the next generation. If the current state is .Empty then it continues to be so.
                    else if alive > 3  {
                        if current == .Died{
                            tempGrid[i,j] = .Empty
                        } else if current == .Living || current == .Born{
                            tempGrid[i,j] = .Died
                        }
                    }
                        
                   alive = 0

                }
            }
        }

        return tempGrid
    }
    
    
    //creates new generation of grid and updates the gridProtocol, which then updates the visual grid via the delegate method
    @objc func timerDidFire(timer:NSTimer) {
        self.grid = self.step()
    }


}


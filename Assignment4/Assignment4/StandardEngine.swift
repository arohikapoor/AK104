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
    
    weak var delegate: EngineDelegate?
    
    var rows: Int {
        didSet{
            print("I was set under rows")
            self.grid = Grid(COLS: self.cols, ROWS: self.rows)
            if let delegate = delegate { delegate.engineDidUpdate(self.grid)
            print("I was set after rows delegate")}
                let n = NSNotification(name: "GridChangeNotification", object: nil, userInfo: nil)
                NSNotificationCenter.defaultCenter().postNotification(n) } }
    
    var cols: Int{
        didSet{
            print("I was set under cols")
            self.grid = Grid(COLS: self.cols, ROWS: self.rows)
            if let delegate = delegate { delegate.engineDidUpdate(self.grid)
            print("I was set after cols delegate")
            }
                let n = NSNotification(name: "GridChangeNotification", object: nil, userInfo: nil)
                NSNotificationCenter.defaultCenter().postNotification(n) } }
    
    
    private (set) var grid: GridProtocol
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
                            repeats: true) }
                    else if let refreshTimer = refreshTimer {
                        refreshTimer.invalidate()
                        self.refreshTimer = nil } } }
    
    required init(COLS: Int, ROWS: Int) {
        self.rows = ROWS;
        self.cols = COLS;
        self.grid = Grid(COLS: COLS, ROWS: ROWS);
        refreshRate = 0; }
    
    
    func step() -> GridProtocol {
        var tempGrid: GridProtocol = Grid(COLS: cols, ROWS: rows)
        
        //Simplify this part of the code somehow
        var empty = true;
        for i in 0..<cols{ for j in 0..<rows{ if self.grid[i,j] != .Empty {
                    empty = false
                    break   } } }
        if empty { return self.grid }
            
        else {
            var alive: Int = 0
            for i in 0..<cols{ for j in 0..<rows{
                    
                    let neighbour = self.grid.neighbors((col:i, row:j))
                    for n in neighbour{ if (self.grid[n.col, n.row] == .Living ) || (self.grid[n.col, n.row] == .Born ) {
                            alive += 1 } }
                    
                    let current:CellState = self.grid[i,j]
                    //have an isLiving in cellState enum
                    if current == .Living || current == .Born{
                        if alive < 2 { tempGrid[i,j] = .Died }
                        else if alive == 2 || alive == 3 { tempGrid[i,j] = .Living }
                        else if alive > 3 { tempGrid[i,j] = .Died } }
                    if current == .Died || current == .Empty {
                        if alive == 3{ tempGrid[i,j] = .Born }
                        else { tempGrid[i,j] = .Empty } }

                    alive = 0  } } }
        
        self.grid = tempGrid
        if let delegate = delegate { delegate.engineDidUpdate(self.grid)
            let n = NSNotification(name: "GridChangeNotification", object: nil, userInfo: nil)
            NSNotificationCenter.defaultCenter().postNotification(n) }
        return tempGrid
    }
    
    func tapped(Point: CGPoint, cellWidth: CGFloat, cellHeight: CGFloat)-> GridProtocol{
        //SIMPLIFY THIS
        
        //Calculating corresponding rect on grid:
        var xInGrid: Int = 0
        var yInGrid: Int = 0
        for i in 0..<self.cols{
            if (Point.x > CGFloat (i) * cellWidth) && (Point.x < CGFloat (i + 1) * cellWidth) {
                xInGrid = i
                break
            }
        }
        
        for i in 0..<self.rows{
            if (Point.y > CGFloat (i) * cellHeight) && (Point.y < CGFloat (i + 1) * cellHeight) {
                yInGrid = i
                break
            }
        }
        
        //creating a temporaryGrid to hold changed Grid
        var tempGrid: GridProtocol = Grid(COLS: self.cols,ROWS: self.rows)
        
        for i in 0..<self.cols{
            for j in 0..<self.rows{
                tempGrid[i,j] = StandardEngine.sharedInstance.grid[i,j]
            }
        }
        
        tempGrid[xInGrid,yInGrid] = tempGrid[xInGrid,yInGrid].toggle(tempGrid[xInGrid,yInGrid])
        self.grid = tempGrid
        if let delegate = delegate { delegate.engineDidUpdate(self.grid) }
            let n = NSNotification(name: "GridChangeNotification", object: nil, userInfo: nil)
            NSNotificationCenter.defaultCenter().postNotification(n)
        return self.grid
    }
    
    @objc func timerDidFire(timer:NSTimer) {
        self.grid = self.step()
    }
    
//    func takePoints(points: [(Col:Int,Row:Int)]) -> GridProtocol{
//        var tempGrid: GridProtocol = Grid(cols: self.cols,rows: self.rows)
//        for i in points{
//            tempGrid[i.Col, i.Row] = .Alive
//        }
//        
//        self.grid = tempGrid
//        if let delegate = delegate { delegate.engineDidUpdate(self.grid) }
//        let n = NSNotification(name: "GridChangeNotification", object: nil, userInfo: nil)
//        NSNotificationCenter.defaultCenter().postNotification(n)
//        
//        return self.grid
//    }
    


}


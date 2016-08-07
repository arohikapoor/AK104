//
//  Engine.swift
//  Final
//
//  Created by Arohi Kapoor on 8/4/16.
//  Copyright © 2016 Arohi Kapoor. All rights reserved.
//

import Foundation
import UIKit

class StandardEngine: EngineProtocol{
    private static var _sharedInstance = StandardEngine(COLS: 10, ROWS: 10)
    static var sharedInstance: StandardEngine { get { return _sharedInstance } }
    
    weak var delegate: EngineDelegate?
    
    var rows: Int { didSet{
        print("I was set rows")
        self.grid = Grid(COLS: self.cols, ROWS: self.rows)
        self.notify()
        self.notifyAboutSize() } }
    
    var cols: Int{ didSet{
        print("I was set cols")
        self.grid = Grid(COLS: self.cols, ROWS: self.rows)
        self.notify()
        self.notifyAboutSize() } }
    
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
    
        var empty = true;
        for i in 0..<cols{ for j in 0..<rows{ if self.grid[i,j] != .Empty {
            empty = false
            break   } } }
        if empty { return self.grid }
            
        else {
            var alive: Int = 0
            for i in 0..<cols{ for j in 0..<rows{
                let neighbour = self.grid.neighbors((col:i, row:j))
                for n in neighbour{ if (self.grid[n.col, n.row].isLiving()) { alive += 1 } }
                
                let current:CellState = self.grid[i,j]
                if current.isLiving(){
                    if alive < 2 || alive > 3 { tempGrid[i,j] = .Died }
                    else if alive == 2 || alive == 3 { tempGrid[i,j] = .Alive }
                }
                if !current.isLiving(){
                    if alive == 3{ tempGrid[i,j] = .Born }
                    else { tempGrid[i,j] = .Empty } }
                alive = 0  } } }
        
        self.grid = tempGrid
        self.notify()
        return tempGrid
    }
    
    func tapped(Point: CGPoint, cellWidth: CGFloat, cellHeight: CGFloat)-> GridProtocol{
        
        //Grid corresponding to touchPoints
        var xInGrid: Int = 0
        var yInGrid: Int = 0
        for i in 0..<self.cols{
            if (Point.x > CGFloat (i) * cellWidth) && (Point.x < CGFloat (i + 1) * cellWidth) {
                xInGrid = i
                break } }
        for i in 0..<self.rows{
            if (Point.y > CGFloat (i) * cellHeight) && (Point.y < CGFloat (i + 1) * cellHeight) {
                yInGrid = i
                break } }
        
        //TempGrid and Toggle
        var tempGrid: GridProtocol = Grid(COLS: self.cols,ROWS: self.rows)
        for i in 0..<self.cols{ for j in 0..<self.rows{ tempGrid[i,j] = self.grid[i,j] } }
        tempGrid[xInGrid,yInGrid] = tempGrid[xInGrid,yInGrid].toggle(tempGrid[xInGrid,yInGrid])
        
        //Update
        self.grid = tempGrid
        self.notify()
        return self.grid
    }
    
    func takePoints(points: [(Col:Int,Row:Int)]) -> GridProtocol{
        var tempGrid: GridProtocol = Grid(COLS: self.cols,ROWS: self.rows)
        for i in points{ tempGrid[i.Col, i.Row] = .Alive }
        self.grid = tempGrid
        self.notify()
        return self.grid
    }
    
    func reset() {
        for i in 0..<StandardEngine.sharedInstance.cols {
            for j in 0..<StandardEngine.sharedInstance.rows {
                self.grid[i,j] = .Empty } }
        self.notify()
    }
    
    @objc func timerDidFire(timer:NSTimer) {
        self.grid = self.step()
    }
    
    func notify(){
        if let delegate = delegate { delegate.engineDidUpdate(self.grid) }
        let n = NSNotification(name: "GridChangeNotification", object: nil, userInfo: nil)
        NSNotificationCenter.defaultCenter().postNotification(n)
    }
    
    func notifyAboutSize(){
        let n = NSNotification(name: "SizeChangeNotification", object: nil, userInfo: nil)
        NSNotificationCenter.defaultCenter().postNotification(n)
    }
}



class Grid: GridProtocol{
    
    var rows: Int
    var cols: Int
    var grid:[[CellState]]
    var states:[CellState: Int] = [:]
    
    required init(COLS: Int, ROWS: Int) {
        self.rows = ROWS;
        self.cols = COLS;
        self.grid = Array(count: COLS, repeatedValue: Array(count: ROWS, repeatedValue:CellState.Empty))
        self.states[.Empty] = rows*cols
        self.states[.Born] = 0
        self.states[.Alive] = 0
        self.states[.Died] = 0
        
    }
    
    func neighbors(Coordinates: ((col: Int,row: Int))) -> [(col: Int, row: Int)] {
        //I use the modulo method for wrapping.
        let oneRight = (Coordinates.col + 1)%self.cols
        let oneLeft = (Coordinates.col + (self.cols-1))%self.cols
        let oneUp = (Coordinates.row + (self.rows-1))%self.rows
        let oneDown = (Coordinates.row + 1)%self.rows
        let x = Coordinates.col
        let y = Coordinates.row
        return [(oneRight,y),(oneLeft,y),(x,oneUp),(x,oneDown),(oneRight,oneUp),(oneLeft,oneUp),(oneRight,oneDown),(oneLeft,oneDown)]
    }
    
    subscript(cols: Int, rows: Int) -> CellState {
        get {
            let c = cols
            let r = rows
            if r < 0 || r >= self.rows || c < 0 || c >= self.cols { return .Empty }
            return grid[c][r]
        }
        set (newValue) {
            let c = cols
            let r = rows
            if r < 0 || r >= self.rows || c < 0 || c >= self.cols { return }
            states[self.grid[c][r]] = states[self.grid[c][r]]! - 1
            self.grid[c][r] = newValue
            states[self.grid[c][r]] = states[self.grid[c][r]]! + 1
        }
    }
}
   
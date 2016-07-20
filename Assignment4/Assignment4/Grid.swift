//
//  Grid.swift
//  Assignment4
//
//  Created by Arohi Kapoor on 7/18/16.
//  Copyright © 2016 Arohi Kapoor. All rights reserved.
//

import Foundation

class Grid: GridProtocol{
    //Can get a cell's cell state and neighbours from this
    var rows: Int
    var cols: Int
    var grid:[[CellState]]
    
    required init(COLS: Int, ROWS: Int) {
        self.rows = ROWS;
        self.cols = COLS;
        self.grid = Array(count: COLS, repeatedValue: Array(count: ROWS, repeatedValue:CellState.Empty))
    }

    func neighbors(Coordinates: ((col: Int,row: Int))) -> [(col: Int, row: Int)] {
        //I use the modulo method for wrapping. Eg. for the cell (0,0) in a 10 by 10 array, the coordinates for the left neighbour are (oneLeft, 0) = ((0 + 9)% 10, 0) = (9,0). Similarly if you can compute the neighbours for oneRight, oneUP, oneDown and then TopLeft, TopRight, BottomLeft and BottomRight by using a combination of the two.
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
            //if newValue == nil { return }
            let c = cols
            let r = rows
            if r < 0 || r >= self.rows || c < 0 || c >= self.cols { return }
            self.grid[c][r] = newValue
        }
    }
}
//
//  Engine.swift
//  Assignment3
//
//  Created by Arohi Kapoor on 7/12/16.
//  Copyright © 2016 Arohi Kapoor. All rights reserved.
//

import Foundation


//This method is used to compare two 2D-Array of Bools (containing whether a cell is alive or not) and based on the comparison it updates the CellState of the cell (Living, Born, Died, Empty). It returns this updated Grid. I call this in my ViewController to update the colors of the rects in my GridView.
func gridUpdate(before: [[Bool]], after: [[Bool]]) -> [[CellState]]{
    let cols: Int = before.count
    let rows: Int = before[0].count
    
    var grid:[[CellState]] = Array(count: cols, repeatedValue: Array(count: rows, repeatedValue:CellState.Empty))
    
    for i in 0...cols-1{
        for j in 0...rows-1{
            
            
            //I used if statements instead of a switch statement because I find them easier to work with and thus, easier to debug and to avoid a mistake. However, I have left the commented out switch statement below as well in case that was a requirement for grading although I don't think the assignment said so. You emphasized a switch statement in the previous assignment thus, I've put it in here. 
            
            if (before[i][j] == true && after[i][j] == true){
                grid[i][j] = CellState.Living
            }
            
            if (before[i][j] == true && after[i][j] == false){
                grid[i][j] = CellState.Died
                
            }
            
            if (before[i][j] == false && after[i][j] == true){
                grid[i][j] = CellState.Born

            }
            
            if (before[i][j] == false && after[i][j] == false){
                grid[i][j] = CellState.Empty
                
            }
//            let pair = (b: before[i][j], a: after[i][j])
//            
//            switch true{
//                case (pair.b == true && pair.a == true):
//                    grid[i][j] = CellState.Living
//                case (pair.b == true && pair.a == false):
//                    grid[i][j] = CellState.Died
//                case (pair.b == false && pair.a == true):
//                    grid[i][j] = CellState.Born
//                case (pair.b == false && pair.a == false):
//                    grid[i][j] = CellState.Empty
//                default:
//                    break
//            }
        }
    }
    return grid
}




//Computers an Array of Tuples containing the Cell Co-ordinates of a target cell's 8 neighbours. This takes in number of cols and rows in the 2D Array to implement my particular modulo method of computing neighbors
func neighbours(cellCordinates: (col:Int, row: Int),  cols :Int, rows: Int)-> [(col:Int, row: Int)]{
    
    //I use the modulo method for wrapping. Eg. for the cell (0,0) in a 10 by 10 array, the coordinates for the left neighbour are (oneLeft, 0) = ((0 + 9)% 10, 0) = (9,0). Similarly if you can compute the neighbours for oneRight, oneUP, oneDown and then TopLeft, TopRight, BottomLeft and BottomRight by using a combination of the two.
    let oneRight = (cellCordinates.col + 1)%cols
    let oneLeft = (cellCordinates.col + cols-1)%cols
    let oneUp = (cellCordinates.row + rows-1)%rows
    let oneDown = (cellCordinates.row + 1)%rows
    
    let x = cellCordinates.col
    let y = cellCordinates.row
    
    return [(oneRight,y),(oneLeft,y),(x,oneUp),(x,oneDown),(oneRight,oneUp),(oneLeft,oneUp),(oneRight,oneDown),(oneLeft,oneDown)]
}




//Step function that takes in a 2D Array of Bools and returns a 2D Array of Bools but after applying the Conway Game of Life Logic
func step(before: [[Bool]])-> [[Bool]]{
    
    let cols: Int = before.count
    let rows: Int = before[0].count
    
    var after: [[Bool]] = Array(count: cols, repeatedValue:Array(count:rows, repeatedValue:false))
    
    //no. of alive neighbours
    var alive: Int = 0
    
    for i in 0...cols-1{
        for j in 0...rows-1{
            
            let neighbour = neighbours((i,j), cols: cols, rows: rows)
            
            for n in neighbour{
                if before[n.col][n.row] == true{
                    alive = alive + 1
                }
            }
            
            //I used if statements instead of a switch statement because I find them easier to work with and thus, easier to debug and to avoid a mistake. However, I have left the commented out switch statement below as well in case that was a requirement for grading although I don't think the assignment said so. You emphasized a switch statement in the previous assignment thus, I've put it in here.
            if (alive < 2 ){
                after[i][j] = false
            } else if (alive == 2 || alive == 3 ){
                after[i][j] = true
            } else if (alive > 3){
                after[i][j] = false
            }
            
//            switch true{
//            case alive < 2:
//                after[i][j] = false
//
//            case alive == 2:
//                after[i][j] = true
//                
//            case alive == 3:
//                after[i][j] = true
//                
//            case alive > 3:
//                after[i][j] = false
//            default:
//                break
//            
//            }
            alive = 0
        }
    }
    return after

}
//
//  Engine.swift
//  Assignment2*
//
//  Created by Arohi Kapoor on 7/11/16.
//  Copyright © 2016 Arohi Kapoor. All rights reserved.
//

import Foundation

func step(before: [[Bool]])-> [[Bool]]{
    
    //var count2 = count
    var after: [[Bool]] = Array(count:10, repeatedValue:Array(count:10, repeatedValue:false))
    var alive = 0
    for i in 0...9{
        for j in 0...9{
            
            if before[(i+1)%10][j] == true{
                alive = alive + 1
                
            }
            if before[(i+9)%10][j] == true{
                alive = alive + 1
                
            }
            if before[i][(j+1)%10] == true{
                alive = alive + 1
                
            }
            if before[i][(j+9)%10] == true{
                alive = alive + 1
                
            }
            if before[(i+1)%10][(j+9)%10] == true{
                alive = alive + 1
                
            }
            if before[(i+9)%10][(j+9)%10] == true{
                alive = alive + 1
                
            }
            if before[(i+1)%10][(j+1)%10] == true{
                alive = alive + 1
                
            }
            if before[(i+9)%10][(j+1)%10] == true{
                alive = alive + 1
                
            }
            
            switch (alive){
            case 1:
                alive < 2
                after[i][j] = false
                //count2 = count2 - 1
            case 2:
                alive == 2
                after[i][j] = true
                //count2 = count2 + 1
                
            case 3:
                alive == 3
                after[i][j] = true
                //count2 = count2 + 1
                
            case 4:
                alive > 3
                after[i][j] = false
                //count2 = count2 - 1
                
            default:
                break
            }
            alive = 0
        }
    }
    return after
}

func neighbours(cellCordinates: (col:Int, row: Int))-> [(col:Int, row: Int)]{
    
    let oneRight = (cellCordinates.col + 1)%10
    let oneLeft = (cellCordinates.col + 9)%10
    let oneUp = (cellCordinates.row + 9)%10
    let oneDown = (cellCordinates.row + 1)%10
    let x = cellCordinates.col
    let y = cellCordinates.row
    
    return [(oneRight,y),(oneLeft,y),(x,oneUp),(x,oneDown),(oneRight,oneUp),(oneLeft,oneUp),(oneRight,oneDown),(oneLeft,oneDown)]
}

func step2(before: [[Bool]])-> [[Bool]]{
    
    //var count2 = count
    var after: [[Bool]] = Array(count:10, repeatedValue:Array(count:10, repeatedValue:false))
    var alive = 0
    for i in 0...9{
        for j in 0...9{
            
            let neighbour = neighbours((i,j))
            
            for n in neighbour{
                if before[n.col][n.row] == true{
                    alive = alive + 1
                }
            }
            
            switch (alive){
            case 1:
                alive < 2
                after[i][j] = false
            //count2 = count2 - 1
            case 2:
                alive == 2
                after[i][j] = true
                //count2 = count2 + 1
                
            case 3:
                alive == 3
                after[i][j] = true
                //count2 = count2 + 1
                
            case 4:
                alive > 3
                after[i][j] = false
                //count2 = count2 - 1
                
            default:
                break
            }
            alive = 0
        }
    }
    return after
}


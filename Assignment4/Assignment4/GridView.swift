//
//  GridView.swift
//  Assignment4
//
//  Created by Arohi Kapoor on 7/18/16.
//  Copyright © 2016 Arohi Kapoor. All rights reserved.
//

import UIKit
import Foundation


@IBDesignable class GridView: UIView {
    
    
    var grid:[[CellState]] = Array(count: 10, repeatedValue: Array(count: 10, repeatedValue:CellState.Empty))
    @IBInspectable var rows: Int = 10 {
        didSet{
            grid = Array(count: cols, repeatedValue: Array(count: rows, repeatedValue:CellState.Empty))
        }
    }
    @IBInspectable var cols: Int = 10 {
        didSet{
            grid = Array(count: cols, repeatedValue: Array(count: rows, repeatedValue:CellState.Empty))
        }
    }
    
    //When points is updated, grid is updated
    
    @IBInspectable var livingColor: UIColor = UIColor(red: CGFloat(0),green: CGFloat(0.8), blue: CGFloat(0.2), alpha: CGFloat(1.0))
    
    @IBInspectable var bornColor: UIColor = UIColor(red: CGFloat(0),green: CGFloat(0.8), blue: CGFloat(0.2), alpha: CGFloat(0.6))
    @IBInspectable var diedColor: UIColor = UIColor(red: CGFloat(71/255),green: CGFloat(79/255), blue: CGFloat(82/255), alpha: CGFloat(0.6))
    @IBInspectable var emptyColor: UIColor = UIColor(red: CGFloat(71/255),green: CGFloat(79/255), blue: CGFloat(82/255), alpha: CGFloat(1.0))
    @IBInspectable var gridColor: UIColor = UIColor(red: CGFloat(0),green: CGFloat(0), blue: CGFloat(0), alpha: CGFloat(1.0))
    @IBInspectable var gridWidth:CGFloat = 2.0
    
    //I create these here so I can call them in my update method
    var cellWidth: CGFloat = 0
    var cellHeight: CGFloat = 0
    var gridSizeWidth: CGFloat = 0
    var gridSizeHeight: CGFloat = 0
    var points:[(Col: Int, Row: Int)]!
    
    //Draws my grid
    override func drawRect(rect: CGRect) {
        gridSizeWidth = bounds.width
        gridSizeHeight = bounds.height
        cellWidth = gridSizeWidth/CGFloat(cols)
        cellHeight = gridSizeHeight/CGFloat(rows)
        
        let gridPath = UIBezierPath()
        gridPath.lineWidth = gridWidth
        
        
        for i in 0...cols{
            gridPath.moveToPoint(CGPoint(
                x: CGFloat (i) * cellWidth,
                y:0))
            gridPath.addLineToPoint(CGPoint(
                x: CGFloat (i) * cellWidth,
                y:gridSizeHeight))
            gridColor.setStroke()
            gridPath.stroke()
        }
        
        for i in 0...rows{
            gridPath.moveToPoint(CGPoint(
                x: 0,
                y:CGFloat (i) * cellHeight))
            
            gridPath.addLineToPoint(CGPoint(
                x: gridSizeWidth,
                y:CGFloat (i) * cellHeight))
            gridColor.setStroke()
            gridPath.stroke()
        }
        
        for i in 0..<cols{
            for j in 0..<rows{
                let rect = CGRect(x: CGFloat (i) * cellWidth, y: CGFloat (j) * cellHeight, width: cellWidth, height: cellHeight)
                let path = UIBezierPath(ovalInRect: rect)
                switch grid[i][j] {
                case .Living:
                    livingColor.setFill()
                    path.fill()
                case .Born:
                    bornColor.setFill()
                    path.fill()
                case .Empty:
                    emptyColor.setFill()
                    path.fill()
                case .Died:
                    diedColor.setFill()
                    path.fill()
                }
            }
        }
    }

    //Called by my delegate whenever my Grid is changed
    func update(withGrid: GridProtocol) {

        for i in 0..<cols{
            for j in 0..<rows{
                grid[i][j] = withGrid[i,j]
            }
        }
        
        //When the rows or columns in the grid are changed and the grid needs to be drawn again
        if self.rows != withGrid.rows || self.cols != withGrid.cols {
            rows = withGrid.rows
            cols = withGrid.cols
            cellWidth = gridSizeWidth/CGFloat(cols)
            cellHeight = gridSizeHeight/CGFloat(rows)
            self.setNeedsDisplay()
        }
        
        //When grid is updated because of step() being called (via the timer or UIButton) or user touch on the grid
        else {
            
            for i in 0..<withGrid.cols{
                for j in 0..<withGrid.rows{
                    let rect = CGRect(x: CGFloat (i) * cellWidth, y: CGFloat (j) * cellHeight, width: cellWidth, height: cellHeight)
                    self.setNeedsDisplayInRect(rect)
                }
            }
            
        }
        
    }
}


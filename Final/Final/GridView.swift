//
//  GridView.swift
//  Final
//
//  Created by Arohi Kapoor on 8/4/16.
//  Copyright © 2016 Arohi Kapoor. All rights reserved.
//

import UIKit

@IBDesignable class GridView: UIView {
    
    private (set) var grid: GridProtocol = Grid(COLS: 10,ROWS: 10)
    
    @IBInspectable var rows: Int = 10 {
        didSet{
            grid = Grid(COLS: self.cols, ROWS: self.rows)
        }
    }
    
    @IBInspectable var cols: Int = 10 {
        didSet{
            grid = Grid(COLS: self.cols, ROWS: self.rows)
        }
    }
    
    @IBInspectable var livingColor: UIColor = UIColor(red: CGFloat(0),green: CGFloat(0.8), blue: CGFloat(0.2), alpha: CGFloat(1.0))
    
    @IBInspectable var bornColor: UIColor = UIColor(red: CGFloat(0),green: CGFloat(0.8), blue: CGFloat(0.2), alpha: CGFloat(0.6))
    @IBInspectable var diedColor: UIColor = UIColor(red: CGFloat(71/255),green: CGFloat(79/255), blue: CGFloat(82/255), alpha: CGFloat(0.6))
    @IBInspectable var emptyColor: UIColor = UIColor(red: CGFloat(71/255),green: CGFloat(79/255), blue: CGFloat(82/255), alpha: CGFloat(1.0))
    @IBInspectable var gridColor: UIColor = UIColor(red: CGFloat(0),green: CGFloat(0), blue: CGFloat(0), alpha: CGFloat(1.0))
    @IBInspectable var gridWidth:CGFloat = 2.0
    
    //I create these here so I can call them in my update method
    private (set) var cellWidth: CGFloat = 0
    private (set) var cellHeight: CGFloat = 0
    private (set) var gridSizeWidth: CGFloat = 0
    private (set) var gridSizeHeight: CGFloat = 0
    
    private (set) var points:[(Col: Int, Row: Int)] = [(0,0)]
    
    //Draws my grid
    override func drawRect(rect: CGRect) {
        gridSizeWidth = bounds.width
        gridSizeHeight = bounds.height
        cellWidth = gridSizeWidth/CGFloat(cols)
        cellHeight = gridSizeHeight/CGFloat(rows)
        
        let gridPath = UIBezierPath()
        gridPath.lineWidth = gridWidth
        
        
        for i in 0...cols{
            gridPath.moveToPoint(CGPoint(x: CGFloat (i) * cellWidth, y:0))
            gridPath.addLineToPoint(CGPoint(x: CGFloat (i) * cellWidth,y:gridSizeHeight))
            gridColor.setStroke()
            gridPath.stroke()
        }
        
        for i in 0...rows{
            gridPath.moveToPoint(CGPoint(x: 0,y:CGFloat (i) * cellHeight))
            gridPath.addLineToPoint(CGPoint(x: gridSizeWidth,y:CGFloat (i) * cellHeight))
            gridColor.setStroke()
            gridPath.stroke()
        }
        
        for i in 0..<cols{
            for j in 0..<rows{
                let rect = CGRect(x: CGFloat (i) * cellWidth, y: CGFloat (j) * cellHeight, width: cellWidth, height: cellHeight)
                let path = UIBezierPath(ovalInRect: rect)
                
                switch grid[i,j] {
                case .Alive:
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
        
        //When the rows or columns in the grid are changed and the grid needs to be drawn again
        if self.rows != withGrid.rows || self.cols != withGrid.cols {
            rows = withGrid.rows
            cols = withGrid.cols
            cellWidth = gridSizeWidth/CGFloat(cols)
            cellHeight = gridSizeHeight/CGFloat(rows)
            self.setNeedsDisplay()
        }
            
            //        When grid is updated because of step() being called (via the timer or UIButton) or user touch on the grid
        else {
            self.grid = withGrid
            points.removeAll()
            for i in 0..<cols{
                for j in 0..<rows{
                    let rect = CGRect(x: CGFloat (i) * cellWidth, y: CGFloat (j) * cellHeight, width: cellWidth, height: cellHeight)
                    self.setNeedsDisplayInRect(rect)
                    if grid[i,j].isLiving() { points.append((i,j))
                    }
                }
            }
        }
    }
}

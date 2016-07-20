//
//  GridView.swift
//  Assignment3
//
//  Created by Arohi Kapoor on 7/11/16.
//  Copyright © 2016 Arohi Kapoor. All rights reserved.
//

import UIKit


@IBDesignable class GridView: UIView {
    
    
    //In the below variables, I have included a 2-DArray<Bool> that contains whether a cell is alive or not and I re-initialize it according to a change in rows and columns. I save this here so that I can access and change its value when I press my run button in my ViewController. If I initalize this within the Action, I cannot keep track of the previous array
    var grid:[[CellState]] = Array(count: 20, repeatedValue: Array(count: 20, repeatedValue:CellState.Empty))
    var before: [[Bool]] = Array(count:0, repeatedValue:Array(count:0, repeatedValue:false))
    var beforeIsEmpty: Bool = true
    @IBInspectable var rows: Int = 20 {
        didSet{
            grid = Array(count: cols, repeatedValue: Array(count: rows, repeatedValue:CellState.Empty))
            before = Array(count:cols, repeatedValue:Array(count:rows, repeatedValue:false))
        }
    }
    @IBInspectable var cols: Int = 20 {
        didSet{
            grid = Array(count: cols, repeatedValue: Array(count: rows, repeatedValue:CellState.Empty))
            before = Array(count:cols, repeatedValue:Array(count:rows, repeatedValue:false))
        }
    }
    
    
    @IBInspectable var livingColor: UIColor = UIColor.yellowColor()
    @IBInspectable var bornColor: UIColor = UIColor.greenColor()
    @IBInspectable var diedColor: UIColor = UIColor.brownColor()
    @IBInspectable var emptyColor: UIColor = UIColor.whiteColor()
    @IBInspectable var gridColor: UIColor = UIColor.grayColor()
    @IBInspectable var gridWidth:CGFloat = 2
    
    //I create these here so I can call them in my update method
    var cellWidth: CGFloat = 0
    var cellHeight: CGFloat = 0
    
    //Draws my grid
    override func drawRect(rect: CGRect) {
        let gridSizeWidth: CGFloat = bounds.width
        let gridSizeHeight: CGFloat = bounds.height
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
    
    //Problem 6:
    //This function takes a 2-D Array of CellStates and updates the color of the ovals in each rect according to its corresponding CellState, by using the setNeedsDisplayInRect Method
    func update(cellStateGrid: [[CellState]]){
        for i in 0...cols-1{
            for j in 0...rows-1{
                let rect = CGRect(x: CGFloat (i) * cellWidth, y: CGFloat (j) * cellHeight, width: cellWidth, height: cellHeight)
                self.setNeedsDisplayInRect(rect)
            }
        }
    }
    
    //Problem 5:
    //This function takes the location that the user tapped on and computes the particular rect (its origin points in the View) as well as the cell in the grid that it belongs to. It then toggles the CellState of the corresponding grid cell and updates the rect using setNeedsDisplayInRect
    func updateTouch(Point: CGPoint){
        
        var x: CGFloat = 0
        var y: CGFloat = 0
        var xInGrid: Int = 0
        var yInGrid: Int = 0
        
        for i in 0...cols-1{
            if (Point.x > CGFloat (i) * cellWidth) && (Point.x < CGFloat (i + 1) * cellWidth) {
                x = CGFloat(i) * cellWidth
                xInGrid = i
                break
            }
        }
        
        for i in 0...rows-1{
            if (Point.y > CGFloat (i) * cellWidth) && (Point.y < CGFloat (i + 1) * cellWidth) {
                y = CGFloat(i) * cellHeight
                yInGrid = i
                break
            }
        }
        
        grid[xInGrid][yInGrid] = grid[xInGrid][yInGrid].toggle(grid[xInGrid][yInGrid])
        let rect = CGRect(x: x, y: y, width: cellWidth, height: cellHeight)
        self.setNeedsDisplayInRect(rect)
    }
    
    
    //update method () -- that is same as update above. it is called when run button is pressed and it is also called when touched 
    // both of them change the cellstate grid 
    // run should use only step to change the cell state grid
    // passing in before which doesn't just return array of after bools but also changes [[cellState]]
    // touch should use ? to change the cell state grid
        //first 
        // basically something that looks at before and after and changes [[cellstate]]
    //then call update
    
}

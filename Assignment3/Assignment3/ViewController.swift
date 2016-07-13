//
//  ViewController.swift
//  Assignment3
//
//  Created by Arohi Kapoor on 7/11/16.
//  Copyright © 2016 Arohi Kapoor. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    //Problem 5: sends the points of the location touched by the user to the method that updates the Cell's color in GridView
    @IBAction func Touch(sender: UITapGestureRecognizer) {
        let a = sender.locationInView(MyGrid)
        MyGrid.updateTouch(a)
    }
    
    @IBOutlet weak var MyGrid: GridView!
    
    //Problem 6: Handles the Run button click to generate a new iteration of the grid
    @IBAction func Run(sender: AnyObject) {
        //This if condition is to handle the edge case where the button is clicked for the first time. I expect the Bool 2D array containing a cell's life state to be all false. In this case I will initialize the array to 1/3 alive cells
        if MyGrid.beforeIsEmpty {
            let temp = MyGrid.before
            for i in 0...MyGrid.cols-1{
                for j in 0...MyGrid.rows-1{
                    if arc4random_uniform(3) == 1{
                        MyGrid.before[i][j] = true
                    }
                }
            }

            
            //I update the gridView's CellState grid, which is used to update color value based on a comparison of the before and after values of the 2D-Array<Bool>
            MyGrid.grid = gridUpdate(temp, after: MyGrid.before)
            
            //I call the method that updates the display only for the rects in the grid
            MyGrid.update(MyGrid.grid)
            
            MyGrid.beforeIsEmpty = false
            
        } else {
            
            //This is not the first time the button is clicked,  thus, I generate the next cycle of the game by calling my step() method on the before array and call that the after array
            let after = step(MyGrid.before)
            
            //I follow the same steps of updating the CellState grid through a comparison of the two 2-D Arrays and then update my GridView
            MyGrid.grid = gridUpdate(MyGrid.before, after: after)
            MyGrid.update(MyGrid.grid)
            MyGrid.before = after
        }
        
        //Note that I am updating the CellState grid and the before array in my instance of the GridView class so they do not change when I click the button again
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}


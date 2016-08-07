//
//  EditGridViewController.swift
//  Final
//
//  Created by Arohi Kapoor on 8/7/16.
//  Copyright © 2016 Arohi Kapoor. All rights reserved.
//

import UIKit

class EditGridViewController: UIViewController, EngineDelegate {
    
    @IBOutlet weak var Grid: GridView!
    @IBOutlet weak var Name: UITextField!
    
    var engine: StandardEngine!
    
    var commit: ((Array<(Col: Int, Row: Int)>, Bool, String, Int) -> Void)?
    var myName: String?
    var pointsReceived: Array<(Col: Int, Row: Int)>?
    
    var max: Int = 0
    var OriginalTextField: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Instance of standardEngine is used to power the pseudo grid in thie gridEditor
        engine = StandardEngine(COLS: 10, ROWS: 10)
        engine.delegate = self
        
        //Getting max of points to set rows and cols
        if let pointsReceived = pointsReceived{
            for i in 0..<pointsReceived.count{
                if pointsReceived[i].Col > max {
                    max = pointsReceived[i].Col
                }
                if pointsReceived[i].Row > max {
                    max = pointsReceived[i].Row
                }
            }
        }
        engine.rows = max + 1
        engine.cols = max + 1
        
        //Engine instance is updated with points which updates it grid which updates its gridView
        if let pointsReceived = pointsReceived{
            engine.takePoints(pointsReceived)
        }
        
        //Filling in text field if this is a new configuration i.e. custom grid. I am doing this becuase it distinguishes the grid as "changed" (as you'll further in my code). Then when the user saves, it can be saved as a new grid, which is important because the configuration and table view cell that this custom grid came from have been deleted already as explained on the TableViewController add IB action method
        if myName == "New Configuration" {
            self.Name.text = "Set a Name"
        }
    }
    
    func engineDidUpdate(withGrid: GridProtocol) {
        print("I was notified!")
        Grid.update(withGrid)
    }
    
    @IBAction func Tapped(sender: UITapGestureRecognizer) {
        let a = sender.locationInView(Grid)
        engine.tapped(a, cellWidth: Grid.cellWidth, cellHeight: Grid.cellHeight)
    }
    
    //Saves the edited Grid
    @IBAction func Save(sender: AnyObject) {
        
        var difference: Bool = false
        let newPoints: Array<(Col: Int, Row: Int)> = Grid.points
        
        //Determines if user has changed grid difference is changed to true else it remains false
        if let pointsReceived = pointsReceived{
            if pointsReceived.count != newPoints.count{
                difference = true
            } else {
                var setOld = Set<String>()
                for i in 0..<pointsReceived.count{
                    let a: String = String(pointsReceived[i])
                    setOld.insert(a)
                }
                for i in 0..<newPoints.count{
                    if !setOld.contains(String(newPoints[i])){
                        difference = true
                        break
                    }
                }
                
            }
        }
        
        //When grid has changed (This includes changing the name of the grid by filling in the text field - WHICH,
        //A) accounts for the instance where user wants something like MY BLINKER, which is the same as blinker in terms of points
        //B) helps with the handling of adding a custom configuration
        //C) avoids the case where user tries to change the name of a pre-configured grid, but when it goes back the grid's name is unchanged because it updated back to the JSON title.
        
        if difference || !self.Name.text!.isEmpty {
            if let text = self.Name.text {
                //If user filled textfield on screen, then commit with changed points, true for changed variable, name in textfield
                if !text.isEmpty {
                    self.saveHelper(newPoints, changed: true, name: self.Name.text!)
                }
                    
                //If textfield is not filled, prompt for name and then commit with variables when user clicks 'OK' in alert
                else {
                    self.callAlert(newPoints)
                }
            }
        } else {
            //If there is no change to grid then simply commit the data, with false as changed var
            if let pointsReceived = pointsReceived{
                self.saveHelper(pointsReceived, changed: false, name: "")
            }
        }
    }
    
    func configurationTextField(textField: UITextField!)
    {
        if textField != nil {
            OriginalTextField = self.Name
            self.Name = textField!
        }
    }
    
    func saveHelper(points : Array<(Col:Int, Row: Int)>,changed: Bool, name: String){
        guard let commit = self.commit
            else { return }
        commit(points, changed, name, self.max)
        self.navigationController!.popViewControllerAnimated(true)
    }
    
    func callAlert(points : Array<(Col:Int, Row: Int)>){
        let alert = UIAlertController(title: "Grid Change",
                                      message:"This grid has been modified from the configuration you chose. Please give it a new name",
                                      preferredStyle: .Alert)
        alert.addTextFieldWithConfigurationHandler(configurationTextField)
        alert.addAction(UIAlertAction(title: "OK", style: .Default) { _ in
            self.saveHelper(points, changed: true, name: self.Name.text!)
            })
        alert.addAction(UIAlertAction(title: "Cancel", style: .Default) { _ in
            self.Name = self.OriginalTextField
            })
        self.presentViewController(alert, animated: true){}
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

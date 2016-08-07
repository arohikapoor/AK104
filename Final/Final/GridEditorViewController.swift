//
//  GridEditorViewController.swift
//  Final
//
//  Created by Arohi Kapoor on 8/1/16.
//  Copyright © 2016 Arohi Kapoor. All rights reserved.
//

import UIKit








//is there anyway that this is used to persist? that I somehow save the SE? google it.

class GridEditorViewController: UIViewController, EngineDelegate {
    @IBOutlet weak var MyEditGrid: GridView!
    
    @IBOutlet weak var MyEditorGrid: GridView!
//  @IBOutlet weak var Name: UITextField!
//    
//    var myName: String?
//    var commit: ((Array<(Col: Int, Row: Int)>, Bool, String, Int) -> Void)?
    var engine: StandardEngine!
//    var pointsReceived: Array<(Col: Int, Row: Int)>?
//    var OriginalTextField: UITextField!
//    var max: Int = 0
//    
    override func viewDidLoad() {
        super.viewDidLoad()
        engine = StandardEngine(COLS: 10, ROWS: 10)
        engine.delegate = self
        
//        if let pointsReceived = pointsReceived{
//            for i in 0..<pointsReceived.count{
//                if pointsReceived[i].Col > max {
//                    max = pointsReceived[i].Col
//                }
//                if pointsReceived[i].Row > max {
//                    max = pointsReceived[i].Row
//                }
//            }
//        }
//        engine.rows = max + 1
//        engine.cols = max + 1
//        
//        if let pointsReceived = pointsReceived{
//            engine.takePoints(pointsReceived)
//        }
//        
//        if myName == "New Configuration" {
//            self.Name.text = myName
//        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func engineDidUpdate(withGrid: GridProtocol) {
        MyEditorGrid.update(withGrid)
    }
    
    @IBAction func tapped(sender: UITapGestureRecognizer) {
        let a = sender.locationInView(MyEditorGrid)
        engine.tapped(a, cellWidth: MyEditorGrid.cellWidth, cellHeight: MyEditorGrid.cellHeight)
    }
    
    
//
//    @IBAction func Save(sender: AnyObject) {
//        
//        var difference: Bool = false
//        let newPoints: Array<(Col: Int, Row: Int)> = MyEditorGrid.points
//        
//        if let pointsReceived = pointsReceived{
//            if pointsReceived.count != newPoints.count{
//                difference = true
//            }
//WRITE A HELPER FOR THIS
//            } else {
//                let s1 = NSMutableSet()
//                let s2 = NSMutableSet()
//                    
//                for i in 0..<newPoints.count {
//                    let col = pointsReceived[i].Col
//                    let row = pointsReceived[i].Row
//                    s1.addObject([col,row])
//                    let cols = newPoints[i].Col
//                    let rows = newPoints[i].Row
//                    s2.addObject([cols,rows])
//                }
//                if s1.isEqualToSet(s2) == false{
//                    difference = true
//                }
//            }
 //       }
        
//    if difference || !self.Name.text!.isEmpty {
//        if let text = self.Name.text {
//                if !text.isEmpty {
//                    
//                    //WRITE HELPER FOR THIS
//                    guard let commit = commit
//                        else { return }
//                    if pointsReceived != nil{
//                        commit(newPoints, true, self.Name.text!, max)
//                    }
//                    navigationController!.popViewControllerAnimated(true)
//                }
//                else {
//                    
//                //WRITE HELPER FOR THIS
//                let alert = UIAlertController(title: "Grid Change",
//                                          message:"This grid has been modified from the configuration you chose. Please give it a new name",
//                                              preferredStyle: .Alert)
//                alert.addTextFieldWithConfigurationHandler(configurationTextField)
//                alert.addAction(UIAlertAction(title: "OK", style: .Default) { _ in
//                    //WRITE HELPER FOR THIS
//                    guard let commit = self.commit
//                        else { return }
//                    if self.pointsReceived != nil{
//                        commit(newPoints, true, self.Name.text!, self.max)
//                    }
//                    self.navigationController!.popViewControllerAnimated(true)
//                    })
//                alert.addAction(UIAlertAction(title: "Cancel", style: .Default) { _ in
//                   self.Name = self.OriginalTextField
//                    })
//                self.presentViewController(alert, animated: true){}
//            }
//        }
//    } else {
//            //WRITE HELPER FOR THIS
//            guard let commit = commit
//                else { return }
//            if let pointsReceived = pointsReceived{
//                commit(pointsReceived, false, "", max)
//            }
//            self.navigationController!.popViewControllerAnimated(true)
//        }
//    }
//    
//    
//    func configurationTextField(textField: UITextField!)
//    {
//        if textField != nil {
//            OriginalTextField = self.Name
//            self.Name = textField!
//        }
//    }


}
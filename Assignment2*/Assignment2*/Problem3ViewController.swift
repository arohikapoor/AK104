//
//  Problem3ViewController.swift
//  Assignment2*
//
//  Created by Arohi Kapoor on 7/5/16.
//  Copyright © 2016 Arohi Kapoor. All rights reserved.
//

import UIKit

class Problem3ViewController: UIViewController {
    
    
    @IBOutlet weak var Text: UITextView!
    @IBAction func Run(sender: AnyObject) {
        var before: [[Bool]] = Array(count:10, repeatedValue:Array(count:10, repeatedValue:false))
        var count = 0
        for i in 0...9{
            for j in 0...9{
                if arc4random_uniform(3) == 1{
                    before[i][j] = true
                    count = count + 1
                }
                
            }
        }
        var count2 = 0
        var after = step(before)
        for i in 0...9{
            for j in 0...9{
                if after[i][j] == true{
                    count2 = count2 + 1
                }
                
            }
        }
        
        Text.text = "Before count is \(count) and after count is \(count2)"
    
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Problem 3"

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

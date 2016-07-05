//
//  Problem2ViewController.swift
//  Assignment2*
//
//  Created by Arohi Kapoor on 7/5/16.
//  Copyright © 2016 Arohi Kapoor. All rights reserved.
//

import UIKit

class Problem2ViewController: UIViewController {

    
    
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
        
        var count2 = count
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
                        before[i][j] = false
                        count2 = count2 - 1
                    case 2:
                        alive == 2
                        before[i][j] = true
                        count2 = count2 + 1
                
                    case 3:
                        alive == 3
                        before[i][j] = true
                        count2 = count2 + 1
            
                    case 4:
                        alive > 3
                        before[i][j] = false
                        count2 = count2 - 1
                
                    default:
                        break
                }
                alive = 0
            }
        }
        Text.text = "Before count is \(count) and after count is \(count2)"
        
    }
    
    @IBOutlet weak var Text: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Problem 2"

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

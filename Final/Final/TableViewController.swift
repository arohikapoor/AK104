//
//  ViewController.swift
//  Class9
//
//  Created by Arohi Kapoor on 7/20/16.
//  Copyright © 2016 Arohi Kapoor. All rights reserved.
//

import UIKit

class TableViewController: UITableViewController {
    
    
    //Maintains titles for table view rows as well as dictionary data structure of [title:points]
    private var titles: Array<String> = []
    private var content: Dictionary<String,Array<(Col:Int,Row:Int)>> = [:]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //Setting up notification observations
        let sel1 = #selector(TableViewController.watchForNotificationsSave(_:))
        let sel2 = #selector(TableViewController.watchForNotificationsURL(_:))
        let center  = NSNotificationCenter.defaultCenter()
        center.addObserver(self, selector: sel1, name: "SaveNotification", object: nil)
        center.addObserver(self, selector: sel2, name: "URLNotification", object: nil)
    }
    
    override func viewDidAppear(animated: Bool) {
        //Load's Van's link as default.
        let url = NSURL(string: "https://dl.dropboxusercontent.com/u/7544475/S65g.json")!
        self.fetch(url)
    }
    
    //MARK: Fetch JSON
    func fetch(url: NSURL){
        let fetcher = Fetcher()
        fetcher.requestJSON(url) { (json, message) in
            if let json = json, arrayz = json as? Array<Dictionary<String, AnyObject>>
            {
                //Retreiving the content from Dictionary<String, AnyObject>, which is easy for getting the name because it is declared as String. However, it's a longer process for getting points from AnyObject
                for i in arrayz {
                    let keys = Array(i.keys)
                    
                    //key "title"
                    let name = String(i[keys[1]]!)
                    
                    //key "content" gives the AnyObject, which is then converted into an Array of AnyObjects
                    let tempContent = i[keys[0]]
                    let makeArray = Array(arrayLiteral: tempContent)
                    
                    //The entire object comprised of multiple [Int,Int] arrays:
                    let arrayContent = makeArray[0]
                    
                    //The eventual data structure
                    var mainContent: Array<(Col:Int, Row:Int)> = []
                    
                    //walks through components of arrayContent, casts them Ints and then inserts into mainContent, which is of format points = Array<(Col: Int, Row: Int)>
                    if let a  = arrayContent {
                        let size = a.count
                        for i in 0..<size-1{
                            let row = Int(a[i][0] as! NSNumber)
                            let col = Int(a[i][1] as! NSNumber)
                            mainContent.append((col,row))
                        }
                    }
                    
                    //Adds (Title, Points) pair to Dictionary
                    self.content[name] = mainContent
                }
                self.titles = Array(self.content.keys)
                let op = NSBlockOperation{
                    self.tableView.reloadData()
                }
                NSOperationQueue.mainQueue().addOperation(op)
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    //MARK: UITableViewDelegation
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return titles.count;
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCellWithIdentifier("Default")
            else {
                preconditionFailure("missing Default reuse identifier")
        }
        let row = indexPath.row
        
        guard let nameLabel = cell.textLabel else {
            preconditionFailure("wtf?")
        }
        nameLabel.text = titles[row]
        cell.tag = row
        return cell
    }
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            content.removeValueForKey(titles[indexPath.row])
            titles.removeAtIndex(indexPath.row)
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation:.Automatic)
        }
    }
    
    
    //MARK GridEdit-TableView Functionality
    
    //The below variables are updated only if user presses 'SAVE' in gridEdit.

    
    private var maxRowsCols: Int?
    
    //points Returned during commit regardless of changed or unchanged by user, helps change realGrid in Simulation
    private var pointsReturned: Array<(Col: Int, Row: Int)>? {
        didSet {
            self.changeRealGrid(maxRowsCols!)
        }
    }
    
    //name of the grid, used only during custom grid. Is retured by gridEditor as empty string if the grid was not a custom grid
    private var name: String?
    
    //tells table view if user changed the grid. If so, then a new row is added to the table with that configuration
    private var pointsChanged: Bool? {
        didSet{
            if pointsChanged! {
                self.addConfiguration(self.pointsReturned!, name: self.name!)
            }
        }
    }
    //Above variables are updated on SAVE, because only Save action invokes a commit closure in the gridEdit. If cancel is pressed then the commit closure is not invoked. Since, only when the above variables are updated does a row get 'selected' (all the functionality for setting the Simulation grid's configuration), or a new row get added etc. - cancel does nothing but pop back to the table.
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let editingRow = (sender as! UITableViewCell).tag
        let configuration = titles[editingRow]
        
        guard let editingVC = segue.destinationViewController as? EditGridViewController
            else {
                preconditionFailure("another wtf?")
        }
        
        //Used by gridEditor to check if this is case of custom grid generation
        editingVC.myName = configuration
        
        //Gives points to gridEditor
        editingVC.pointsReceived = content[configuration]!
        
        //If custom grid, then the rows and cols of gridEditor's grid are set to grid values in UITextfield on Instrumentation page (which update the StandardEngine.sharedInstance, thus - those values are used)
        if configuration == "New Configuration" {
            editingVC.max = max(StandardEngine.sharedInstance.cols-1, StandardEngine.sharedInstance.rows-1)
        }
        
        editingVC.commit = {
            self.maxRowsCols = $3
            self.pointsReturned = $0
            self.name = $2
            self.pointsChanged = $1
            
            let indexPath = NSIndexPath (forRow: editingRow, inSection:0)
            self.tableView.reloadRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
        }
    }
    
    //Changes grid on Simulation tab, invoked when pointsReturned didSet. Points returned is only set when save is clicked and thus, user has chosen to select it and thus, main grid is updated at this point.
    func changeRealGrid(max: Int){
        StandardEngine.sharedInstance.rows = max + 1
        StandardEngine.sharedInstance.cols = max + 1
        StandardEngine.sharedInstance.takePoints(pointsReturned!)
    }
    
    //Adds a new [title:points] pair to the content dictionary and a corresponding row with title to the table
    //Called when user makes custom grid, but also when user changes a pre-configured grid.
    func addConfiguration(points: Array<(Col:Int,Row:Int)>, name: String) {
        content[name] = points
        titles.append(name)
        let itemRow = titles.count - 1
        let itemPath = NSIndexPath(forRow:itemRow, inSection: 0)
        tableView.insertRowsAtIndexPaths([itemPath], withRowAnimation: .Automatic)
    }
    
    //adds new configuration on button action
    @IBAction func AddNewConfiguration(sender: UIBarButtonItem) {
        
        addConfiguration([(StandardEngine.sharedInstance.cols/2,StandardEngine.sharedInstance.rows/2)], name: "New Configuration")
        
        //forces segue to gridEditor
        let rowToSelect:NSIndexPath = NSIndexPath(forRow: titles.count - 1, inSection: 0);
        self.tableView.selectRowAtIndexPath(rowToSelect, animated: true, scrollPosition: UITableViewScrollPosition.None);
        let cell = tableView.cellForRowAtIndexPath(rowToSelect)
        self.performSegueWithIdentifier("tabletogrid", sender: cell);
        
        //removes the row just invoked because when user clicks save it will create a new copy and there will be a row names "New Configuration" left in the table view. Thus, the row is deleted after the segue.
        //If user cancels then the row is already gone.
        //If user saves then the configuration for the grid they're working on is saved (specificity is handled in gridEditor)
        content.removeValueForKey("New Configuration")
        titles.removeAtIndex(rowToSelect.row)
        tableView.deleteRowsAtIndexPaths([rowToSelect], withRowAnimation:.Automatic)
    }
    
    
    
    //Watching for Save of grid on Simulation tab
    func watchForNotificationsSave(notification:NSNotification){
        if let info = notification.userInfo {
            var points: Array<(Col:Int, Row: Int)> = []
            var name: String = ""
            if let NSpoints = info["points"] {
                let NSpointsarray = Array(NSpoints as! NSArray)
                for i in NSpointsarray {
                    let col: Int = Int(i[0] as! NSNumber)
                    let row: Int = Int(i[1] as! NSNumber)
                    let c:(Col: Int, Row: Int) = (col, row)
                    points.append(c)
                }
            }
            if let NSName = info["name"]{
                let NSNameArray = Array(NSName as! NSArray)
                name = String(NSNameArray[0] as! NSString)
            }
            if !points.isEmpty && !name.isEmpty {
                self.addConfiguration(points, name: name)
            }
            print(points)
        }
    }
    
    //Watching for Reload of URL on Instrumentation tab
    func watchForNotificationsURL(notification:NSNotification){
        if let info = notification.userInfo {
            if let url = info["URL"] as? NSURL{
                self.fetch(url )
            }
        }
        
    }
}


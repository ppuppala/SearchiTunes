//
//  ViewController.swift
//  SearchiTunes
//
//  Created by Praneet Puppala on 3/5/15.
//  Copyright (c) 2015 Praneet Puppala. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var appsTableView: UITableView!
    var tableData = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view, typically from a nib.
        
        searchITunesFor("Microsoft")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableData.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let myCell : UITableViewCell = UITableViewCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier: "MyExCell")
        
        // Get specific result row
        let rowData = self.tableData[indexPath.row] as NSDictionary
        
        myCell.textLabel?.text = rowData["trackName"] as? String
        myCell.detailTextLabel?.text = rowData["formattedPrice"] as? String
        
        // Fancy: get thumbnail for app by getting the artworkURL60 key to get an image URL
        let imgURLString = rowData["artworkUrl60"] as NSString
        let imgURL = NSURL(string: imgURLString)
        
        // Load data from URL as NSData
        let imgData = NSData(contentsOfURL: imgURL!)
        
        myCell.imageView?.image = UIImage(data: imgData!)
        
        // myCell.textLabel?.text = "Praneet's Row #\(indexPath.row+1)"
        // myCell.detailTextLabel?.text = "Subtitle #\(indexPath.row + 2)"
        
        return myCell
    }
    
    
    
    //------------------------------------USER DEFINED API REQUEST--------------------------------------------------------
    
    
    
    func searchITunesFor(searchTerm: String) {
        // Replace spaces with + signs to meet iTunes API requirements
        let modSearchTerm = searchTerm.stringByReplacingOccurrencesOfString(" ", withString: "+", options: NSStringCompareOptions.CaseInsensitiveSearch, range: nil)
        
        // Escape search term to prevent any unrecognized symbols
        if let escapedSearch=modSearchTerm.stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding) {
            let urlPath = "http://itunes.apple.com/search?term=\(escapedSearch)&media=software"
            let url = NSURL(string: urlPath)
            
            // Gets our default network connection/session
            let sess = NSURLSession.sharedSession()
            
            // Task to actually send request. Argument list ends with a closure that runs after task is completed
            let task = sess.dataTaskWithURL(url!, completionHandler: { data, response, error -> Void in
                println("Task completed!")
                
                // Check for errors in task completion
                if (error != nil) {
                    // print error to console if one exists
                    println(error.localizedDescription)
                }
                var err : NSError?
                
                // Get JSON and parse it
                var jsonResult = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers, error: &err) as NSDictionary
                
                // Start by checking with errors in JSON parsing
                if (err != nil) {
                    // if error parsing JSON, print to console
                    println("JSON Error \(err!.localizedDescription)")
                }
                
                // Set our table to this data
                let results : NSArray = jsonResult["results"] as NSArray
                
                // Task runs in bg, so before we update the UI, we need to get back into fg
                dispatch_async(dispatch_get_main_queue(), {
                    self.tableData = results
                    self.appsTableView!.reloadData()
                })
                
            })
            
            // With closure and task now defined, we actually need to tell task to start
            task.resume()
        }
    }
    
}


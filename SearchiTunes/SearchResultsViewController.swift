//
//  ViewController.swift
//  SearchiTunes
//
//  Created by Praneet Puppala on 3/5/15.
//  Copyright (c) 2015 Praneet Puppala. All rights reserved.
//

import UIKit

class SearchResultsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, APIControllerProtocol {

    @IBOutlet weak var appsTableView: UITableView!
    var tableData = []
    var api = APIController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view, typically from a nib.
        self.api.delegate = self
        api.searchITunesFor("Microsoft")
        
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
    
    func didReceiveAPIResults(results: NSDictionary) {
        var resultsArr : NSArray = results["results"] as NSArray
        dispatch_sync(dispatch_get_main_queue(), {
            self.tableData = resultsArr
            self.appsTableView!.reloadData()
        })
    }
}


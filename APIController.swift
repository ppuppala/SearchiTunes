//
//  APIController.swift
//  SearchiTunes
//
//  Created by Praneet Puppala on 3/6/15.
//  Copyright (c) 2015 Praneet Puppala. All rights reserved.
//

import Foundation

protocol APIControllerProtocol {
    func didReceiveAPIResults(results : NSDictionary)
}

class APIController {
    
    var delegate : APIControllerProtocol?
    
    init() {}
        
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
                //let results : NSArray = jsonResult["results"] as NSArray
                self.delegate?.didReceiveAPIResults(jsonResult)
            })
            
            // With closure and task now defined, we actually need to tell task to start
            task.resume()
        }
    }
}
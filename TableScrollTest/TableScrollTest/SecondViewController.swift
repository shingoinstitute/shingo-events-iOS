//
//  ViewController.swift
//  TableScrollTest
//
//  Created by Craig Blackburn on 2/8/16.
//  Copyright © 2016 Craig Blackburn. All rights reserved.
//

import UIKit

class CustomTableViewCell: UITableViewCell {
}

class ContentTableViewCell: UITableViewCell {
//    @IBOutlet weak var contentTF: UITextView!
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var content: UILabel!
}

class SecondViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    
    var mystring:String? = nil
    let numbers_array = [1,2,3,4,5,6,7,8,9,10]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.allowsSelection = false
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 44.0
    }
    
    override func viewDidAppear(animated: Bool)
    {
        super.viewDidAppear(animated)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "contentSizeCategoryChanged:", name: UIContentSizeCategoryDidChangeNotification, object: nil)
    }
    
    override func viewDidDisappear(animated: Bool)
    {
        super.viewDidDisappear(animated)
        
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIContentSizeCategoryDidChangeNotification, object: nil)
    }

    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCellWithIdentifier("contentcell") as! ContentTableViewCell
            cell.content.text = self.mystring
            cell.content.sizeThatFits(CGSizeMake(cell.content.frame.width, CGFloat.max))
            cell.label.text = "Hello World."
            return cell
        } else {
            let cell: UITableViewCell = tableView.dequeueReusableCellWithIdentifier("cell") as! CustomTableViewCell
            cell.textLabel!.text = String(numbers_array[indexPath.row])
            return cell
        }
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        } else {
            return numbers_array.count
        }
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 2
    }
}


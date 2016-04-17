//
//  BaseTableViewController.swift
//  Diary
//
//  Created by Taras Rudyi on 4/13/16.
//  Copyright © 2016 Taras Rudyi. All rights reserved.
//

import UIKit

class BaseTableViewController: UITableViewController {

    // MARK: Properties
    var diary:Diary? {
        didSet {
            tableView?.reloadData()
        }
    }
    
    var displayedRecords:[[DiaryRecord]] {
        return [[DiaryRecord]]()
    }
    
    func settingsDidChange(notification: NSNotification) {
        tableView?.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(self.settingsDidChange), name: "SettingDidChange", object: nil)
    }
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self, name: "SettingDidChange", object: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        tableView?.reloadData()
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return displayedRecords.count
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 0
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cellIdentifier = "RecordTableViewCell"
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as! RecordTableViewCell
        
        if indexPath.section < displayedRecords.count && indexPath.row < displayedRecords[indexPath.section].count {
            let record = displayedRecords[indexPath.section][indexPath.row]
            cell.dateLabel?.text = record.date
            cell.nameLabel?.text = record.name
            let images = ["sunny_sm", "rain_sm", "cloudy_sm"]
            cell.weatherImageView?.image = UIImage(named: images[record.weather.rawValue])
        }
        
        return cell
    }
    
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            let record = displayedRecords[indexPath.section][indexPath.row]
            if let removeIndex = diary?.records.indexOf(record) {
                diary?.records.removeAtIndex(removeIndex)
            }
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
            if (displayedRecords[indexPath.section].count == 0) {
                tableView.reloadSections(NSIndexSet(index: indexPath.section), withRowAnimation: .None)
            }
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }
    }

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "ShowRecord" {
            let recordViewController = segue.destinationViewController as? RecordTableViewController
            if let selectedRecordCell = sender as? RecordTableViewCell {
                let indexPath = tableView.indexPathForCell(selectedRecordCell)!
                let selectedRecord = displayedRecords[indexPath.section][indexPath.row]
                recordViewController?.record = selectedRecord
            }
        }
    }
    
    func updateActiveRecord(record: DiaryRecord) {
        if diary?.records.indexOf(record) != nil {
            // not need to set diary?.records[updateIndex] = record, Swift pass objects by reference always
            tableView.reloadData()
        } else {
            //FIX ME: here is an error when setting date in past
            let newIndexPath = NSIndexPath(forRow: 0, inSection: 0)
            diary?.records.append(record)
            tableView.insertRowsAtIndexPaths([newIndexPath], withRowAnimation: .Top)
        }
    }
}

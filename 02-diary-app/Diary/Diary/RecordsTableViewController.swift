//
//  RecordsTableViewController.swift
//  Diary
//
//  Created by Taras Rudyi on 4/4/16.
//  Copyright © 2016 Taras Rudyi. All rights reserved.
//

import UIKit

class RecordsTableViewController: UITableViewController {

    // MARK: Properties
    
    var records = [DiaryRecord]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Load the sample data.
        loadSampleRecords()
    }
    
    func loadSampleRecords() {
        let emptyWeekRecord = DiaryRecord(createdDate: DatePeriods.twoDaysAgo, weather: Weather.Cloudy)
        let yesterdayRecord = DiaryRecord(createdDate: DatePeriods.yesterday, text: "Вчив Swift.", weather: Weather.Rainy)
        let nowRecord       = DiaryRecord(name: "Зараз", text: "П’ю каву, пташки співають, бо вже весна!", tags: ["весна", "сонечко", "кава"])
        let weekAgoRecord   = DiaryRecord(createdDate: DatePeriods.oneWeekAgo, name: "Вечеря", weather: Weather.Rainy)
        let yearAgoRecord   = DiaryRecord(createdDate: DatePeriods.oneYearAgo, name: "Рік тому", text: "Вже весна!", tags: ["весна", "сонечко", "пташки"])
        
        records += [yearAgoRecord, weekAgoRecord, nowRecord, emptyWeekRecord, yesterdayRecord]
        
        records = records.sort({ (firstRecord: DiaryRecord, secondRecord: DiaryRecord) -> Bool in
            return firstRecord.createdDate.compare(secondRecord.createdDate) == NSComparisonResult.OrderedDescending
        })
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return records.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cellIdentifier = "RecordTableViewCell"
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as! RecordTableViewCell
        
        let record = records[indexPath.row]
        cell.dateLabel?.text = record.dateString
        cell.nameLabel?.text = record.name
        let images = ["sunny_sm", "rain_sm", "cloudy_sm"]
        cell.weatherImageView?.image = UIImage(named: images[record.wheather.rawValue])

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
            records.removeAtIndex(indexPath.row)
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
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
            let recordViewController = segue.destinationViewController as? RecordViewController
            if let selectedRecordCell = sender as? RecordTableViewCell {
                let indexPath = tableView.indexPathForCell(selectedRecordCell)!
                let selectedRecord = records[indexPath.row]
                recordViewController?.record = selectedRecord
            }
        } else if segue.identifier == "AddRecord" {
            print("Adding new record.")
        }
    }
    
    func updateActiveRecord(record: DiaryRecord) {
        if let selectedIndexPath = tableView.indexPathForSelectedRow {
            records[selectedIndexPath.row] = record
            tableView.reloadRowsAtIndexPaths([selectedIndexPath], withRowAnimation: .None)
        } else {
            let newIndexPath = NSIndexPath(forRow: 0, inSection: 0)
            records.insert(record, atIndex: 0)
            tableView.insertRowsAtIndexPaths([newIndexPath], withRowAnimation: .Top)
        }
    }
}

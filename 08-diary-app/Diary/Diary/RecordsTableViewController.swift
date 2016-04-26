//
//  RecordsTableViewController.swift
//  Diary
//
//  Created by Taras Rudyi on 4/4/16.
//  Copyright © 2016 Taras Rudyi. All rights reserved.
//

import UIKit

class RecordsTableViewController: BaseTableViewController {
    
    let sectionTitles = ["Today", "This Week", "This Month", "Earlier"]
    
    override var displayedRecords: [[DiaryRecord]] {
        if let diary = diary {
            let sortedRecords = diary.records.sort({ (firstRecord: DiaryRecord, secondRecord: DiaryRecord) -> Bool in
                return firstRecord.createdDate.compare(secondRecord.createdDate) == .OrderedDescending
            })
            
            var records = [[DiaryRecord](), [DiaryRecord](), [DiaryRecord](), [DiaryRecord]()]
            for record in sortedRecords {
                let indexPath = getIndexPathForRecord(record)
                records[indexPath.section].append(record)                
            }
            return records
        }
        return [[DiaryRecord]]()
    }
        
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return displayedRecords[section].count
    }
    
    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if displayedRecords[section].count > 0 {
            return 25
        }
        return 0
    }
        
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if displayedRecords[section].count > 0 {
            return sectionTitles[section]
        }
        return nil
    }
    
    override func tableView(tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        if let header: UITableViewHeaderFooterView = view as? UITableViewHeaderFooterView {
            header.textLabel?.textColor = UIColor.whiteColor()
            header.textLabel?.font = UIFont.boldSystemFontOfSize(13)
            header.contentView.backgroundColor = UIColor.lightGrayColor()
        }
    }
    
    override func getIndexPathForRecord(record: DiaryRecord) -> NSIndexPath {
        let newIndexPath:NSIndexPath
        if record.isDateInToday() {
            newIndexPath = NSIndexPath(forRow: 0, inSection: 0)
        } else if record.isDateInThisWeek() {
            newIndexPath = NSIndexPath(forRow: 0, inSection: 1)
        } else if record.isDateInThisMonth() {
            newIndexPath = NSIndexPath(forRow: 0, inSection: 2)
        } else {
            newIndexPath = NSIndexPath(forRow: 0, inSection: 3)
        }
        return newIndexPath
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
}

//
//  WeatherRecordsTableViewController.swift
//  Diary
//
//  Created by Taras Rudyi on 4/13/16.
//  Copyright © 2016 Taras Rudyi. All rights reserved.
//

import UIKit

class WeatherRecordsTableViewController: BaseTableViewController {

    // MARK: Properties
    @IBOutlet weak var weatherSegmentedControl: UISegmentedControl?
    
    override var displayedRecords: [[DiaryRecord]] {
        if let diary = diary {
            let sortedRecords = diary.records.sort({ (firstRecord: DiaryRecord, secondRecord: DiaryRecord) -> Bool in
                return firstRecord.createdDate.compare(secondRecord.createdDate) == .OrderedDescending
            })
            
            var records = [[DiaryRecord](), [DiaryRecord](), [DiaryRecord]()]
            for record in sortedRecords {
                let indexPath = getIndexPathForRecord(record)
                if indexPath.section < records.count {
                    records[indexPath.section].append(record)
                }
            }
            return records
        }
        return [[DiaryRecord]]()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
        
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let segmentIndex = weatherSegmentedControl?.selectedSegmentIndex {
            if section == segmentIndex {
                return displayedRecords[segmentIndex].count
            }
        }
        return 0
    }
    
    override func getIndexPathForRecord(record: DiaryRecord) -> NSIndexPath {
        let newIndexPath:NSIndexPath
        
        switch record.weather {
        case .Sunny:
            newIndexPath = NSIndexPath(forRow: 0, inSection: 0)
        case .Rainy:
            newIndexPath = NSIndexPath(forRow: 0, inSection: 1)
        case .Cloudy:
            newIndexPath = NSIndexPath(forRow: 0, inSection: 2)
        default:
            newIndexPath = NSIndexPath(forRow: 0, inSection: 3)
        }

        return newIndexPath
    }

    
    @IBAction func onWeatherChangedAction(sender: AnyObject) {
        tableView.reloadData()
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

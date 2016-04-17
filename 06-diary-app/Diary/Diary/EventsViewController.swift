//
//  EventsViewController.swift
//  Diary
//
//  Created by Taras Rudyi on 4/16/16.
//  Copyright © 2016 Taras Rudyi. All rights reserved.
//

import UIKit

class EventsViewController: UIViewController {

    // MARK: Properties
    var diary:Diary?
    
    var displayedRecords: [DiaryRecord] {
        if let diary = diary {
            var sortedRecords = diary.records.sort({ (firstRecord: DiaryRecord, secondRecord: DiaryRecord) -> Bool in
                return firstRecord.createdDate.compare(secondRecord.createdDate) == .OrderedAscending
            })
            
            if isTimelineMode {
                for var i in 0..<sortedRecords.count {
                    let record = sortedRecords[i]
                    if record != sortedRecords.last {
                        let nextRecord = sortedRecords[i + 1]
                        let calendar = NSCalendar.currentCalendar()
                        let difference = calendar.components(.Day, fromDate: record.createdDate, toDate: nextRecord.createdDate, options: [])
                        if 2...7 ~= abs(difference.day) {
                            let emptyRecord = DiaryRecord()
                            if let date = calendar.dateByAddingUnit(.Day, value: 1, toDate: record.createdDate, options: []) {
                                emptyRecord.createdDate = date
                            }
                            emptyRecord.weather = Weather.None
                            sortedRecords.insert(emptyRecord, atIndex: i + 1)
                            i -= 1
                        }
                    }
                }
            }
            
            return sortedRecords
        }
        return [DiaryRecord]()
    }
    
    var isTimelineMode = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(animated: Bool) {
        reloadView()
    }
    
    func reloadView() {
        for subview in self.view.subviews {
            subview.removeFromSuperview()
        }
        
        var nextY:CGFloat = 0
        for record in displayedRecords {
            let eventView = EventView()
            eventView.record = record
            eventView.frame.origin = CGPointMake(30, nextY)
            nextY += eventView.frame.height
            self.view.addSubview(eventView)
        }
        
        if let scrollView = self.view as? UIScrollView {
            scrollView.contentSize.height = nextY + 30
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onViewModeChanged(sender: AnyObject) {
        if let segmentedControl = sender as? UISegmentedControl {
            isTimelineMode = segmentedControl.selectedSegmentIndex == 1
            reloadView()
        }
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

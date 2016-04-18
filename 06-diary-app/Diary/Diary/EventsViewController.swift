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
                var i = 0
                while i < sortedRecords.count - 1 {
                    let record = sortedRecords[i]
                    let nextRecord = sortedRecords[i + 1]
                    let calendar = NSCalendar.currentCalendar()
                    let dayNumber = calendar.ordinalityOfUnit(.Day, inUnit: .Era, forDate: record.createdDate)
                    let nextDayNumber = calendar.ordinalityOfUnit(.Day, inUnit: .Era, forDate: nextRecord.createdDate)
                    
                    if 2...7 ~= nextDayNumber - dayNumber {
                        let emptyRecord = DiaryRecord()
                        if let date = calendar.dateByAddingUnit(.Day, value: 1, toDate: record.createdDate, options: .MatchStrictly) {
                            emptyRecord.createdDate = date
                        }
                        emptyRecord.weather = Weather.None
                        sortedRecords.insert(emptyRecord, atIndex: i + 1)
                    }
                    i = i + 1
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
        
        let offsetX:CGFloat = 30
        var nextY:CGFloat = 0
        let records = displayedRecords
        for record in records {
            let eventView = EventView()
            
            if record == records.first {
                eventView.isFirst = true
            } else if record == records.last {
                eventView.isLast = true
            }
            
            if isTimelineMode && record.weather != .None && record != records.first {
                if let index = records.indexOf(record) {
                    let prevRecord = records[index - 1]
                    let calendar = NSCalendar.currentCalendar()
                    if calendar.isDate(record.createdDate, inSameDayAsDate: prevRecord.createdDate) {
                        eventView.hasDate = false
                    }
                }
            }
            
            eventView.record = record
            eventView.frame.origin = CGPointMake(offsetX, nextY)
            nextY += eventView.frame.height
            self.view.addSubview(eventView)
        }
        
        if let scrollView = self.view as? UIScrollView {
            scrollView.contentSize.height = nextY
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

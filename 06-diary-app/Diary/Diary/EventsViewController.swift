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
        
        if let diary = diary {
            let sortedRecords = diary.records.sort({ (firstRecord: DiaryRecord, secondRecord: DiaryRecord) -> Bool in
                return firstRecord.createdDate.compare(secondRecord.createdDate) == .OrderedAscending
            })
            
            var nextY:CGFloat = 30
            for record in sortedRecords {
                let eventView = EventView()
                eventView.record = record
                eventView.frame.origin = CGPointMake(30, nextY)
                self.view.addSubview(eventView)
                
                nextY += eventView.frame.height
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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

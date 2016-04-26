//
//  EventsViewController.swift
//  Diary
//
//  Created by Taras Rudyi on 4/16/16.
//  Copyright © 2016 Taras Rudyi. All rights reserved.
//

import UIKit

class EventsViewController: UIViewController {

    var diary:Diary? {
        didSet {
            if let treeView = self.view as? EventTreeView {
                treeView.records = diary?.records
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(animated: Bool) {
        if let treeView = self.view as? EventTreeView {
            treeView.reloadView()
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onViewModeChanged(sender: AnyObject) {
        if let segmentedControl = sender as? UISegmentedControl {
            if let treeView = self.view as? EventTreeView {
                treeView.isTimelineMode = segmentedControl.selectedSegmentIndex == 1
            }
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

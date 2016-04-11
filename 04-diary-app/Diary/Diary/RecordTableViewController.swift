//
//  RecordViewController.swift
//  Diary
//
//  Created by Taras Rudyi on 4/4/16.
//  Copyright © 2016 Taras Rudyi. All rights reserved.
//

import UIKit

class RecordTableViewController: UITableViewController, UITextFieldDelegate, UITextViewDelegate {

    // MARK: Properties
    @IBOutlet weak var weatherSegmentedControl: UISegmentedControl?
    @IBOutlet weak var titleTextField: UITextField?
    @IBOutlet weak var entryTextView: UITextView?
    
    var record: DiaryRecord?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        titleTextField?.delegate = self
        entryTextView?.delegate = self
        
        self.tableView.contentInset = UIEdgeInsetsMake(-36, 0, 0, 0);
        
        if let record = record {
            titleTextField?.text = record.name
            entryTextView?.text = record.text
            navigationItem.title = record.date
            weatherSegmentedControl?.selectedSegmentIndex = record.weather.rawValue
        } else {
            record = DiaryRecord()
            title = record?.fullDate
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
        record?.name = titleTextField?.text
        record?.text = entryTextView?.text
        
        let index = weatherSegmentedControl?.selectedSegmentIndex
        if index == 0 {
            record?.weather = Weather.Sunny
        } else if index == 1 {
            record?.weather = Weather.Rainy
        } else if index == 2 {
            record?.weather = Weather.Cloudy
        }
        
        let recordsController = navigationController?.topViewController as? RecordsTableViewController
        if let record = record {
            recordsController?.updateActiveRecord(record)
        }
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        if textField == titleTextField {
            titleTextField?.resignFirstResponder()
            entryTextView?.becomeFirstResponder()
            return false
        }
        return true
    }
    
    func textView(textView: UITextView, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {
        if textView == entryTextView {
            if (text.hasSuffix("\n")) {
                textView.resignFirstResponder()
                return false
            }
        }
        return true
    }
    
    @IBAction func showCalendarAction(sender: AnyObject) {
    
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

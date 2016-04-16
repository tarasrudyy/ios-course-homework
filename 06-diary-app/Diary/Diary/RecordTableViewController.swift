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
    @IBOutlet weak var datePicker: UIDatePicker?
    
    var record: DiaryRecord?

    private var isDatePickerVisible:Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        titleTextField?.delegate = self
        entryTextView?.delegate = self
        
        if let record = record {
            datePicker?.date = record.createdDate
            titleTextField?.text = record.name
            entryTextView?.text = record.text
            navigationItem.title = record.date
            weatherSegmentedControl?.selectedSegmentIndex = record.weather.rawValue
        } else {
            record = DiaryRecord()
            if let record = record {
                datePicker?.date = record.createdDate
                title = record.fullDate
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
        if let date = datePicker?.date {
            record?.createdDate = date
        }
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
        
        let recordsController = navigationController?.topViewController as? BaseTableViewController
        if let record = record {
            recordsController?.updateActiveRecord(record)
        }
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if indexPath.row == 0 && !isDatePickerVisible {
            return 0.0
        }
        return super.tableView(tableView, heightForRowAtIndexPath: indexPath)
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
        isDatePickerVisible = !isDatePickerVisible
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

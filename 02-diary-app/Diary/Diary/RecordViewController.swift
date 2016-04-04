//
//  RecordViewController.swift
//  Diary
//
//  Created by Taras Rudyi on 4/4/16.
//  Copyright © 2016 Taras Rudyi. All rights reserved.
//

import UIKit

class RecordViewController: UIViewController {

    // MARK: Properties
    @IBOutlet weak var weatherSegmentedControl: UISegmentedControl?
    @IBOutlet weak var titleTextField: UITextField?
    @IBOutlet weak var entryTextField: UITextField?
    
    var record: DiaryRecord?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let record = record {
            titleTextField?.text = record.name
            entryTextField?.text = record.text
            navigationItem.title = record.dateString
            switch record.wheather {
            case .Sunny:
                weatherSegmentedControl?.selectedSegmentIndex = 0
            case .Rainy:
                weatherSegmentedControl?.selectedSegmentIndex = 1
            case .Cloudy:
                weatherSegmentedControl?.selectedSegmentIndex = 2
            }
        } else {
            record = DiaryRecord()
            navigationItem.title = record?.dateStringFull
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if navigationItem.backBarButtonItem === sender {
            record?.name = titleTextField?.text
            record?.text = entryTextField?.text
            
            let index = weatherSegmentedControl?.selectedSegmentIndex
            if index == 0 {
                record?.wheather = Weather.Sunny
            } else if index == 1 {
                record?.wheather = Weather.Rainy
            } else if index == 2 {
                record?.wheather = Weather.Cloudy
            }
        }
    }
}

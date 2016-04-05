//
//  SettingsViewController.swift
//  Diary
//
//  Created by Taras Rudyi on 4/5/16.
//  Copyright © 2016 Taras Rudyi. All rights reserved.
//

import UIKit

class SettingsViewController: UITableViewController {

    // MARK: Properties
    @IBOutlet weak var dateAndTimeCell: UITableViewCell?
    @IBOutlet weak var dateCell: UITableViewCell?
    @IBOutlet weak var naturalLanguageSupportSwitch: UISwitch?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let settings = NSUserDefaults.standardUserDefaults()
        naturalLanguageSupportSwitch?.on = settings.boolForKey("naturalLanguageSupport")
        if settings.boolForKey("dateAndTime") {
            dateAndTimeCell?.accessoryType = UITableViewCellAccessoryType.Checkmark
            dateCell?.accessoryType = UITableViewCellAccessoryType.None
        } else {
            dateAndTimeCell?.accessoryType = UITableViewCellAccessoryType.None
            dateCell?.accessoryType = UITableViewCellAccessoryType.Checkmark
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onDoneAction(sender: AnyObject) {
        let settings = NSUserDefaults.standardUserDefaults()
        settings.setBool(naturalLanguageSupportSwitch?.on ?? false, forKey: "naturalLanguageSupport")
        settings.setBool(dateAndTimeCell?.accessoryType == UITableViewCellAccessoryType.Checkmark, forKey: "dateAndTime")
        
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func onDateAndTimeTap(sender: AnyObject) {
        if dateAndTimeCell?.accessoryType == UITableViewCellAccessoryType.None {
            dateAndTimeCell?.accessoryType = UITableViewCellAccessoryType.Checkmark
            dateCell?.accessoryType = UITableViewCellAccessoryType.None
        }
    }
    
    @IBAction func onDateTap(sender: AnyObject) {
        if dateCell?.accessoryType == UITableViewCellAccessoryType.None {
            dateCell?.accessoryType = UITableViewCellAccessoryType.Checkmark
            dateAndTimeCell?.accessoryType = UITableViewCellAccessoryType.None
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

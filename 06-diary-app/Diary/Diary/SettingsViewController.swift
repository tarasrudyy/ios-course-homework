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
    
    override func viewWillDisappear(animated: Bool) {
        let settings = NSUserDefaults.standardUserDefaults()
        
        let oldValue1 = settings.boolForKey("dateAndTime")
        let newValue1 = dateAndTimeCell?.accessoryType == UITableViewCellAccessoryType.Checkmark
        settings.setBool(newValue1, forKey: "dateAndTime")
        let oldValue2 = settings.boolForKey("naturalLanguageSupport")
        let newValue2 = naturalLanguageSupportSwitch?.on ?? false
        settings.setBool(newValue2, forKey: "naturalLanguageSupport")
        
        if oldValue1 != newValue1 || oldValue2 != newValue2 {
            NSNotificationCenter.defaultCenter().postNotificationName("SettingDidChange", object: nil)
        }

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if indexPath.section == 0 {
            switch indexPath.row {
            case 0:
                if dateAndTimeCell?.accessoryType == UITableViewCellAccessoryType.None {
                    dateAndTimeCell?.accessoryType = UITableViewCellAccessoryType.Checkmark
                    dateCell?.accessoryType = UITableViewCellAccessoryType.None
                }
            case 1:
                if dateCell?.accessoryType == UITableViewCellAccessoryType.None {
                    dateCell?.accessoryType = UITableViewCellAccessoryType.Checkmark
                    dateAndTimeCell?.accessoryType = UITableViewCellAccessoryType.None
                }
            default:
                debugPrint("Setting didSelectRowAtIndexPath \(indexPath.row)")
            }
            tableView.deselectRowAtIndexPath(indexPath, animated: true)
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

//
//  DiaryRecord.swift
//  Diary
//
//  Created by Taras Rudyi on 4/4/16.
//  Copyright © 2016 Taras Rudyi. All rights reserved.
//

import Foundation

struct DatePeriods {
    private static let calendar = NSCalendar.currentCalendar()
    
    static let now          = NSDate()
    static let oneHourAgo   = calendar.dateByAddingUnit(NSCalendarUnit.Hour, value: -1, toDate: now, options: NSCalendarOptions.MatchFirst)
    static let yesterday    = calendar.dateByAddingUnit(NSCalendarUnit.Day, value: -1, toDate: now, options: NSCalendarOptions.MatchFirst)
    static let twoDaysAgo   = calendar.dateByAddingUnit(NSCalendarUnit.Day, value: -2, toDate: now, options: NSCalendarOptions.MatchFirst)
    static let oneWeekAgo   = calendar.dateByAddingUnit(NSCalendarUnit.WeekOfYear, value: -1, toDate: now, options: NSCalendarOptions.MatchFirst)
    static let oneYearAgo   = calendar.dateByAddingUnit(NSCalendarUnit.Year, value: -1, toDate: now, options: NSCalendarOptions.MatchFirst)
}

class DiaryRecord: CustomStringConvertible {
    
    static let dateFormatter = NSDateFormatter()
    
    let createdDate: NSDate
    var name: String?
    var text: String?
    var tags: [String]
    
    var description: String { return fullDescription() }
    var dateString: String { return DiaryRecord.dateFormatter.stringFromDate(createdDate) }
    
    // MARK: Initialization
    
    init(createdDate: NSDate? = nil, name: String? = nil, text: String? = nil, tags: [String] = [String]()) {
        if let createdDateUnwrapped = createdDate {
            self.createdDate = createdDateUnwrapped
        } else {
            self.createdDate = NSDate()
        }
        self.name = name
        self.text = text
        self.tags = tags
        
        // set up dateFormatter for test
        DiaryRecord.dateFormatter.doesRelativeDateFormatting = true
        DiaryRecord.dateFormatter.dateStyle = NSDateFormatterStyle.MediumStyle
    }
    
    func fullDescription() -> String {
        let calendar = DiaryRecord.dateFormatter.calendar
        let thisWeek = calendar.components([NSCalendarUnit.WeekOfYear, NSCalendarUnit.Year], fromDate: NSDate())
        let createdWeek = calendar.components([NSCalendarUnit.WeekOfYear, NSCalendarUnit.Year], fromDate: createdDate)
        
        var description = [String]()
        description.append(DiaryRecord.dateFormatter.stringFromDate(createdDate))
        if calendar.isDateInToday(createdDate) {
            DiaryRecord.dateFormatter.dateFormat = "HH:mm"
            description.append(DiaryRecord.dateFormatter.stringFromDate(createdDate))
        } else if calendar.isDateInYesterday(createdDate) {
            description.append("Вчора")
        } else if createdWeek == thisWeek {
            DiaryRecord.dateFormatter.dateFormat = "EEEE"
            description.append(DiaryRecord.dateFormatter.stringFromDate(createdDate).capitalizedString)
        } else {
            DiaryRecord.dateFormatter.dateFormat = "dd MMMM YYYY"
            description.append(DiaryRecord.dateFormatter.stringFromDate(createdDate))
        }
        
        if let name = self.name {
            description.append(name)
        }
        if let text = self.text {
            description.append(text)
        }
        if tags.count > 0 {
            description.append("[\(tags.joinWithSeparator("] ["))]")
        }
        description.append("")
        
        return description.joinWithSeparator("\n")
    }
}

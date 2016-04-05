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
    static let oneHourAgo   = calendar.dateByAddingUnit(.Hour, value: -1, toDate: now, options: .MatchFirst)
    static let yesterday    = calendar.dateByAddingUnit(.Day, value: -1, toDate: now, options: .MatchFirst)
    static let twoDaysAgo   = calendar.dateByAddingUnit(.Day, value: -2, toDate: now, options: .MatchFirst)
    static let oneWeekAgo   = calendar.dateByAddingUnit(.WeekOfYear, value: -1, toDate: now, options: .MatchFirst)
    static let oneYearAgo   = calendar.dateByAddingUnit(.Year, value: -1, toDate: now, options: .MatchFirst)
}

enum Weather: Int {
    case Sunny, Rainy, Cloudy
}

class DiaryRecord: CustomStringConvertible {
    
    static let dateFormatter = NSDateFormatter()
    
    let createdDate: NSDate
    var name: String?
    var text: String?
    var tags: [String]
    var wheather: Weather
    
    var description: String {
        var description = [String]()
        description.append(self.date)
        
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
    
    var date: String {
        let settings = NSUserDefaults.standardUserDefaults()
        DiaryRecord.dateFormatter.doesRelativeDateFormatting = settings.boolForKey("naturalLanguageSupport")
        if settings.boolForKey("dateAndTime") {
            DiaryRecord.dateFormatter.dateStyle = .LongStyle
            DiaryRecord.dateFormatter.timeStyle = .ShortStyle
        } else {
            DiaryRecord.dateFormatter.dateStyle = .LongStyle
            DiaryRecord.dateFormatter.timeStyle = .NoStyle
        }
        
        return DiaryRecord.dateFormatter.stringFromDate(createdDate)
    }
    
    var fullDate: String {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateStyle = .LongStyle
        dateFormatter.timeStyle = .ShortStyle
        return dateFormatter.stringFromDate(createdDate)
    }
    
    // MARK: Initialization
    
    init(createdDate: NSDate? = nil, name: String? = nil, text: String? = nil, tags: [String] = [String](), weather: Weather? = nil) {
        if let createdDateUnwrapped = createdDate {
            self.createdDate = createdDateUnwrapped
        } else {
            self.createdDate = NSDate()
        }
        self.name = name
        self.text = text
        self.tags = tags
        if let weatherUnwrapped = weather {
            self.wheather = weatherUnwrapped
        } else {
            self.wheather = Weather.Sunny
        }
    }
}

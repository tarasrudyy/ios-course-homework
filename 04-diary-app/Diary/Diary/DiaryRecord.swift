//
//  DiaryRecord.swift
//  Diary
//
//  Created by Taras Rudyi on 4/4/16.
//  Copyright © 2016 Taras Rudyi. All rights reserved.
//

import Foundation

enum Weather: Int {
    case Sunny, Rainy, Cloudy
}

@objc class DiaryRecord: NSObject, NSCoding {
    
    let createdDate: NSDate
    var name: String?
    var text: String?
    var tags: [String]
    var weather: Weather
    
    var date: String {
        let dateFormatter = NSDateFormatter()
        let settings = NSUserDefaults.standardUserDefaults()
        dateFormatter.doesRelativeDateFormatting = settings.boolForKey("naturalLanguageSupport")
        
        if settings.boolForKey("dateAndTime") {
            let calendar = dateFormatter.calendar
            if calendar.isDateInToday(createdDate) && dateFormatter.doesRelativeDateFormatting {
                dateFormatter.dateStyle = .NoStyle
                dateFormatter.timeStyle = .ShortStyle
            } else {
                dateFormatter.dateStyle = .LongStyle
                dateFormatter.timeStyle = .ShortStyle
            }
        } else {
            dateFormatter.dateStyle = .LongStyle
            dateFormatter.timeStyle = .NoStyle
        }
        return dateFormatter.stringFromDate(createdDate)
    }
    
    var fullDate: String {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateStyle = .LongStyle
        dateFormatter.timeStyle = .ShortStyle
        return dateFormatter.stringFromDate(createdDate)
    }
    
    override var description: String {
        var description = [String]()
        description.append(self.fullDate)
        
        if let name = self.name {
            description.append(name)
        }
        if let text = self.text {
            description.append(text)
        }
        if tags.count > 0 {
            description.append("[\(tags.joinWithSeparator("] ["))]")
        }
        switch weather {
        case .Sunny:
            description.append("Sunny")
        case .Rainy:
            description.append("Rainy")
        case .Cloudy:
            description.append("Cloudy")
        }
        description.append("")
        
        return description.joinWithSeparator("\n")
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
            self.weather = weatherUnwrapped
        } else {
            self.weather = Weather.Sunny
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        createdDate = (aDecoder.decodeObjectForKey("createdDate") as? NSDate) ?? NSDate()
        name = (aDecoder.decodeObjectForKey("name") as? String) ?? ""
        text = (aDecoder.decodeObjectForKey("text") as? String) ?? ""
        tags = (aDecoder.decodeObjectForKey("tags") as? [String]) ?? [String]()
        if let weatherRawValue = aDecoder.decodeObjectForKey("weather") as? Int {
            weather = Weather(rawValue: weatherRawValue) ?? Weather.Sunny
        } else {
            weather = Weather.Sunny
        }
    }
    
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(createdDate, forKey: "createdDate")
        aCoder.encodeObject(name, forKey: "name")
        aCoder.encodeObject(text, forKey: "text")
        aCoder.encodeObject(tags, forKey: "tags")
        aCoder.encodeObject(weather.rawValue, forKey: "weather")
    }
    
    func isDateInToday() -> Bool {
        return NSDateFormatter().calendar.isDateInToday(createdDate)
    }
    
    func isDateInThisWeek() -> Bool {
        let calendar = NSDateFormatter().calendar
        let thisWeek = calendar.components([.WeekOfYear, .Year], fromDate: NSDate())
        let createdWeek = calendar.components([.WeekOfYear, .Year], fromDate: createdDate)
        return createdWeek == thisWeek
    }
    
    func isDateInThisMonth() -> Bool {
        let calendar = NSDateFormatter().calendar
        let thisMonth = calendar.components([.Month, .Year], fromDate: NSDate())
        let createdMonth = calendar.components([.Month, .Year], fromDate: createdDate)
        return createdMonth == thisMonth
    }
}

//: Playground - noun: a place where people can play

import Foundation

class DiaryRecord: CustomStringConvertible {
    let createdDate: NSDate
    var name: String?
    var text: String?
    var tags: [String]
    
    var description: String { return fullDescription() }
    
    init(createdDate: NSDate? = nil, name: String? = nil, text: String? = nil, tags: [String] = [String]()) {
        if let createdDateUnwrapped = createdDate {
            self.createdDate = createdDateUnwrapped
        } else {
            self.createdDate = NSDate()
        }
        self.name = name
        self.text = text
        self.tags = tags
    }
    
    func fullDescription() -> String {
        let dateFormatter = NSDateFormatter()
        dateFormatter.locale = NSLocale(localeIdentifier: "uk_UK")
        
        let calendar = dateFormatter.calendar
        let thisWeek = calendar.components([NSCalendarUnit.WeekOfYear, NSCalendarUnit.Year], fromDate: NSDate())
        let createdWeek = calendar.components([NSCalendarUnit.WeekOfYear, NSCalendarUnit.Year], fromDate: createdDate)
        
        var description = [String]()
        if calendar.isDateInToday(createdDate) {
            dateFormatter.dateFormat = "HH:mm"
            description.append(dateFormatter.stringFromDate(createdDate))
        } else if calendar.isDateInYesterday(createdDate) {
            description.append("Вчора")
        } else if createdWeek == thisWeek {
            dateFormatter.dateFormat = "EEEE"
            description.append(dateFormatter.stringFromDate(createdDate).capitalizedString)
        } else {
            dateFormatter.dateFormat = "dd MMMM YYYY"
            description.append(dateFormatter.stringFromDate(createdDate))
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

struct DatePeriods {
    private static let calendar = NSCalendar.currentCalendar()
    
    static let now          = NSDate()
    static let oneHourAgo   = calendar.dateByAddingUnit(NSCalendarUnit.Hour, value: -1, toDate: now, options: NSCalendarOptions.MatchFirst)
    static let yesterday    = calendar.dateByAddingUnit(NSCalendarUnit.Day, value: -1, toDate: now, options: NSCalendarOptions.MatchFirst)
    static let threeDaysAgo = calendar.dateByAddingUnit(NSCalendarUnit.Day, value: -3, toDate: now, options: NSCalendarOptions.MatchFirst)
    static let oneWeekAgo   = calendar.dateByAddingUnit(NSCalendarUnit.WeekOfYear, value: -1, toDate: now, options: NSCalendarOptions.MatchFirst)
    static let oneYearAgo   = calendar.dateByAddingUnit(NSCalendarUnit.Year, value: -1, toDate: now, options: NSCalendarOptions.MatchFirst)
}

let emptyWeekRecord = DiaryRecord(createdDate: DatePeriods.threeDaysAgo)
let yesterdayRecord = DiaryRecord(createdDate: DatePeriods.yesterday, text: "Вчив Swift.")
let nowRecord       = DiaryRecord(name: "Зараз", text: "П’ю каву, пташки співають, бо вже весна!", tags: ["весна", "сонечко", "кава"])
let weekAgoRecord   = DiaryRecord(createdDate: DatePeriods.oneWeekAgo, name: "Вечеря")
let yearAgoRecord   = DiaryRecord(createdDate: DatePeriods.oneYearAgo, name: "Рік тому", text: "Вже весна!", tags: ["весна", "сонечко", "пташки"])

// додаткове завдання

let records = [yearAgoRecord, weekAgoRecord, nowRecord, emptyWeekRecord, yesterdayRecord]

for record in records.sort({ (firstRecord: DiaryRecord, secondRecord: DiaryRecord) -> Bool in
    return firstRecord.createdDate.compare(secondRecord.createdDate) == NSComparisonResult.OrderedAscending
}) {
    print(record)
}

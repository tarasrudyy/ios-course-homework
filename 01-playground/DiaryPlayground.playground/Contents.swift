//: Playground - noun: a place where people can play

import Foundation

class DiaryRecord: CustomStringConvertible {
    let createdDate: NSDate
    var name: String?
    var text: String?
    var tags: [String]
    
    var description: String { return fullDescription() }
    var date: String {
        let dateFormatter = NSDateFormatter()
        dateFormatter.locale = NSLocale(localeIdentifier: "uk_UK")
        dateFormatter.doesRelativeDateFormatting = true
        
        let calendar = dateFormatter.calendar
        let thisWeek = calendar.components([.WeekOfYear, .Year], fromDate: NSDate())
        let createdWeek = calendar.components([.WeekOfYear, .Year], fromDate: createdDate)
        
        if calendar.isDateInToday(createdDate) {
            dateFormatter.dateStyle = .NoStyle
            dateFormatter.timeStyle = .ShortStyle
        } else if calendar.isDateInYesterday(createdDate) {
            dateFormatter.dateStyle = .LongStyle
            dateFormatter.timeStyle = .NoStyle
        } else if createdWeek == thisWeek {
            dateFormatter.dateFormat = "EEEE"
        } else {
            dateFormatter.dateStyle = .LongStyle
            dateFormatter.timeStyle = .NoStyle
        }
        
        return dateFormatter.stringFromDate(createdDate)
    }
    
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
        var description = [String]()
        description.append(date)
        
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
    static let oneHourAgo   = calendar.dateByAddingUnit(.Hour, value: -1, toDate: now, options: .MatchFirst)
    static let yesterday    = calendar.dateByAddingUnit(.Day, value: -1, toDate: now, options: .MatchFirst)
    static let twoDaysAgo   = calendar.dateByAddingUnit(.Day, value: -2, toDate: now, options: .MatchFirst)
    static let oneWeekAgo   = calendar.dateByAddingUnit(.WeekOfYear, value: -1, toDate: now, options: .MatchFirst)
    static let oneYearAgo   = calendar.dateByAddingUnit(.Year, value: -1, toDate: now, options: .MatchFirst)
}

let emptyWeekRecord = DiaryRecord(createdDate: DatePeriods.twoDaysAgo)
let yesterdayRecord = DiaryRecord(createdDate: DatePeriods.yesterday, text: "Вчив Swift.")
let nowRecord       = DiaryRecord(name: "Зараз", text: "П’ю каву, пташки співають, бо вже весна!", tags: ["весна", "сонечко", "кава"])
let weekAgoRecord   = DiaryRecord(createdDate: DatePeriods.oneWeekAgo, name: "Вечеря")
let yearAgoRecord   = DiaryRecord(createdDate: DatePeriods.oneYearAgo, name: "Рік тому", text: "Вже весна!", tags: ["весна", "сонечко", "пташки"])

// додаткове завдання

let records = [yearAgoRecord, weekAgoRecord, nowRecord, emptyWeekRecord, yesterdayRecord]

for record in records.sort({ (firstRecord: DiaryRecord, secondRecord: DiaryRecord) -> Bool in
    return firstRecord.createdDate.compare(secondRecord.createdDate) == .OrderedAscending
}) {
    print(record)
}

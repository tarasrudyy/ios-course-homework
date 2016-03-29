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
        
        let calendar = NSCalendar.currentCalendar()
        let thisWeek = calendar.component(NSCalendarUnit.WeekOfYear, fromDate: NSDate())
        let createdWeek = calendar.component(NSCalendarUnit.WeekOfYear, fromDate: self.createdDate)
                
        var description = [String]()
        if calendar.isDateInToday(createdDate)  {
            dateFormatter.dateFormat = "HH:mm"
            description.append(dateFormatter.stringFromDate(createdDate))
        } else if calendar.isDateInYesterday(createdDate) {
            description.append("Вчора")
        } else if createdWeek == thisWeek  {
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
    private static let oneHour = 3600.0
    private static let oneDay  = 24 * DatePeriods.oneHour
    private static let oneWeek =  7 * DatePeriods.oneDay
    
    static let now          = NSDate()
    static let oneHourAgo   = DatePeriods.now.dateByAddingTimeInterval(-DatePeriods.oneHour)
    static let yesterday    = DatePeriods.now.dateByAddingTimeInterval(-DatePeriods.oneDay)
    static let threeDaysAgo = DatePeriods.now.dateByAddingTimeInterval(-3 * DatePeriods.oneDay)
    static let oneWeekAgo   = DatePeriods.now.dateByAddingTimeInterval(-DatePeriods.oneWeek)
}

let emptyWeekRecord = DiaryRecord(createdDate: DatePeriods.threeDaysAgo)
let yesterdayRecord = DiaryRecord(createdDate: DatePeriods.yesterday, text: "Вчив Swift.")
let nowRecord       = DiaryRecord(name: "Зараз", text: "П’ю каву, пташки співають, бо вже весна!", tags: ["весна", "сонечко", "кава"])
let weekAgoRecord   = DiaryRecord(createdDate: DatePeriods.oneWeekAgo, name: "Вечеря")


// додаткове завдання

let records = [weekAgoRecord, nowRecord, emptyWeekRecord, yesterdayRecord]

for record in records.sort({ (firstRecord: DiaryRecord, secondRecord: DiaryRecord) -> Bool in
    return firstRecord.createdDate.compare(secondRecord.createdDate) == NSComparisonResult.OrderedAscending
}) {
    print(record)
}

//: Playground - noun: a place where people can play

import Foundation

class DiaryRecord {
    let createdDate: NSDate
    var name: String?
    var text: String?
    var tags: [String]
    
    init(name: String? = nil, text: String? = nil, tags: [String] = [String]()) {
        self.createdDate = NSDate.init()
        self.name = name
        self.text = text
        self.tags = tags
    }
    
    func fullDescription() -> String {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "dd MMMM YYYY"
        dateFormatter.locale = NSLocale(localeIdentifier: "uk_UK")
        
        return "\(dateFormatter.stringFromDate(createdDate))" +
            (name != nil ? "\n\(name!)" : "") +
            (tags.count > 0 ? "\n[\(tags.joinWithSeparator("] ["))]" : "") +
            (text != nil ? "\n\(text!)" : "") +
            "\n"
    }
}

var emptyRecord = DiaryRecord()
print(emptyRecord.fullDescription())

var completeRecord = DiaryRecord(name: "Сніданок", text:"П’ю каву, зимно і сумно, бо вже осінь.", tags: ["сумно", "дощ", "кава"])
print(completeRecord.fullDescription())

var partialRecord = DiaryRecord(name: "Вечеря")
print(partialRecord.fullDescription())

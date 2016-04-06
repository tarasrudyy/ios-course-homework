//
//  Diary.swift
//  Diary
//
//  Created by Taras Rudyi on 4/6/16.
//  Copyright © 2016 Taras Rudyi. All rights reserved.
//

import Foundation

class Diary {
    
    static let documentsDirectory = NSFileManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask).first!
    static let diaryURL = documentsDirectory.URLByAppendingPathComponent("diary.json")
    
    var records:[DiaryRecord]
    
    init() {
        records = [DiaryRecord]()
    }
    
    func loadSampleRecords() {
        let emptyWeekRecord = DiaryRecord(createdDate: DatePeriods.twoDaysAgo, weather: Weather.Cloudy)
        let yesterdayRecord = DiaryRecord(createdDate: DatePeriods.yesterday, text: "Вчив Swift.", weather: Weather.Rainy)
        let nowRecord       = DiaryRecord(name: "Зараз", text: "П’ю каву, пташки співають, бо вже весна!", tags: ["весна", "сонечко", "кава"])
        let weekAgoRecord   = DiaryRecord(createdDate: DatePeriods.oneWeekAgo, name: "Вечеря", weather: Weather.Rainy)
        let yearAgoRecord   = DiaryRecord(createdDate: DatePeriods.oneYearAgo, name: "Рік тому", text: "Вже весна!", tags: ["весна", "сонечко", "пташки"])
        
        records += [yearAgoRecord, weekAgoRecord, nowRecord, emptyWeekRecord, yesterdayRecord]
        
        records = records.sort({ (firstRecord: DiaryRecord, secondRecord: DiaryRecord) -> Bool in
            return firstRecord.createdDate.compare(secondRecord.createdDate) == NSComparisonResult.OrderedDescending
        })
    }

    func persist() {
        var simplifiedRecords = [[:]]
        for record in records {
            simplifiedRecords.append([
                "name": record.name ?? "",
                "text": record.text ?? "",
                "weather": record.wheather.rawValue,
                "date": record.createdDate.timeIntervalSinceReferenceDate,
            ]);
        }
        
        if let jsonData = try? NSJSONSerialization.dataWithJSONObject(simplifiedRecords, options: NSJSONWritingOptions.PrettyPrinted) {
            print(NSString(data: jsonData, encoding: NSUTF8StringEncoding))
        }
    }
    
    func load() {
        
    }
}
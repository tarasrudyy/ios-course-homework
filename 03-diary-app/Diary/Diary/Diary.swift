//
//  Diary.swift
//  Diary
//
//  Created by Taras Rudyi on 4/6/16.
//  Copyright © 2016 Taras Rudyi. All rights reserved.
//

import Foundation

class Diary {
    
    private lazy var localDataDirectoryURL: NSURL? = {
        var error : NSError? = nil
        do {
            let url = try NSFileManager.defaultManager().URLForDirectory(NSSearchPathDirectory.DocumentDirectory, inDomain: NSSearchPathDomainMask.UserDomainMask, appropriateForURL: nil, create: true)
            return url
        } catch var error1 as NSError {
            error = error1
            print("Error: Cannot create directory for storing local data, error: \(error)")
        } catch {
            fatalError()
        }
        return nil
    }()
    
    private lazy var jsonDataURL: NSURL? = {
        if let url = self.localDataDirectoryURL {
            let fileUrl = url.URLByAppendingPathComponent("diary.json")
            return fileUrl
        }
        return nil
    }()
    
    private lazy var dataURL: NSURL? = {
        if let url = self.localDataDirectoryURL {
            let fileUrl = url.URLByAppendingPathComponent("diary.data")
            return fileUrl
        }
        return nil
    }()
    
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

    private var dateFormatter:NSDateFormatter {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        return dateFormatter
    }
    
    func persistToJSON() {
        var serializableRecords = [[:]]
        serializableRecords.removeAll()
        for record in records {
            serializableRecords.append([
                "name": record.name ?? "",
                "text": record.text ?? "",
                "weather": record.wheather.rawValue,
                "date": dateFormatter.stringFromDate(record.createdDate),
            ]);
        }
        
        if let jsonData = try? NSJSONSerialization.dataWithJSONObject(serializableRecords, options: NSJSONWritingOptions.PrettyPrinted) {
            debugPrint(NSString(data: jsonData, encoding: NSUTF8StringEncoding))
            if let url = jsonDataURL {
                if !jsonData.writeToURL(url, atomically: true) {
                    print("Failed to persist data")
                }
            }
        }
    }
    
    func loadFromJSON() {
        if let url = jsonDataURL {
            if let data = NSData(contentsOfURL: url) {
                let jsonData = try? NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.AllowFragments)
                let deserilizedRecords = jsonData as? [[String:AnyObject]] ?? []
                if deserilizedRecords.count > 0 {
                    self.records.removeAll()
                }
                for deserilizedRecord in deserilizedRecords {
                    let name = deserilizedRecord["name"] as? String ?? ""
                    let text = deserilizedRecord["text"] as? String ?? ""
                    let weather = deserilizedRecord["weather"] as? Int ?? 0
                    let date = deserilizedRecord["date"] as? String ?? ""
                    
                    let createdDate = dateFormatter.dateFromString(date)
                    let record = DiaryRecord(createdDate: createdDate, name: name, text: text, weather: Weather(rawValue: weather))
                    
                    self.records.append(record)
                }
            }
        }
    }
}
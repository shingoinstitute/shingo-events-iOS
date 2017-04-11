//
//  SIDate.swift
//  Shingo Events
//
//  Created by Craig Blackburn on 4/4/17.
//  Copyright © 2017 Shingo Institute. All rights reserved.
//

import Foundation
import SwiftDate

/**
 SIDate provides a specific solution to dealing with date-time conversions and for correctly displaying times in the app.
 */
class SIDate {
    
    var date: Date! { get {return self._date.absoluteDate} }
    var regionDate: DateInRegion! { get {return _date } }
    var format = "MMM dd, yyyy"
    var region: Region! { get { return Region(tz: TimeZone(identifier: "UTC")!, cal: Calendar(identifier: .gregorian), loc: Locale.autoupdatingCurrent) } }
    
    /**
     Times from the server originate from `America/Denver` locale, which is offset from UTC by -6 hours
    */
    private var timeZoneOffsetInHours: Int = -6
    
    private var _date: DateInRegion!

    init() {
        _date = DateInRegion()
    }
    
    convenience init?(string: String, format: String) {
        self.init()
        
        let df = DateFormatter()
        df.dateFormat = format
        if let date = df.date(from: string) {
            let d = DateInRegion(absoluteDate: date, in: region)
            
            let calendar = Calendar.init(identifier: .gregorian)
            
            let hour = calendar.component(.hour, from: d.absoluteDate)
            let min = calendar.component(.minute, from: d.absoluteDate)
            let seconds = calendar.component(.second, from: d.absoluteDate)
            
            let components: [Calendar.Component : Int] = [
                .year: d.year,
                .month: d.month,
                .day: d.day,
                .hour: hour == 0 && min == 0 && seconds == 0 ? d.hour : d.hour + timeZoneOffsetInHours,
                .minute: d.minute,
                .second: d.second
            ]
            
            _date = DateInRegion(components: components, fromRegion: nil)
        } else {
            return nil
        }
    }
    
    convenience init(date: Date) {
        self.init()
        let d = DateInRegion(absoluteDate: date, in: region)
        
        let calendar = Calendar.init(identifier: .gregorian)
        
        let hour = calendar.component(.hour, from: d.absoluteDate)
        let min = calendar.component(.minute, from: d.absoluteDate)
        let seconds = calendar.component(.second, from: d.absoluteDate)
        
        let components: [Calendar.Component : Int] = [
            .year: d.year,
            .month: d.month,
            .day: d.day,
            .hour: hour == 0 && min == 0 && seconds == 0 ? d.hour : d.hour + timeZoneOffsetInHours,
            .minute: d.minute,
            .second: d.second
        ]
        
        _date = DateInRegion(components: components, fromRegion: nil)
    }
    
    
    
    func toString() -> String {
        return date.string(custom: format)
    }
    
    func getTime() -> String {
        return date.string(custom: "h:mm a")
    }
    
    
    
}

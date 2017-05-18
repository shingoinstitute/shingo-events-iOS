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
    let regionUTC: Region = Region(tz: TimeZoneName.currentAutoUpdating, cal: CalendarName.gregorian, loc: LocaleName.currentAutoUpdating)
    let regionMST: Region = Region(tz: TimeZoneName.americaDenver, cal: CalendarName.gregorian, loc: LocaleName.currentAutoUpdating)
    
    private var timeFormat = DateFormat.custom("h:mm a")
    private var dateFormat = DateFormat.custom("MMM dd, yyyy")
    
    private var _date: DateInRegion!

    init() {
        _date = DateInRegion()
    }
    
    convenience init?(string: String, format: String) {
        self.init()
        
        let df = DateFormatter()
        df.dateFormat = format
        if let dateFromString = df.date(from: string) {
            _date = DateInRegion(absoluteDate: dateFromString, in: regionMST)
        } else {
            return nil
        }
    }
    
    convenience init(date: Date) {
        self.init()
        _date = DateInRegion(absoluteDate: date, in: regionMST)
    }
    
    
    /// toDateString() returns a string representation of a date in the format of "MMM dd, yyyy".
    func toDateString() -> String {
        return date.string(format: dateFormat, in: regionUTC)
    }
    
    /// toTimeString() returns a string representation of date in the format of "h:mm a".
    func toTimeString() -> String {
        return date.string(format: timeFormat, in: regionMST)
    }
    
}

//
//  TimeHelper.swift
//  Deeno
//
//  Created by Michal Severín on 03.12.16.
//  Copyright © 2016 Michal Severín. All rights reserved.
//

import Foundation

/**
 Formatters.
 - DateTime
 - TimeShort
 */
public enum TimeFormatsEnum {
    
    /// yyyy-MM-dd HH:mm:ss
    case dateTime
    /// "HH:mm"
    case timeShort
    
    fileprivate var formatString: String {
        switch self {
        case .dateTime:
            return "yyyy-MM-dd HH:mm:ss"
        case .timeShort:
            return "HH:mm"
        }
    }
    
    fileprivate var formatter: DateFormatter {
        let dateFormatter: DateFormatter = DateFormatter()
        dateFormatter.dateFormat = formatString
        dateFormatter.locale = Locale(identifier: "cs_CZ")
        dateFormatter.timeZone = TimeZone.autoupdatingCurrent
        return dateFormatter
    }
    
    /**
     Returns a date representation of a given string.
     - Parameter dateString: The string to parse.
     - Returns: A date representation of string. If dateFromString: can not parse the string, returns nil.
     */
    public func dateFromString(_ dateString: String?) -> Date? {
        guard let dateString = dateString else {
            return nil
        }
        
        return formatter.date(from: dateString)
    }
    
    /**
     Returns a string representation of a given date.
     - Parameter optionalDate: The date to format.
     - Returns: A string representation of date formatted. If date is nil, returns nil value.
     */
    public func stringFromDate(_ optionalDate: Date?) -> String? {
        guard let date = optionalDate else {
            return nil
        }
        
        return formatter.string(from: date)
    }
    
    /**
     Returns a string representation of a given date.
     - Parameter optionalDate: The date to format.
     - Returns: A string representation of date formatted.
     */
    public func stringFromDate(_ date: Date) -> String {
        return formatter.string(from: date)
    }
}

// MARK: - Date extension
extension Date {
    
    static func tomorrow() -> Date {
        return Date().addingTimeInterval(60*60*24)
    }
    
    static func yesterday() -> Date {
        return Date().addingTimeInterval(-60*60*24)
    }
    
    func isToday(_ timezone: TimeZone = Configuration.DefaultTimeZone as TimeZone) -> Bool {
        return isSameDate(Date(), timezone: timezone)
    }
    
    func isTomorrow(_ timezone: TimeZone = Configuration.DefaultTimeZone as TimeZone) -> Bool {
        return isSameDate(Date.tomorrow(), timezone: timezone)
    }

    func isSameDate(_ compareDate: Date, timezone: TimeZone = Configuration.DefaultTimeZone as TimeZone) -> Bool {
        var cal = Calendar(identifier: Calendar.Identifier.gregorian)
        cal.timeZone = timezone
        let firstDate = cal.startOfDay(for: compareDate)
        let secondDate = cal.startOfDay(for: self)
        
        return firstDate.compare(secondDate) == .orderedSame
    }
    
    var day: String {
        let cal = Calendar(identifier: .gregorian)
        switch cal.component(.weekday, from: self).description {
        case "0":
            return "Sunday"
        case "1":
            return "Monday"
        case "2":
            return "Tuesday"
        case "3":
            return "Wednesday"
        case "4":
            return "Thursday"
        case "5":
            return "Friday"
        case "6":
            return "Saturday"
        default:
            return String.empty
        }
    }
}

// MARK: - Date comparision
/**
 Compares two Dates
 - Parameters:
 - lhs: First date
 - rhs: Second date
 - Returns: True if the first date is earlier than the second one. False otherwise.
 */
public func < (lhs: Date, rhs: Date) -> Bool {
    return lhs.compare(rhs) == ComparisonResult.orderedDescending
}

/**
 Compares two Dates
 - Parameters:
 - lhs: First date
 - rhs: Second date
 - Returns: True if the first date is earlier or same as the second one. False otherwise.
 */
public func <= (lhs: Date, rhs: Date) -> Bool {
    return lhs.compare(rhs) != ComparisonResult.orderedAscending
}

/**
 Compares two Dates
 - Parameters:
 - lhs: First date
 - rhs: Second date
 - Returns: True if the first date is later than the second one. False otherwise.
 */
public func > (lhs: Date, rhs: Date) -> Bool {
    return lhs.compare(rhs) == ComparisonResult.orderedAscending
}

/**
 Compares two Dates
 - Parameters:
 - lhs: First date
 - rhs: Second date
 - Returns: True if the first date is later or equal as the second one. False otherwise.
 */
public func >= (lhs: Date, rhs: Date) -> Bool {
    return lhs.compare(rhs) != ComparisonResult.orderedDescending
}

/**
 Compares two Dates
 - Parameters:
 - lhs: First date
 - rhs: Second date
 - Returns: True if the first date is equal to the second one. False otherwise.
 */
public func == (lhs: Date, rhs: Date) -> Bool {
    return lhs.compare(rhs) == ComparisonResult.orderedSame
}

/**
 Compares two Dates
 - Parameters:
 - lhs: First date
 - rhs: Second date
 - Returns: True if the first date is different than the second one. False otherwise.
 */
public func != (lhs: Date, rhs: Date) -> Bool {
    return lhs.compare(rhs) != ComparisonResult.orderedSame
}

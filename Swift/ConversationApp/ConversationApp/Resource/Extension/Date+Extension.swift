//
//  Date+Extension.swift
//  ConversationApp
//
//  Created by Scott.L on 21/12/2020.
//

import Foundation

extension Date {
    
    func isEqualTo(_ date: Date) -> Bool {
        return self == date
    }
    
    func isGreaterThan(_ date: Date) -> Bool {
        return self > date
    }
    
    func isLessThan(_ date: Date) -> Bool {
        return self < date
    }
    
    func isLessThanEqual(_ date: Date) -> Bool {
        return self <= date
    }
}


extension Date {
    
    var isTodayOrLater: Bool {
        return self > Date() || Calendar.current.isDateInToday(self)
    }
    
}

extension DateFormatter {
    
    static let calendarDay: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "d"
        formatter.locale = Locale.current
        return formatter
    }()
    
    static let weekDay: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEEE"
        formatter.locale = Locale.current
        return formatter
    }()
    
    static let calendarMonthYear: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM yyyy"
        formatter.locale = Locale.current
        return formatter
    }()
    
    static let calendarSelectedDate: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd MMMM yyyy"
        formatter.locale = Locale.current
        return formatter
    }()
    
    static let calendarDepartAndReturnDate: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd-MMM-yyyy"
        formatter.locale = Locale.current
        return formatter
    }()
    
    static let transactionDate: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd MMM yyyy h:mm a"
        formatter.locale = Locale.current
        return formatter
    }()
    
}

extension Formatter {
    
    /// https://nsdateformatter.com/
    enum DateFormat: String {
        case option1 = "dd MM yyyy"
        case option2 = "dd/MM/yyyy"
        case option3 = "dd MMM yyyy"
        case option4 = "dd-MMM-yyyy"
        case option5 = "dd-MMM-yyyy HH:mm:ss"
        case option6 = "dd/MM/yyyy hh:mm a"
        case option7 = "dd-MM-yyyy"
        case option8 = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
        case option9 = "E, d MMMM"
        case option10 = "dd-MMM-yyyy HH:mm:ss a"
        case option11 = "yyyyMMdd"
        case option12 = "E, d MMM yyyy"

        case option13 = "d MMMM"
        case option14 = "d MMMM yyyy"
        
        case timeOption1 = "HH:mm:ss"
        case time = "h:mm a"
    }
    
    static let iso8601: DateFormatter = {
        let formatter = DateFormatter()
        formatter.calendar = Calendar(identifier: .iso8601)
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.timeZone = TimeZone.ReferenceType.local
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZS"
        return formatter
    }()
    
}

extension Date {
    
    var last7Days: Date? {
        return Calendar.current.date(byAdding: .day, value: -7, to: self)
    }
    
    var last30Days: Date? {
        return Calendar.current.date(byAdding: .day, value: -30, to: self)
    }
    
    var last60Days: Date? {
        return Calendar.current.date(byAdding: .day, value: -60, to: self)
    }
    
    var next60Days: Date? {
        return Calendar.current.date(byAdding: .day, value: 60, to: self)
    }

    
    var iso8601: String {
        return Formatter.iso8601.string(from: self)
    }
    
    func toIso8601String(with dateFormat: Formatter.DateFormat = .option1) -> String {
        let formater = Formatter.iso8601
        formater.dateFormat = dateFormat.rawValue
        let str = formater.string(from: self)
        return str
    }
    
    func toString(with dateFormat: Formatter.DateFormat = .option1) -> String {
        let formater = DateFormatter()
        formater.dateFormat = dateFormat.rawValue
        let str = formater.string(from: self)
        return str
    }
    
    func timeStamp(with dateFormat: Formatter.DateFormat = .time) -> String {
        if Calendar.current.isDateInToday(self) {
            return toString(with: dateFormat)
        }
        if Calendar.current.isDateInYesterday(self) {
            return "Yesterday"
        }
        
        else {
            return toString(with: .option6)
        }
//        return toString(with: dateFormat)
    }
    
}

extension String {
    
    var iso8601: Date? {
        return Formatter.iso8601.date(from: self)
    }
    
    func toDate(with dateFormat: Formatter.DateFormat = .option1) -> Date? {
        let formater = DateFormatter()
        formater.dateFormat = dateFormat.rawValue
        let date = formater.date(from: self)
        return date
    }
    
    func isoDate(with dateFormat: Formatter.DateFormat = .option1) -> Date? {
        let formatter = DateFormatter()
        formatter.calendar = Calendar(identifier: .iso8601)
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.timeZone = TimeZone.ReferenceType.local
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        let date = formatter.date(from: self)
        return date
    }
}

extension String {
    
    var trim: String {
        return self.trimmingCharacters(in: CharacterSet.whitespaces)
    }
    
    var timeAgoSinceDate: String {
        let calendar = Calendar.current
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy hh:mm:ss".trim //change dateformat as per you requirement
        let now = dateFormatter.date(from: dateFormatter.string(from: Date()))
        let date = dateFormatter.date(from: dateFormatter.string(from: Date(timeIntervalSince1970: Double(self)!)))
        
        let earliest = (now! as NSDate).earlierDate(date!)
        let latest = (earliest == now) ? date! : now!
        let components:DateComponents = (calendar as NSCalendar).components([NSCalendar.Unit.minute , NSCalendar.Unit.hour , NSCalendar.Unit.day , NSCalendar.Unit.weekOfYear , NSCalendar.Unit.month , NSCalendar.Unit.year , NSCalendar.Unit.second], from: earliest, to: latest, options: [])
        if (components.year! >= 2) {
            return "\(String(describing: components.year)) years ago"
        } else if (components.year! >= 1){
        } else if (components.month! <= 12 && components.month! >= 1) {
            return "\(String(describing: components.month)) months ago"
        } else if (components.weekOfYear! <= 7 && components.weekOfYear! >= 1) {
            return "\(String(describing: components.weekOfYear)) weeks ago"
        }  else if (components.day! <= 30 && components.day! >= 1) {
            return "\(String(describing: components.day)) days ago"
        }  else if (components.hour! <= 23 && components.hour! >= 1) {
            return "\(String(describing: components.hour)) hours ago"
        } else if (components.minute! <= 60 && components.minute! >= 1) {
            return "\(String(describing: components.minute)) minutes ago"
        } else if (components.second! <= 59 && components.second! >= 1) {
            return "\(String(describing: components.second)) seconds ago"
        } else {
            return "Just now"
        }
        return ""
    }
    
}


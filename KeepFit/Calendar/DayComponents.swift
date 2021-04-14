//
//  DayComponents.swift
//  KeepFit
//
//  Created by Samuel Donovan on 4/12/21.
//

import SwiftUI

extension Calendar {
    static let gregorian = Calendar(identifier: .gregorian)
    static let gregShortWeekdaySymbols = gregorian.shortWeekdaySymbols
    static let gregMonthSymbols = [
        "January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"
    ]
}

struct DayComponents: Hashable, Identifiable, Comparable {
    static func < (lhs: DayComponents, rhs: DayComponents) -> Bool {
        if lhs.year < rhs.year {return true}
        if lhs.year > rhs.year {return false}
        
        if lhs.month < rhs.month {return true}
        if lhs.month > rhs.month {return false}
        
        if lhs.day < rhs.day {return true}
        return false
    }
    
    var id: DayComponents {self}
    
    let day: Int
    let month: Int
    let year: Int
    
    init(day: Int, month: Int, year: Int) {
        self.day = day
        self.month = month
        self.year = year
    }
    
    init(date: Date) {
        let components = Calendar.gregorian.dateComponents([.year,.month,.day], from: date)
        
        self.day = components.day!
        self.month = components.month!
        self.year = components.year!
    }
    
    static func getStride(proxy: GeometryProxy) -> (xStride:CGFloat,yStride:CGFloat) {
        // 7 days per week, 6 weeks in month at worst (eg 31 day month starting on Sunday)
        return (proxy.size.width/7, proxy.size.height/6)
    }
    
    func getCenter(proxy: GeometryProxy) -> (x: CGFloat, y: CGFloat) {
        let (weekday, weekOfMonth) = getDateData()
        
        let (xStride,yStride) = Self.getStride(proxy: proxy)
        
        let x = xStride/2 + CGFloat(weekday)*xStride
        let y = yStride/2 + CGFloat(weekOfMonth)*yStride
        
        return (x,y)
    }
    
    
    func getDateData() -> (weekday: Int, weekOfMonth: Int) {
        let date = DateComponents(calendar: .gregorian,timeZone: TimeZone(secondsFromGMT: 0), year: year, month: month, day: day).date!
        let components = Calendar.gregorian.dateComponents([.weekday, .weekOfMonth], from: date)
        let weekday: Int
        let weekOfMonth: Int
        
        if components.weekday! == 7 {
            weekday = 0
            weekOfMonth = day  == 1 ? 0 : components.weekOfMonth!
        } else {
            weekday = components.weekday!
            weekOfMonth = day  == 1 ? 0 : components.weekOfMonth! - 1
        }
        
        return (weekday, weekOfMonth)
    }
    
    static func today() -> DayComponents {DayComponents(date: Date())}
    
    static func getDayComponents(year: Int, month: Int) -> [DayComponents] {
        return (1...numberOfDays(year: year, month: month)).map({(day: Int) in
            DayComponents(day: day, month: month, year: year)
        })
    }
    
    //    func getDayComponents() -> [DayComponents] {
    //        return DayComponents.getDayComponents(year: year, month: month)
    //    }
    
    static func numberOfDays(year: Int, month: Int) -> Int {
        if month == 2 && isLeapYear(year: year) {return 29}
        let monthToDay = [31,28,31,30,31,30,31,31,30,31,30,31]
        return monthToDay[month-1]
    }
    
    static func isLeapYear(year: Int) -> Bool {
        if (year % 400 == 0) {return true}
        if (year % 100 == 0) {return false}
        return (year % 4 == 0)
    }
    
    func getColor(opaque: Bool) -> Color {
        let today = Self.today()
        
        if self < today {
            return Color(red: 21.0/255, green: 232.0/255, blue: 84.0/255, opacity: opaque ? 1 : 0.4)
        } else if today < self {
            return Color(red: 108/255.0, green: 19/255.0, blue: 210/255.0, opacity: opaque ? 1 : 0.4)
        } else {
            return Color(red: 26/255.0, green: 117/255.0, blue: 222/255.0, opacity: opaque ? 1 : 0.4)
        }
    }
    
    func prettyPrint() -> String {"\(Calendar.gregMonthSymbols[month-1]) \(day.description), \(year.description)"}
}

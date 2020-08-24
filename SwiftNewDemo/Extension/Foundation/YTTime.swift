//
//  YTTime.swift
//  SwiftNewDemo
//
//  Created by bjhl on 2020/8/20.
//  Copyright © 2020 Albert. All rights reserved.
//

import Foundation

public struct YTTime: Codable {
    public private(set) var millsecond: UInt64 = 0
    
    public static var now: YTTime {
        let date = Date()
        return millseconds(UInt64(date.millisecondsSince1970))
    }
    
    public static func millseconds(_ millsecond: UInt64) -> YTTime {
        var time = YTTime()
        time.millsecond = millsecond
        return time
    }
    
    public static func seconds(_ second: UInt64) -> YTTime { millseconds(second * 1000) }
    
    public static func minutes(_ minute: UInt64) -> YTTime { seconds(minute * 60) }
    
    public static func hours(_ hour: UInt64) -> YTTime { minutes(hour * 60) }
    
    public static func days(_ day: UInt64) -> YTTime { hours(day * 24) }
    
    public static func weeks(_ week: UInt64) -> YTTime { days(week * 7) }

}

// MARK: - 算数运算
extension YTTime {
    
    public static func +(lhs: Self, rhs: Self) -> Self {
        var time = YTTime()
        time.millsecond = lhs.millsecond + rhs.millsecond
        return time
    }
    
    public static func -(lhs: Self, rhs: Self) -> Self {
        var time = YTTime()
        time.millsecond = lhs.millsecond - rhs.millsecond
        return time
    }
    
}

// MARK: - Comparable
extension YTTime: Comparable {
    
    public static func < (lhs: Self, rhs: Self) -> Bool {
        return lhs.millsecond < rhs.millsecond
    }
    
    public static func == (lhs: Self, rhs: Self) -> Bool {
        return lhs.millsecond == rhs.millsecond
    }
    
}

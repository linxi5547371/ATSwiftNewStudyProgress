//
//  DateFormatter+Extensions.swift
//  XZKit
//
//  Created by binluo on 2019/12/20.
//

#if canImport(Foundation)

import Foundation

// MARK: - Cache
extension DateFormatter {
    
    /// DateFormatter的初始化非常消耗资源，缓存起来可以大大提高性能
    /// 获取可重复利用DateFormatter对象，线程安全
    ///
    /// ### 日期解析
    /// 日期解析比日期格式化慢的多，尽量先解析成日期缓存起来
    /// ```
    /// let formatter = DateFormatter.shared(with: "yyyy年MM月dd日HH时mm分ss秒")
    /// let date = formatter.date(from: "2019年02月19日12时10分10秒")
    /// ```
    /// ### 日期格式化
    /// ```
    /// let formatter = DateFormatter.shared(with: "yyyy年MM月dd日HH时mm分ss秒")
    /// let s = formatter.string(from: Date())
    /// ```
    ///
    /// - Parameter dateFormat: 格式字符串
    public class func shared(with dateFormat: String, locale: Locale = Locale(identifier: "zh_CN")) -> DateFormatter {
        let name = "SwiftDate_\(NSStringFromClass(DateFormatter.self))"
        let formatter: DateFormatter = threadSharedObject(key: name, create: { return DateFormatter() })
        formatter.locale = locale
        formatter.dateFormat = dateFormat
        return formatter
    }
    
    private class func threadSharedObject<T: AnyObject>(key: String, create: () -> T) -> T {
        if let cachedObj = Thread.current.threadDictionary[key] as? T {
            return cachedObj
        } else {
            let newObject = create()
            Thread.current.threadDictionary[key] = newObject
            return newObject
        }
    }
}

#endif

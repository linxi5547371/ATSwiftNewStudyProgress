//
//  DDLog.swift
//  SwiftNewDemo
//
//  Created by bjhl on 2020/5/20.
//  Copyright © 2020 Albert. All rights reserved.
//

import Foundation

public struct ATLog {
    enum logType: Int {
        case message
        case warning
        case error
    }
    static func log(type: logType = .message, _ line: UInt = #line, _ file: String = #file, _ function: String = #function, message: String?) {
        switch type {
        case .message:
            print(message ?? "")
        case .warning:
            print(file, line, function, message ?? "")
        case .error:
            fatalError("\(file) \(line) \(function) \(message ?? "")")
        }
    }
}

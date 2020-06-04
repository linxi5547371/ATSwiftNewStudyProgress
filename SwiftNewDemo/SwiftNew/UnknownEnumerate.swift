//
//  UnknownEnumerate.swift
//  SwiftNewDemo
//
//  Created by bjhl on 2020/6/4.
//  Copyright © 2020 Albert. All rights reserved.
//

import Foundation

enum WeekDayType: String {
    case sunday
    case monday
    case tuesday
    case wednesday
    
    func getDescription() -> String {
        //@unknown没有使用完所有枚举时会产生警告（Switch must be exhaustive）
        switch self {
        case .monday:
            return self.rawValue
        case .sunday:
        return self.rawValue
        case .wednesday:
        return self.rawValue
        @unknown default:
            print("This is a unknown type")
            return "This is a unknown type"
//        @unknown case _:
//            print("This is a unknown type")
//            return "This is a unknown type"
        }
    }
}



//
//  CustomSequence.swift
//  SwiftNewDemo
//
//  Created by Qing Class on 2019/10/21.
//  Copyright © 2019 Albert. All rights reserved.
//

import Foundation

//序列的实现
enum Season: Int {
    case spring = 1
    case summer
    case autumn
    case winter
}

struct SeasonManager  {
    var season: Season
}

extension SeasonManager: IteratorProtocol {
    
    mutating func next() -> Season? {
        
        switch season {
        case .spring:
            print("summer")
            season = .summer
            return Season.summer
        case .summer:
            print("autumn")
            season = .autumn
            return Season.autumn
        case .autumn:
            print("winter")
            season = .winter
            return nil //使其停止
        case .winter:
            print("spring")
            season = .spring
            return Season.spring
        }
    }
}

extension SeasonManager: Sequence {
    
}

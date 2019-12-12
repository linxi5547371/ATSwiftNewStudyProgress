//
//  NSOptionSet.swift
//  SwiftNewDemo
//
//  Created by Qing Class on 2019/12/11.
//  Copyright © 2019 Albert. All rights reserved.
//

import Foundation

//swift NSOptionsp(多选)实现
struct StringJoinType: OptionSet {
    let rawValue: UInt
    static let joinName    = StringJoinType(rawValue: 1 << 0)
    static let joinAge     = StringJoinType(rawValue: 1 << 1)
    static let joinAddress = StringJoinType(rawValue: 1 << 2)
    static let joinJob     = StringJoinType(rawValue: 1 << 3)
    static let joinxxx     = StringJoinType(rawValue: 1 << 4)
    static let joinxxy     = StringJoinType(rawValue: 1 << 8)
//    static let joinxxz     = StringJoinType(rawValue: 1 << 63 | ~(1 << 63)) //64位
//    static let joinxxzz     = StringJoinType(rawValue: -0x8000000000000000)
    static let joinBase: StringJoinType = [.joinName, .joinAge]
    static let joinAll: StringJoinType = [.joinBase, .joinAddress, .joinJob]
}

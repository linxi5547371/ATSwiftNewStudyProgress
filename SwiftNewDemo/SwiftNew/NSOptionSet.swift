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
    let rawValue: Int
    static let joinName    = StringJoinType(rawValue: 1 << 0)
    static let joinAge     = StringJoinType(rawValue: 1 << 1)
    static let joinAddress = StringJoinType(rawValue: 1 << 2)
    static let joinJob     = StringJoinType(rawValue: 1 << 3)
    static let joinBase: StringJoinType = [.joinName, .joinAge]
    static let joinAll: StringJoinType = [.joinBase, .joinAddress, .joinJob]
}

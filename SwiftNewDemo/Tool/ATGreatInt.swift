//
//  ATGreatInt.swift
//  SwiftNewDemo
//
//  Created by bjhl on 2020/5/8.
//  Copyright © 2020 Albert. All rights reserved.
//

import Foundation

struct ATGreatInt {
    private let valuePoint = UnsafeMutablePointer<Int>.allocate(capacity: 2)
    
    func setData() {
        for i in 0..<2 {
            (valuePoint + i).initialize(to: i)
            print(valuePoint + i)
            print((valuePoint + i).pointee)
        }
    }
}


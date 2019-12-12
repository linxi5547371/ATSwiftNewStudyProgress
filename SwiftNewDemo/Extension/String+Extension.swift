//
//  String+Extension.swift
//  SwiftNewDemo
//
//  Created by Qing Class on 2019/12/12.
//  Copyright © 2019 Albert. All rights reserved.
//

import Foundation

extension String {
    func hexStringToInt() -> UInt64 {
        var result: UInt64 = 0
        for char in self.uppercased().utf8 {
            if char >= 48 && char < 58 {
                result = result * 16 + UInt64(char) - 48
            } else if (char >= 65 && char <= 70) {
                result = result * 16 + UInt64(char) - 55
            } else {
                return 0
            }
        }
        return result
    }
}

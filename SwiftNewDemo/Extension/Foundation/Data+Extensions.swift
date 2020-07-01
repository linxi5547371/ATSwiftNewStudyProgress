//
//  Data+Extensions.swift
//  XZKit
//
//  Created by binluo on 2019/12/31.
//

import Foundation

public extension Data {
    
    /// Return data as an array of bytes.
    var bytes: [UInt8] {
        return [UInt8](self)
    }
    
    /// String by encoding Data using the given encoding (if applicable).
    ///
    /// - Parameter encoding: encoding.
    /// - Returns: String by encoding Data using the given encoding (if applicable).
    func asString(encoding: String.Encoding = .utf8) -> String? {
        return String(data: self, encoding: encoding)
    }
    
}

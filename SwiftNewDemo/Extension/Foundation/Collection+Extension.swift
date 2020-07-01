//
//  Collection+Extension.swift
//  SwiftNewDemo
//
//  Created by bjhl on 2020/5/19.
//  Copyright © 2020 Albert. All rights reserved.
//

import Foundation

public extension Collection {

    /// Safe protects the array from out of bounds by use of optional.
    ///
    ///     let arr = [1, 2, 3, 4, 5]
    ///     arr[safe: 1] -> 2
    ///     arr[safe: 10] -> nil
    ///
    /// - Parameter index: index of element to access element.
    subscript(safe index: Index) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
    
}


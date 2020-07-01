//
//  NSArray+Extension.swift
//  SwiftNewDemo
//
//  Created by bjhl on 2020/7/1.
//  Copyright © 2020 Albert. All rights reserved.
//

import Foundation

// MARK: - Methods
public extension Array {
    
    /// 插入一个元素到数组的开头
    ///
    ///     [2, 3, 4, 5].prepend(1) -> [1, 2, 3, 4, 5]
    ///     ["e", "l", "l", "o"].prepend("h") -> ["h", "e", "l", "l", "o"]
    ///
    /// - Parameter newElement: 要插入的元素
    @discardableResult
    mutating func prepend(_ newElement: Element) -> Array {
        insert(newElement, at: 0)
        return self
    }
    
    /// 安全的交换元素位置
    ///
    ///     [1, 2, 3, 4, 5].safeSwap(from: 3, to: 0) -> [4, 2, 3, 1, 5]
    ///     ["h", "e", "l", "l", "o"].safeSwap(from: 1, to: 0) -> ["e", "h", "l", "l", "o"]
    ///
    /// - Parameters:
    ///   - index: 元素位置下标.
    ///   - otherIndex: 元素位置下标.
    @discardableResult
    mutating func safeSwapAt(_ i: Index, _ j: Index) -> Array {
        guard i != j else { return self }
        guard startIndex..<endIndex ~= i else { return self }
        guard startIndex..<endIndex ~= j else { return self }
        swapAt(i, j)
        return self
    }
    
    /// 安全的移除所在下标的元素
    ///
    ///     [1, 2, 3, 4, 5].safeRemove(at: 0) -> [2, 3, 4, 5]
    ///     [1, 2, 3, 4, 5].safeRemove(at: 5) -> [1, 2, 3, 4, 5]
    ///     ["h", "e", "l", "l", "o"].safeRemove(at: 1) -> ["h", "l", "l", "o"]
    ///
    /// - Parameter index: 要删除的元素下标
    /// - Returns: 被删除的元素
    @discardableResult
    mutating func safeRemove(at index: Int) -> Element? {
        guard startIndex..<endIndex ~= index else { return nil }
        return remove(at: index)
    }
    
    /// 打乱数组的顺序
    ///
    ///        [1, 2, 3, 4, 5].shuffle()
    ///
    @discardableResult
    mutating func shuffle() -> Array {
        //http://stackoverflow.com/questions/37843647/shuffle-array-swift-3
        guard count > 1 else { return self }
        for index in startIndex..<endIndex - 1 {
            let randomIndex = Int(arc4random_uniform(UInt32(endIndex - index))) + index
            if index != randomIndex { swapAt(index, randomIndex) }
        }
        return self
    }

    /// 返回打乱数组顺序
    ///
    ///        [1, 2, 3, 4, 5].shuffled
    ///
    /// - Returns: the array with its elements shuffled.
    func shuffled() -> [Element] {
        var array = self
        array.shuffle()
        return array
    }
}

// MARK: - Methods (Equatable)
public extension Array where Element: Equatable {
    
    /// 删除元素
    ///
    ///     [1, 2, 2, 3, 4, 5].remove(2) -> [1, 3, 4, 5]
    ///     ["h", "e", "l", "l", "o"].remove("l") -> ["h", "e", "o"]
    ///
    /// - Parameter item: item to remove.
    /// - 复杂度: O(n), n是数组的长度.
    @discardableResult
    mutating func remove(_ item: Element) -> Array {
        removeAll(where: { $0 == item })
        return self
    }
    
    /// 删除被包含在array数组中的所有元素.
    ///
    ///     [1, 2, 2, 3, 4, 5].removeAll(in: [2,5]) -> [1, 3, 4]
    ///     ["h", "e", "l", "l", "o"].removeAll(in: ["l", "h"]) -> ["e", "o"]
    ///
    /// - Parameter array: 要删除的数组.
    /// - 复杂度: O(m*n), n是self数组的长度，m是array数组的长度.
    @discardableResult
    mutating func removeAll(in array: [Element]) -> Array {
        guard !array.isEmpty else { return self }
        removeAll(where: { array.contains($0) })
        return self
    }
    
}

// MARK: - Subscript
public extension Array {
        
       /// Safely subscript Array within a half-open range.
       ///
       ///  [1, 2, 1, 4][safe: 1..<2] -> [2]
       ///  [1, 2, 1, 4][safe: -1..<100] -> [1, 2, 1, 4]
       ///  [1, 2, 1, 4][safe: 20..<110] -> []
       ///
       /// - Parameter range: Half-open range.
       subscript(safe range: Range<Int>) -> ArraySlice<Element> {
           guard !isEmpty else { return ArraySlice<Element>() }
           guard range.lowerBound < count else { return ArraySlice<Element>() }
           guard range.upperBound >= 0 else { return ArraySlice<Element>() }
           
           let lowerIndex = Swift.max(0, range.lowerBound)
           let upperIndex = Swift.min(count, range.upperBound)
           return self[lowerIndex..<upperIndex]
       }
       
       /// Safely subscript array within a closed range.
       ///
       ///  [1, 2, 1, 4][safe: 1..2] -> [2, 1]
       ///  [1, 2, 1, 4][safe: 1...100] -> [2, 1, 4]
       ///  [1, 2, 1, 4][safe: 20...110] -> []
       ///
       /// - Parameter range: Closed range.
       subscript(safe range: ClosedRange<Int>) -> ArraySlice<Element> {
           guard !isEmpty else { return ArraySlice<Element>() }
           guard range.lowerBound < count else { return ArraySlice<Element>() }
           guard range.upperBound >= 0 else { return ArraySlice<Element>() }
           
           let lowerIndex = Swift.max(0, range.lowerBound)
           let upperIndex = Swift.min(count - 1, range.upperBound)
            return self[lowerIndex...upperIndex]
       }
       
       /// Safely subscript array within a partial Range through.
       ///
       ///  [1, 2, 1, 4][safe: ...2] -> [1, 2, 1]
       ///  [1, 2, 1, 4][safe: ...100] -> [1, 2, 1, 4]
       ///  [1, 2, 1, 4][safe: ...(-1)] -> []
       ///
       /// - Parameter range: partial Range through
       subscript(safe range: PartialRangeThrough<Int>) -> ArraySlice<Element> {
           guard range.upperBound >= 0 else { return ArraySlice<Element>() }
           return self[safe: 0...range.upperBound]
       }
       
       /// Safely subscript array within a partial Range from.
       ///
       ///  [1, 2, 1, 4][safe: 1..] -> [2, 1, 4]
       ///  [1, 2, 1, 4][safe: 100...] -> []
       ///  [1, 2, 1, 4][safe: (-1)...] -> [1, 2, 1, 4]
       ///
       /// - Parameter range: partial Range from
       subscript(safe range: PartialRangeFrom<Int>) -> ArraySlice<Element> {
           guard range.lowerBound <= count - 1 else { return ArraySlice<Element>() }
           return self[safe: range.lowerBound...(count - 1)]
       }
       
       /// Safely subscript array within a partial Range up to.
       ///
       ///  [1, 2, 1, 4][safe: ..<2] -> [1, 2]
       ///  [1, 2, 1, 4][safe: ..<100] -> [1, 2, 1, 4]
       ///  [1, 2, 1, 4][safe: ..<(-1)] -> []
       ///
       /// - Parameter range: partial Range up to
       subscript(safe range: PartialRangeUpTo<Int>) -> ArraySlice<Element> {
           guard range.upperBound > 0 else { return ArraySlice<Element>() }
           return self[safe: 0..<range.upperBound]
       }
}

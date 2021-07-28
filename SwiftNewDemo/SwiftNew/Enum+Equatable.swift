//
//  Enum+Equatable.swift
//  SwiftNewDemo
//
//  Created by fangmengkai on 2021/7/6.
//  Copyright © 2021 Albert. All rights reserved.
//

import Foundation

public enum LottieLoopMode {
  /// Animation is played once then stops.
  case playOnce
  /// Animation will loop from beginning to end until stopped.
  case loop
  /// Animation will play forward, then backwards and loop until stopped.
  case autoReverse
  /// Animation will loop from beginning to end up to defined amount of times.
  case `repeat`(Float)
  /// Animation will play forward, then backwards a defined amount of times.
  case repeatBackwards(Float)
}

extension LottieLoopMode: Equatable {
  public static func == (lhs: LottieLoopMode, rhs: LottieLoopMode) -> Bool {
    switch (lhs, rhs) {
    case (.repeat(let lhsAmount), .repeat(let rhsAmount)),
         (.repeatBackwards(let lhsAmount), .repeatBackwards(let rhsAmount)):
      return lhsAmount == rhsAmount
    case (.playOnce, .playOnce),
         (.loop, .loop),
         (.autoReverse, .autoReverse):
      return true
    default:
      return false
    }
  }
}

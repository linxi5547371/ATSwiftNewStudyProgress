//
//  CustomStringInterpolation.swift
//  SwiftNewDemo
//
//  Created by Qing Class on 2019/11/6.
//  Copyright © 2019 Albert. All rights reserved.
//

import Foundation

//Swift5字符串插值
struct GitHubComment {
    var markdown: String
}

extension GitHubComment: ExpressibleByStringLiteral {
    init(stringLiteral value: String) {
        self.markdown = value
    }
}

extension GitHubComment: CustomStringConvertible {
    var description: String {
        return self.markdown
    }
}

extension GitHubComment: ExpressibleByStringInterpolation {
    
  struct StringInterpolation: StringInterpolationProtocol {
    var parts: [String]
    init(literalCapacity: Int, interpolationCount: Int) {
      self.parts = []
      // - literalCapacity 文本片段的字符数 (L)
      // - interpolationCount 插值片段数 (I)
      // 我们预计通常结构会是像 "LILILIL"
      // — e.g. "Hello \(world, .color(.blue))!" — 因此是 2n+1
      self.parts.reserveCapacity(2*interpolationCount + 1)
    }
    
    mutating func appendLiteral(_ literal: String) {
      self.parts.append(literal)
    }
    
    mutating func appendInterpolation(user name: String) {
      self.parts.append("[\(name)](https://github.com/\(name))")
    }
    
    mutating func appendInterpolation(issue number: Int) {
      self.parts.append("[#\(number)](issues/\(number))")
    }
  }
    
  init(stringInterpolation: StringInterpolation) {
    self.markdown = stringInterpolation.parts.joined()
  }
    
}

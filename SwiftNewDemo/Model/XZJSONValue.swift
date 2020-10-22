//
//  XZJSONValue.swift
//  SwiftNewDemo
//
//  Created by bjhl on 2020/9/23.
//  Copyright © 2020 Albert. All rights reserved.
//

import Foundation

public enum XZJSONValue {
    
    case null
    case string(String)
    case int(Int)
    case double(Double)
    case bool(Bool)
    case object([String: XZJSONValue])
    case array([XZJSONValue])
    
    public var rawValue: Any? {
        switch self {
        case .null:
            return nil
        case .string(let s):
            return s
        case .int(let i):
            return i
        case .double(let d):
            return d
        case .bool(let b):
            return b
        case .object(let o):
            return o.mapValues({ $0.rawValue })
        case .array(let a):
            return a.map({ $0.rawValue })
        }
    }

}

extension XZJSONValue: Decodable {

    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        
        if container.decodeNil() {
            self = .null
        } else if let value = try? container.decode(String.self) {
            self = .string(value)
        } else if let value = try? container.decode(Int.self) {
            self = .int(value)
        } else if let value = try? container.decode(Double.self) {
            self = .double(value)
        } else if let value = try? container.decode(Bool.self) {
            self = .bool(value)
        } else if let value = try? container.decode([String: XZJSONValue].self) {
            self = .object(value)
        } else if let value = try? container.decode([XZJSONValue].self) {
            self = .array(value)
        } else {
            throw DecodingError.typeMismatch(XZJSONValue.self, DecodingError.Context(codingPath: container.codingPath, debugDescription: "Not a JSON"))
        }
    }
    
}

extension XZJSONValue: Encodable {

    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        
        switch self {
        case .null:
            try container.encodeNil()
        case .string(let s):
            try container.encode(s)
        case .int(let i):
            try container.encode(i)
        case .double(let d):
            try container.encode(d)
        case .bool(let b):
            try container.encode(b)
        case .object(let o):
            try container.encode(o)
        case .array(let a):
            try container.encode(a)
        }
    }
    
}

//extension XZJSONValue: YTCodableBuiltInType {
//
//    public init() {
//        self = .string("")
//    }
//
//}

//
//  FileManager+Extensions.swift
//  XZKit
//
//  Created by binluo on 2019/12/24.
//

#if canImport(Foundation)

import Foundation

public extension FileManager {
    
    /// Sandbox directory url
    static let sandboxDirectoryURL = URL(fileURLWithPath: NSHomeDirectory())
    
    /// Document directory url
    static let documentDirectoryURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
    
    /// library directory url
    static let libraryDirectoryURL = FileManager.default.urls(for: .libraryDirectory, in: .userDomainMask).first!
    
    /// cache directory url
    static let cachesDirectoryURL = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first!
    
    /// temp directory url
    static let tempDirectoryURL = URL(fileURLWithPath: NSTemporaryDirectory()).resolvingSymlinksInPath()
    
}

public extension FileManager {
    
    /// 创建临时文件路径，保证不重复
    /// - Parameters:
    ///   - prefix: 文件名前缀
    ///   - suffix: 文件名后缀
    ///   - subdirectory: 子目录
    func makeTempFile(prefix: String? = nil, suffix: String? = nil, subdirectory: String? = nil)
        -> URL {
            let basename = prefix ?? UUID().uuidString
            let suffix = suffix ?? ""
            var temporaryDirectory = self.temporaryDirectory
            if let subdirectory = subdirectory {
                temporaryDirectory = temporaryDirectory.appendingPathComponent(subdirectory, isDirectory: true)
                try? createDirectory(at: temporaryDirectory, withIntermediateDirectories: true)
            }
            
            var counter = 0
            var createdFile: URL? = nil
            repeat {
                let fileName = counter == 0 ? "\(basename)\(suffix)" : "\(basename)_\(counter)\(suffix)"
                createdFile = temporaryDirectory
                    .appendingPathComponent(fileName, isDirectory: false)
                counter += 1
            } while fileExists(atPath: createdFile!.path)
            return createdFile!
    }
    
}

#endif

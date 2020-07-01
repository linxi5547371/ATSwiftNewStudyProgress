//
//  URL+Extensions.swift
//  XZKit
//
//  Created by binluo on 2019/12/23.
//

#if canImport(Foundation)

import Foundation
import UIKit

// MARK: - Query Parameters
public extension URL {
        
    /// Dictionary of the URL's query parameters
    ///
    ///     let url = URL(string: "https://google.com?key=xzkit&name=test")!
    ///     url.queryParameters() // ["key": "xzkit", "name": "test"]
    ///
    /// - Returns: URL with appending given query parameters.
    func queryParameters() -> [String: String]? {
        guard let components = URLComponents(url: self, resolvingAgainstBaseURL: false), let queryItems = components.queryItems else { return nil }

        var items: [String: String] = [:]
        for queryItem in queryItems {
            items[queryItem.name] = queryItem.value
        }
        return items
    }

    /// URL with appending query parameters.
    ///
    ///     let url = URL(string: "https://google.com")!
    ///     let param = ["q": "Swifter Swift"]
    ///     url.appendingQueryParameters(params) // "https://google.com?q=Swifter%20Swift"
    ///
    /// - Parameter parameters: parameters dictionary.
    /// - Returns: URL with appending given query parameters.
    
    func appendingQueryParameters(_ parameters: [String: String]) -> URL {
        var urlComponents = URLComponents(url: self, resolvingAgainstBaseURL: true)!
        var items = urlComponents.queryItems ?? []
        for (key, value) in parameters {
            if items.contains(where: { $0.name == key }) {
                continue
            }
            items.append(URLQueryItem(name: key, value: value))
        }
        urlComponents.queryItems = items
        return urlComponents.url!
    }

    /// Append query parameters to URL.
    ///
    ///     var url = URL(string: "https://google.com")!
    ///     let param = ["q": "Swifter Swift"]
    ///     url.appendQueryParameters(params)
    ///     print(url) // "https://google.com?q=Swifter%20Swift"
    ///
    /// - Parameter parameters: parameters dictionary.
    @discardableResult
    mutating func appendQueryParameters(_ parameters: [String: String]) -> URL {
        self = appendingQueryParameters(parameters)
        return self
    }
    
    /// URL with removing query parameters
    ///
    ///     var url = URL(string: "https://google.com?key=xzkit&name=test")!
    ///     url = url.removingQueryParameters(keys: ["key"])
    ///     print(url) // https://google.com?name=test
    ///
    /// - Parameter keys: keys to remove
    func removingQueryParameters(keys: [String]) -> URL {
        var urlComponents = URLComponents(url: self, resolvingAgainstBaseURL: true)!
        var items = urlComponents.queryItems ?? []
        items.removeAll(where: { keys.contains($0.name) })
        urlComponents.queryItems = items
        return urlComponents.url!
    }
    
    /// Remove paramters with keys
    ///
    ///     var url = URL(string: "https://google.com?key=xzkit&name=test")!
    ///     url.removeQueryParameters(keys: ["key"])
    ///     print(url) // https://google.com?name=test
    ///
    /// - Parameter keys: keys to remove
    @discardableResult
    mutating func removeQueryParameters(keys: [String]) -> URL {
        self = removingQueryParameters(keys: keys)
        return self
    }

    /// Get value of a query key.
    ///
    ///     var url = URL(string: "https://google.com?code=12345")!
    ///     let value = url.queryValue(for: "code")
    ///     print(value) // "12345"
    ///
    /// - Parameter key: The key of a query value.
    func queryValue(for key: String) -> String? {
        return URLComponents(string: absoluteString)?
            .queryItems?
            .first(where: { $0.name == key })?
            .value
    }

}

// MARK: - Relative path
public extension URL {
    
    /// Initializes a newly created file URL referencing the local file or directory at path, relative to a base URL
    ///
    /// init(fileURLWithPath: isDirectory: relativeTo:) 在iOS9以上才可使用，此方法兼容所有系统版本
    ///
    /// - Parameters:
    ///   - relativeFilePath: relative local path
    ///   - isDirectory: file or directory
    ///   - base: base url
    init(relativeFilePath: String, isDirectory: Bool, relativeTo base: URL?) {
        if #available(iOS 9.0, *) {
            self.init(fileURLWithPath: relativeFilePath, isDirectory: isDirectory, relativeTo: base)
        } else {
            self.init(fileURLWithFileSystemRepresentation: relativeFilePath, isDirectory: isDirectory, relativeTo: base)
        }
    }
    
    /// Initializes a newly created file URL referencing the local file or directory at path, relative to a base URL
    /// - Parameters:
    ///   - relativeFilePath: relative local path
    ///   - base: base url
    init(relativeFilePath: String, relativeTo base: URL?) {
        self.init(relativeFilePath: relativeFilePath, isDirectory: false, relativeTo: base)
    }
    
    /// 通过沙盒相对路径创建URL
    ///
    /// - Parameters:
    ///   - sanboxRelativeFilePath: 沙盒相对路径
    ///   - isDirectory: 是否是目录
    init(sanboxRelativeFilePath: String, isDirectory: Bool) {
        self.init(relativeFilePath: sanboxRelativeFilePath, isDirectory: false, relativeTo: FileManager.sandboxDirectoryURL)
    }
    
    /// 通过沙盒相对路径创建URL
    /// - Parameters:
    /// - sanboxRelativeFilePath: 沙盒相对路径
    init(sanboxRelativeFilePath: String) {
        self.init(relativeFilePath: sanboxRelativeFilePath, relativeTo: FileManager.sandboxDirectoryURL)
    }
        
    /// relative file path to base url
    /// It is assumed that given URLs are absolute. Not relative
    ///
    ///     let u1 = URL(fileURLWithPath: "/Users/Mozart/Music/Nachtmusik.mp3")!
    ///     let u2 = URL(fileURLWithPath: "/Users/Mozart/Documents")!
    ///     u1.relativePath(from: u2)  // "../Music/Nachtmusik.mp3"
    ///
    /// - Parameter base: base url must be an absolute path to a directory
    func relativeFilePath(to base: URL) -> String? {
        guard self.isFileURL && base.isFileURL else { return nil }

        // Remove/replace "." and "..", make paths absolute
        let destComponents = self.standardizedFileURL.pathComponents
        let baseComponents = base.standardizedFileURL.pathComponents

        // Find number of common path components
        var i = 0
        while i < destComponents.count && i < baseComponents.count
            && destComponents[i] == baseComponents[i] {
                i += 1
        }

        // Build relative path
        var relComponents = Array(repeating: "..", count: baseComponents.count - i)
        relComponents.append(contentsOf: destComponents[i...])
        return relComponents.joined(separator: "/")
    }
    
    /// 沙盒相对路径
    /// 
    ///     let url = URL(sanboxRelativeFilePath: "test", isDirectory: false)
    ///     print(url.sanboxRelativeFilePath()) // "test"
    ///
    func sanboxRelativeFilePath() -> String? {
        return relativeFilePath(to: FileManager.sandboxDirectoryURL)
    }

}

// MARK: - Methds
public extension URL {
    
    /// Append path components to the URL
    ///
    ///     var url = URL(sanboxRelativeFilePath: "test", isDirectory: false)
    ///     url.appendPathComponents("1", "2")
    ///     print(url.sanboxRelativeFilePath()) // "test/1/2"
    ///
    /// - Parameter components: path components
    @discardableResult
    mutating func appendPathComponents(_ components: String...) -> URL {
        for component in components {
            appendPathComponent(component)
        }
        return self
    }
    
    /// URL by Appending path components
    ///
    ///     var url = URL(sanboxRelativeFilePath: "test", isDirectory: false)
    ///     url2 = url.appendingPathComponents("1", "2")
    ///     print(url2.sanboxRelativeFilePath()) // "test/1/2"
    ///
    /// - Parameter components: path components
    func appendingPathComponents(_ components: String...) -> URL {
        var url = self
        for component in components {
            url.appendPathComponent(component)
        }
        return url
    }

}

public extension URL {
    
    private static var imageMaxSize: Float { return 4096 }
    
    static func aliImageURL(with originURL: URL?, imageSize: CGSize, aliyunMode: aliYunMode?, fitScreenScale: Bool = false) -> URL? {
        guard let url = originURL, !url.isFileURL else {
            return originURL
        }
        // 已包含阿里云参数，不需要在添加
        if url.absoluteString.contains("x-oss-process=") {
            return url
        }
        var w: Float = 0
        var h: Float = 0
        if fitScreenScale {
            w = Float(imageSize.width * UIScreen.main.scale)
            h = Float(imageSize.height * UIScreen.main.scale)
        } else {
            w = Float(imageSize.width)
            h = Float(imageSize.height)
        }
        //单边缩放只判断宽
        if case .singleFit? = aliyunMode {
            if w > imageMaxSize {
                w = 4096
            }
        } else {
            //阿里云裁剪图片分辨率不能超过4096，否则失败，因此这里做长边等比例压缩
            if (w > imageMaxSize || h > imageMaxSize) {
                //长边等比例压缩
                if (w > h) {
                    h = imageMaxSize / w * h;
                    w = imageMaxSize;
                } else {
                    w = imageMaxSize / h * w;
                    h = imageMaxSize;
                }
            }
        }
        //参数含义参考阿里云oss图片服务文档：https://help.aliyun.com/document_detail/44688.html?spm=5176.doc44957.6.946.ynbQ26
        var param = ""
        
        switch aliyunMode {
        case .singleFit:
            param = "x-oss-process=image/resize,w_\(Int(w)),limit_0"
        case .longSideFit:
            param = "x-oss-process=image/resize,m_lfit,w_\(Int(w)),h_\(Int(h)),limit_0"
        case .shortSideFit:
            param = "x-oss-process=image/resize,m_mfit,w_\(Int(w)),h_\(Int(h)),limit_0"
        case .autoFill:
            param = "x-oss-process=image/resize,m_fill,w_\(Int(w)),h_\(Int(h)),limit_0"
        default:
            param = "x-oss-process=image/resize,m_lfit,w_\(Int(w)),h_\(Int(h)),limit_0"
        }
        param += "/auto-orient,1"
        
        let finalURL: URL?
        if url.absoluteString.range(of: "?") == nil {
            finalURL = URL(string: "\(url.absoluteString)?\(param)")
        } else {
            finalURL = URL(string: "\(url.absoluteString)&\(param)")
        }
        return finalURL
    }
    //关于长短边：长边是指原尺寸与目标尺寸的比值大的那条边，短边同理。例如原图为400px*200px，缩放为800px*100px，由于 400/800=0.5，200/100=2，0.5<2，所以在这个缩放中200那条是长边，400那条是短边。
    enum aliYunMode {
        //单边缩放 目前默认宽
        case singleFit
        //以长边为基准缩放
        case longSideFit
        //以短边为基准缩放
        case shortSideFit
        //自动裁剪
        case autoFill
    }
}
#endif

//
//  ATAppInfo.swift
//  SwiftNewDemo
//
//  Created by bjhl on 2020/6/18.
//  Copyright © 2020 Albert. All rights reserved.
//

import Foundation

public class YTAppInfo {
    private static let bundle: Bundle = .main
    
    /// App版本号
    public static let version: String = {
        return bundle.object(forInfoDictionaryKey: "CFBundleShortVersionString")
            as? String ?? ""
    }()
    
    /// App build号
    public static let build: String = {
        return bundle.object(forInfoDictionaryKey: "CFBundleVersion") as? String ?? ""
    }()
    
    /// App标识
    public static let bundleIdentifier: String = {
        if let applicationID: String = bundle.object(forInfoDictionaryKey: kCFBundleIdentifierKey as String) as? String {
            return applicationID
        }
        return ""
    }()
    
    /// App名称
    public static let name: String = {
        if let pName: String = bundle.object(forInfoDictionaryKey: kCFBundleNameKey as String) as? String {
            return pName
        }
        return ""
    }()
    
    /// App标识前缀
    public static let bundleSeedID: String = {
        let queryLoad: [String: AnyObject] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: "bundleSeedID" as AnyObject,
            kSecAttrService as String: "" as AnyObject,
            kSecReturnAttributes as String: kCFBooleanTrue
        ]
        
        var result : AnyObject?
        var status = withUnsafeMutablePointer(to: &result) {
            SecItemCopyMatching(queryLoad as CFDictionary, UnsafeMutablePointer($0))
        }
        
        if status == errSecItemNotFound {
            status = withUnsafeMutablePointer(to: &result) {
                SecItemAdd(queryLoad as CFDictionary, UnsafeMutablePointer($0))
            }
        }
        
        if status == noErr {
            if let resultDict = result as? [String: Any], let accessGroup = resultDict[kSecAttrAccessGroup as String] as? String {
                let components = accessGroup.components(separatedBy: ".")
                return components.first ?? ""
            } else {
                return ""
            }
        } else {
            Swift.assertionFailure("Error getting bundleSeedID from Keychain")
            return ""
        }
    }()

}

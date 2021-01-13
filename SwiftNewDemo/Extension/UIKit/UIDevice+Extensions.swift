//
//  UIDevice+Extensions.swift
//  SwiftNewDemo
//
//  Created by bjhl on 2020/11/24.
//  Copyright © 2020 Albert. All rights reserved.
//

import UIKit

public extension UIDevice {
    
    var isPad: Bool {
        return userInterfaceIdiom == .pad
    }
    
    var isPhone: Bool {
        return userInterfaceIdiom == .phone
    }

    // 判断手机屏幕是否是刘海屏
    var isNotchScreenPhoneStyle: Bool {
        if UIDevice.current.userInterfaceIdiom == .phone {
            if UIApplication.shared.safeAreaBottomHeight > 0 {
                return true
            } else {
                return false
            }
        } else {
            return false
        }
    }
    
    /// 设备型号字符串，标识设备类型，比如iPhone8,1对应iPhone 6
    /// - Returns: 设备型号字符串
    func hardwareModel() -> String {
        var size = 0
        sysctlbyname("hw.machine", nil, &size, nil, 0)
        var machine = [CChar](repeating: 0,  count: Int(size))
        sysctlbyname("hw.machine", &machine, &size, nil, 0)
        return String(cString: machine)
    }
    
    /// 总内存
    /// - Returns: 总内存
    func totalMemory() -> Int {
        return getSysInfo(HW_PHYSMEM)
    }
    
    private func getSysInfo(_ typeSpecifier: Int32) -> Int {
        var name: [Int32] = [CTL_HW, typeSpecifier]
        var size: Int = 2
        sysctl(&name, 2, nil, &size, nil, 0)
        var results: Int = 0
        sysctl(&name, 2, &results, &size, nil, 0)
        return results
    }
    
    /// 总磁盘空间，单位字节
    /// - Returns: 总磁盘空间
    func totalDiskSpace() -> Float? {
        guard let attributes = try? FileManager.default.attributesOfFileSystem(forPath: NSHomeDirectory()) else {
            return nil
        }
        return attributes[FileAttributeKey.systemSize] as? Float
    }

    /// 剩余磁盘空间，单位字节
    /// - Returns: 剩余磁盘空间
    func freeDiskSpace() -> Float? {
        guard let attributes = try? FileManager.default.attributesOfFileSystem(forPath: NSHomeDirectory()) else {
            return nil
        }
        return attributes[FileAttributeKey.systemFreeSize] as? Float
    }
    
}

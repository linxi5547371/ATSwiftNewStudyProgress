//
//  UIDevice+Extension.swift
//  XZKit
//
//  Created by bjhl on 2020/6/2.
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

public extension UIDevice {
    static let iPhoneSE: DeviceInfo = .iPhoneSE
    static let iPhone6s: DeviceInfo = .iPhone6s
    static let iPhone6P: DeviceInfo = .iPhone6P
    static let iPhoneX: DeviceInfo = .iPhoneX
    static let iPhoneXSMax: DeviceInfo = .iPhoneXSMax
    static let iPad9_7: DeviceInfo = .iPad9_7 // iPad 9.7-inch
    static let iPad10_5: DeviceInfo = .iPad10_5 // iPad 10.5-inch
    static let iPad12_9: DeviceInfo = .iPad12_9 // iPad 12.9-inch
    
    enum DeviceInfo {
        case iPhoneSE
        case iPhone6s
        case iPhone6P
        case iPhoneX
        case iPhoneXSMax
        /// iPad 9.7-inch
        case iPad9_7
        /// iPad 10.5-inch
        case iPad10_5
        /// iPad 12.9-inch
        case iPad12_9
        
        public var screenWidth: CGFloat {
            switch self {
            /// iPhone -SE -5s -5c -5
            case .iPhoneSE:
                return 320
            /// iPhone -6s -7s -8s -6 -7 -8
            case .iPhone6s, .iPhoneX:
                return 375
            /// iPhone -6P -7P -8P -XR -XSMax
            case .iPhone6P, .iPhoneXSMax:
                return 414
            case .iPad9_7:
                return 768
            case .iPad10_5:
                return 834
            case .iPad12_9:
                return 1024
            }
        }
        
        public var screenHeight: CGFloat {
            switch self {
            /// iPhone -SE -5s -5c -5
            case .iPhoneSE:
                return 568
            /// iPhone -6s -7s -8s -6 -7 -8 -X -XS
            case .iPhone6s:
                return 667
            /// iPhone -6P -7P -8P
            case .iPhone6P:
                return 736
            /// iPhone -X -XS
            case .iPhoneX:
                return 812
            /// -XR -XSMax
            case .iPhoneXSMax:
                return 896
            case .iPad9_7:
                return 1024
            case .iPad10_5:
                return 1112
            case .iPad12_9:
                return 1366
            }
        }
    }
}

extension UIDevice {
    func getDeviceName() -> String {
        let result = hardwareModel()
        
        switch result {
        // iPhone
        case "iPhone1,1": return "iPhone 2G"
        case "iPhone1,2": return "iPhone 3G"
        case "iPhone2,1": return "iPhone 3GS"
        case "iPhone3,1", "iPhone3,2", "iPhone3,3":  return "iPhone 4"
        case "iPhone4,1":  return "iPhone 4s"
        case "iPhone5,1":  return "iPhone 5"
        case "iPhone5,2":  return "iPhone 5"
        case "iPhone5,3", "iPhone5,4":  return "iPhone 5c"
        case "iPhone6,1", "iPhone6,2":  return "iPhone 5s"
        case "iPhone7,2":  return "iPhone 6"
        case "iPhone7,1":  return "iPhone 6 Plus"
        case "iPhone8,1":  return "iPhone 6s"
        case "iPhone8,2":  return "iPhone 6s Plus"
        case "iPhone8,4":  return "iPhone SE"
        case "iPhone9,1", "iPhone9,3":  return "iPhone 7"
        case "iPhone9,2", "iPhone9,4":  return "iPhone 7 Plus"
        case "iPhone10,1", "iPhone10,4": return "iPhone 8"
        case "iPhone10,2", "iPhone10,5": return "iPhone 8 Plus"
        case "iPhone10,3", "iPhone10,6": return "iPhone X"
        case "iPhone11,2": return "iPhone XS"
        case "iPhone11,4", "iPhone11,6": return "iPhone XS Max"
        case "iPhone11,8": return "iPhone XR"
        case "iPhone12,1": return "iPhone 11"
        case "iPhone12,3": return "iPhone 11 Pro"
        case "iPhone12,5": return "iPhone 11 Pro Max"
        case "iPhone12,8": return "iPhone SE2"
        case "iPhone13,1": return "iPhone 12 mini"
        case "iPhone13,2": return "iPhone 12"
        case "iPhone13,3": return "iPhone 12 Pro"
        case "iPhone13,4": return "iPhone 12 Pro Max"
            
        // iPod
        case "iPod1,1":  return "iPod Touch 1"
        case "iPod2,1":  return "iPod Touch 2"
        case "iPod3,1":  return "iPod Touch 3"
        case "iPod4,1":  return "iPod Touch 4"
        case "iPod5,1":  return "iPod Touch 5"
        case "iPod7,1":  return "iPod Touch 6"
        case "iPod9,1":  return "iPod Touch 7"
            
        // iPad
        case "iPad1,1": return "iPad"
        case "iPad1,2": return "iPad 3G"
        case "iPad2,1", "iPad2,2", "iPad2,3", "iPad2,4":  return "iPad 2"
        case "iPad2,5", "iPad2,6", "iPad2,7":  return "iPad Mini"
        case "iPad3,1", "iPad3,2", "iPad3,3":  return "iPad 3"
        case "iPad3,4", "iPad3,5", "iPad3,6":  return "iPad 4"
        case "iPad4,1", "iPad4,2", "iPad4,3":  return "iPad Air"
        case "iPad4,4", "iPad4,5", "iPad4,6":  return "iPad Mini 2"
        case "iPad4,7", "iPad4,8", "iPad4,9":  return "iPad Mini 3"
        case "iPad5,1", "iPad5,2":  return "iPad Mini 4"
        case "iPad5,3", "iPad5,4":  return "iPad Air 2"
        case "iPad6,3", "iPad6,4":  return "iPad Pro 9.7"
        case "iPad6,7", "iPad6,8":  return "iPad Pro 12.9"
        case "iPad6,11", "iPad6,12": return "iPad 5"
        case "iPad7,1", "iPad7,2": return "iPad Pro 12.9 inch 2nd"
        case "iPad7,3", "iPad7,4": return "iPad Pro 10.5 inch"
        case "iPad7,5", "iPad7,6": return "iPad 6th Gen"
        case "iPad8,1", "iPad8,2", "iPad8,3", "iPad8,4", "iPad8,5", "iPad8,6", "iPad8,7", "iPad8,8": return "iPad Pro 3rd Gen"
        case "iPad11,1","iPad11,2": return "iPad mini 5th Gen"
        case "iPad11,3", "iPad11,4": return "iPad Air 3rd Gen"
        case "i386", "x86_64":  return "Simulator"
            
        //Apple TV
        case "AppleTV2,1":  return "Apple TV 2"
        case "AppleTV3,1","AppleTV3,2":  return "Apple TV 3"
        case "AppleTV5,3":  return "Apple TV 4"
        default:
            return result
        }
    }
}


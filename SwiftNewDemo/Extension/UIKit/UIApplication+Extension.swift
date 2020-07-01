//
//  UIApplication+Extension.swift
//  SwiftNewDemo
//
//  Created by bjhl on 2020/6/5.
//  Copyright © 2020 Albert. All rights reserved.
//

#if canImport(UIKit)

import UIKit

extension UIApplication {
    
    /// 状态栏高度
    var statusBarHeight: CGFloat {
        return statusBarFrame.height
    }
    
    /// 底部安全区高度
    var safeAreaBottomHeight: CGFloat {
        if #available(iOS 13.0, *) {
            return UIApplication.shared.windows.first?.safeAreaInsets.bottom ?? 0
        } else {
            if #available(iOS 11.0, *) {
                return keyWindow?.safeAreaInsets.bottom ?? 0
            } else {
                return 0
            }
        }
        
    }
    
    class func topmostViewController() -> UIViewController? {
        guard let window = UIApplication.shared.delegate?.window else { return nil }

        var topmostViewController = window?.rootViewController
        while  topmostViewController?.presentedViewController != nil {
            topmostViewController = topmostViewController?.presentedViewController
        }
        if (topmostViewController is UITabBarController) {
            let tabBarController = topmostViewController as? UITabBarController
            topmostViewController = tabBarController?.selectedViewController
        }
        if (topmostViewController is UINavigationController) {
            let navigationController = topmostViewController as? UINavigationController
            topmostViewController = navigationController?.topViewController
        }
        return topmostViewController
    }
}

#endif


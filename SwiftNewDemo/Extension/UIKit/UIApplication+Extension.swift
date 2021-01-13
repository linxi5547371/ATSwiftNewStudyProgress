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

// 护眼模式
//extension UIApplication {
//    @Storage(XZStorageKey.isOnEyeShieldPatternKey, defaultValue: false)
//    private(set) static var isOnEyeShieldPattern: Bool
//
//    private(set) static var eyeShieldWindow: UIWindow?
//
//    static func showEyeShieldWindow() {
//        isOnEyeShieldPattern = true
//        let newWindow = UIWindow()
//        newWindow.isUserInteractionEnabled = false
//        newWindow.windowLevel = UIWindow.Level(2099.0)
//        newWindow.backgroundColor = UIColor(rgbHex: 0xFFBF1C).withAlphaComponent(0.2)
//        newWindow.isHidden = false
//        let vc = XZEyeShieldViewController()
//        vc.view.backgroundColor = .clear
//        newWindow.rootViewController = vc
//        eyeShieldWindow = newWindow
//    }
//
//    static func hideEyeShieldWindow() {
//        isOnEyeShieldPattern = false
//        eyeShieldWindow?.isHidden = true
//        eyeShieldWindow = nil
//    }
//
//    fileprivate class XZEyeShieldViewController: XZBaseController {
//
//        override var preferredStatusBarStyle: UIStatusBarStyle {
//            return .default
//        }
//
//        override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
//            return .portrait
//        }
//
//        override func viewDidLoad() {
//            super.viewDidLoad()
//
//        }
//    }
//}

#endif


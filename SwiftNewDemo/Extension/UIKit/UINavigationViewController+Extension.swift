//
//  UINavigationViewController+Extension.swift
//  SwiftNewDemo
//
//  Created by bjhl on 2020/5/29.
//  Copyright © 2020 Albert. All rights reserved.
//

#if canImport(UIKit)

import UIKit

// MARK: - Methods
public extension UINavigationController {
    
    /// Pop view controller
    /// - Parameters:
    ///   - animated: 是否动画
    ///   - completion: 完成回调
    func popViewController(animated: Bool = true, completion: (() -> Void)? = nil) {
        CATransaction.begin()
        CATransaction.setCompletionBlock(completion)
        popViewController(animated: animated)
        CATransaction.commit()
    }
        
    /// Push view controller
    /// - Parameters:
    ///   - viewController: 想要push的viewController
    ///   - animated: 是否动画
    ///   - completion: 完成回调
    func pushViewController(_ viewController: UIViewController, animated: Bool = true, completion: (() -> Void)? = nil) {
        CATransaction.begin()
        CATransaction.setCompletionBlock(completion)
        pushViewController(viewController, animated: animated)
        CATransaction.commit()
    }

    func setViewControllers(_ viewControllers: [UIViewController], animated: Bool = true, completion: (() -> Void)? = nil) {
        CATransaction.begin()
        CATransaction.setCompletionBlock(completion)
        setViewControllers(viewControllers, animated: animated)
        CATransaction.commit()
    }
    
}

#endif

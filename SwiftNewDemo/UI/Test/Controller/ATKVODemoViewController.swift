//
//  ATKVODemoViewController.swift
//  SwiftNewDemo
//
//  Created by bjhl on 2020/7/17.
//  Copyright © 2020 Albert. All rights reserved.
//

import UIKit

class ATKVODemoViewController: UIViewController {
    var model = ATKVOModel()
    var observer: NSKeyValueObservation?
    
    deinit {
        model.removeObserver(self, forKeyPath: "name")
        ATKVOModel.removeObserver(self, forKeyPath: "ATKVOModel")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        // 添加观察者（self需要继承NSObjetc）
        model.addObserver(self, forKeyPath: "name", options: [.new, .old], context: nil)
        ATKVOModel.addObserver(self, forKeyPath: "otherName", options: [.new, .old], context: nil)
//        observer = model.observe(\ATKVOModel.name, options: [.old, .new]) { (model, change) in
//            if let old = change.oldValue {
//                print(old)
//            }
//
//            if let new = change.newValue {
//                print(new)
//            }
//        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        model.name = "Albert"
    }
    
    // MARK: - Action
    
    // MARK: - KVO
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        print(keyPath)
        if let old = change?[NSKeyValueChangeKey.oldKey] {
            print(old)
        }
        
        if let new = change?[NSKeyValueChangeKey.newKey] {
            print(new)
        }
    }
}

class ATKVOModel: NSObject {
    // dynamic需要的加上@objc
    @objc dynamic var name: String = ""
}

@IBDesignable
class ATNormalView: UIView {
    @IBInspectable var bgColor: UIColor = .white {
        didSet {
            backgroundColor = bgColor
        }
    }
}

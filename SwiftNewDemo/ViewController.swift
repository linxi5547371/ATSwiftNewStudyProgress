//
//  ViewController.swift
//  SwiftNewDemo
//
//  Created by Qing Class on 2019/10/21.
//  Copyright © 2019 Albert. All rights reserved.
//

import UIKit

//Swift新特性Demo

class ViewController: UIViewController {
    static let animal = Animal()
    @ModelType(ViewController.animal) var modelType: Animal.ModelType?
    let normalClosure: (() -> Void)? = {
        print("This is normalClosure")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        defer {
            print("viewDidLoad")
        }
        
//        ATLog.log(type: .message, message: "message")
//        ATLog.log(type: .warning, message: "warning")
//        ATLog.log(type: .error, message: "error")
        
//        jsonDynamicTest()
//        customSequenceTest()
//        customStringTest()
//        print(optionsTest())
//        getColorWithRGBTest()
//        testPropertyWrapper()
//        computeExecuteTime()
//        addMethodByDynamic()
//        testGreatInt()
        testUnknownEnumerate()
    
        autoreleasepool { // 出了作用域就会被释放
            let str = "123"
        }
        
    }
    
    func jsonDynamicTest() {
        let p = People(name: "Albert")
        print(People(name: "Albert").city)
        let peopleKeyPath = \People.name
        let value = p[keyPath: peopleKeyPath] // KeyPath

        print(p.value(forKeyPath: "name"))
        print(value)
        
        let singer: KeyValuePairs = ["1": "2"]
        
        print(People(name: "Albert")(333, 122))
        print(p(base:1, 2, 3))
        
        let jsons = JSON.arrayValue([JSON.dictionaryValue(["name" : JSON.stringValue("222")]), JSON.stringValue("111")])
        print(jsons[0]?.name)
    }
    
    func customSequenceTest() {
        var manager = SeasonManager(season: Season.spring)
        
        for sea in manager {
            print("done")
        }
    }

    func customStringTest() {
//        let comment: GitHubComment = """
//        See \(issue: 10) where \(user: "alisoftware") explains the steps to reproduce.
//        """
                let comment: GitHubComment = "12300\(issue: 1) 777\(user: "ppp")"
                print(comment.description)
    }
    
    func optionsTest() -> String {
        let type: StringJoinType = .joinBase
        var result = ""
        if (type.contains(.joinName)) {
            result.append("Albert")
        }
        
        if (type.contains(.joinAge)) {
            result.append("12")
        }
        
        if (type.contains(.joinAddress)) {
            result.append("github")
        }
        
        if (type.contains(.joinJob)) {
            result.append("iOS")
        }
        return result
    }
    
    func getColorWithRGBTest() {
        self.view.backgroundColor = UIColor.getColorWithRGB(RGBValue: 0x00FFFF)
//        self.view.backgroundColor = UIColor.getColorWithRGBStr(RGBStr: "00ffff") // String(100, radix: 16)
    }
    
    func testPropertyWrapper() {
        self.modelType = Animal.AnimalType.bird
    }
    
    //计算函数执行时间
    func computeExecuteTime() {
        let start = CFAbsoluteTimeGetCurrent()
        Thread.sleep(forTimeInterval: 1.0)
        let finish = CFAbsoluteTimeGetCurrent()
        print("total time \(finish - start)")
    }
    
    //可变参数函数
    func getNumberTotal(numbers: Int...) -> Int {
        var result = 0
        for num in numbers {
            result += num
        }
        return result
    }
    
    //给类动态添加方法
    func addMethodByDynamic() {
        People.dynamicChangeInstanceMethod(selector: #selector(People.logName), action: nil)
        People.dynamicChangeClassMethod(selector: #selector(People.decInfo), action: nil)
        let p = People(name: "Albert")
        p.logName()
        p.perform(#selector(People.logName))
        People.decInfo()
        
        let pp = People(name: "Albert1111")
        pp.dynamicCreatClass(selector: #selector(People.logName), action: nil)
        pp.logName()
    }
    
    func testGreatInt() {
        ATGreatInt().setData()
    }
    
    func customDebugGuide() {
//        let bigNum: Int64 = 2
//        #if DEBUG
//        #sourceLocation(file: "123", line: 38)
//        #error("This code is incomplete")
//        #endif
//        if bigNum > 0 {
//            fatalError( "This code is incomplete. Please fix before release.")
//        }
    }
    
    func testUnknownEnumerate() {
        let type = WeekDayType.tuesday
        print(type.getDescription())
    }
}

//调用为声明的变量和方法
@dynamicMemberLookup
@dynamicCallable
class People: NSObject {
    var name: String
    
    override init() {
        self.name = ""
        super.init()
    }
    
    init(name: String) {
        self.name = name
    }
    
    //people.city
    subscript(dynamicMember member: String) -> String {
        return "123"
    }
    
    //people(["1", "2"])
    func dynamicallyCall(withArguments args: [String]) -> String {
        return args.first ?? ""
    }
    
    //people([2, 3])
    func dynamicallyCall(withArguments args: [Int]) -> Int {
        return args.first ?? 0
    }
    
    //people(base: 1, 2, 3)
    func dynamicallyCall(withKeywordArguments args: KeyValuePairs<String, Int>) -> Int {
        return 100
    }
    
    @objc dynamic func logName() {
        print(name)
    }
    
    @objc dynamic class func decInfo() {
        print("People")
    }
}

@dynamicCallable
struct Dog {
    func dynamicallyCall(withArguments args: [String]) -> String {
        return args.first ?? ""
    }
    
    func dynamicallyCall(withArguments args: [Int]) -> Int {
        return args.first ?? 0
    }
    
    func dynamicallyCall(withKeywordArguments args: KeyValuePairs<String, Int>) -> Int {
        return 100
    }
}

extension NSObject {
    //动态创建类并重写方法
    func dynamicCreatClass(selector: Selector, action: (() -> ())?) {
        // 创建类的类名
        let classFullName = "ATDynamic_\(self.classForCoder.description()))"
        // 获取原来类
        let originalClass = type(of: self)
        
        // 判断这个类是否已经存在
        if let dynamicClass = objc_allocateClassPair(originalClass, classFullName, 0) {
            // 动态的创建这个类
            objc_registerClassPair(dynamicClass)
            // 将原对象修改成新的类型
            object_setClass(self, dynamicClass)
            
            // 实现新的方法
            let printName: @convention(block) (Any?) -> () = { nullSelf in
                guard let _ = nullSelf else { return }
                // 获取原来类中方法的Imp
                let originalImp = class_getMethodImplementation(originalClass, selector)
                // 定义一个方法类型与msgSend的参数类似 第一个参数是对象，第二个参数是SEL 之后是函数的参数
                typealias IMPCType = @convention(c) (Any, Selector) -> ()
                // 将imp强转为兼容c的函数指针
                let originalPrintName = unsafeBitCast(originalImp, to: IMPCType.self)
                // 执行原方法 类似super.originFuncion()
                originalPrintName(self, selector)
                print("Dynamic")
                // 你想要做的事
                action?()
            }
            // 通过一个block创建一个指向它的imp
            let implementation = imp_implementationWithBlock(printName)
            // 将方法加入到类的方法列表中
            class_addMethod(dynamicClass, selector, implementation, "v@:")
        } else if let dynamicClass = NSClassFromString(classFullName) {
            // 如果类已经存在则直接转换
            object_setClass(self, dynamicClass)
        }
    }
    
    //替换实例方法
    class func dynamicChangeInstanceMethod(selector: Selector, action: (() -> Void)?) {
        // 获取实例方法的IMP
        let method = class_getInstanceMethod(self, selector)
        if let method = method, self.init().responds(to: selector) {
            // 获取原来方法的IMP
            let oldImp = method_getImplementation(method)
            // 定义一个方法类型与msgSend的参数类似 第一个参数是对象，第二个参数是SEL 之后是函数的参数
            typealias IMPCType = @convention(c) (Any, Selector) -> Void
            // 将imp强转为兼容c的函数指针
            let oldImpBlock = unsafeBitCast(oldImp, to: IMPCType.self)
            // 实现新的方法
            let newFuncion: @convention(block) (Any?) -> Void = {
                (sself) in
                // 执行原来的方法类似调用super
                oldImpBlock(sself, selector)
                print("dynamicChangeInstanceMethod")
                // 你要做的事
                action?()
            }
            let imp = imp_implementationWithBlock(newFuncion)
            // 用新方法替换旧方法
            method_setImplementation(method, imp)
        }
    }
    
    //替换类方法
    class func dynamicChangeClassMethod(selector: Selector, action: (() -> Void)?) {
        // 获取类方法的IMP
        let method = class_getClassMethod(self, selector)
        if let method = method, self.responds(to: selector) {
            // 获取原来方法的IMP
            let oldImp = method_getImplementation(method)
            // 定义一个方法类型与msgSend的参数类似 第一个参数是对象，第二个参数是SEL 之后是函数的参数
            typealias IMPCType = @convention(c) (Any, Selector) -> Void
            // 将imp强转为兼容c的函数指针
            let oldImpBlock = unsafeBitCast(oldImp, to: IMPCType.self)
            // 实现新的方法
            let newFuncion: @convention(block) (Any) -> Void = {
                (sself) in
                // 执行原来的方法类似调用super
                oldImpBlock(sself, selector)
                print("dynamicChangeClassMethod")
                // 你要做的事
                action?()
            }
            let imp = imp_implementationWithBlock(newFuncion)
            // 用新方法替换旧方法
            method_setImplementation(method, imp)
        }
    }
}


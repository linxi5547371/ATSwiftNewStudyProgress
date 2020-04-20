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
    @ModelType(ViewController.animal) var type: Animal.ModelType?

    override func viewDidLoad() {
        super.viewDidLoad()
        defer {
            print("viewDidLoad")
        }
        
//        jsonDynamicTest()
//        customSequenceTest()
//        customStringTest()
        print(optionsTest())
        getColorWithRGBTest()
        testPropertyWrapper()
        
    }
    
    func jsonDynamicTest() {
        let p = People(name: "Albert")
        print(People(name: "Albert").city)
        let peopleKeyPath = \People.name
        let value = p[keyPath: peopleKeyPath] // TODO: 反斜杠是KeyPath调用吗？

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
//        self.view.backgroundColor = UIColor.getColorWithRGBStr(RGBStr: "00ffff")
    }
    
    func testPropertyWrapper() {
        self.type = Animal.AnimalType.bird
    }
}

//调用为声明的变量和方法
@dynamicMemberLookup
@dynamicCallable
class People: NSObject {
    @objc var name: String
    
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


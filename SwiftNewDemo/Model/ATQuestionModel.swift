//
//  ATQuestionModel.swift
//  SwiftNewDemo
//
//  Created by bjhl on 2020/4/22.
//  Copyright © 2020 Albert. All rights reserved.
//

protocol AnwserSort {
    
}

extension String: AnwserSort {}
extension Int: AnwserSort {}

enum ATQuestionAnwserSort {
    case single(AnwserSort)
    case mutable([AnwserSort])
    
    func test() {
        switch self {
        case .single(let anwser):
            if anwser is Int {
                //是数字类型结果
            } else if anwser is String {
                //是文字类型结果
            }
        case .mutable(let anwsers):
            for anwser in anwsers {
                if anwser is Int {
                    //是数字类型结果
                } else if anwser is String {
                    //是文字类型结果
                }
            }
        }
        
        if case .single(let anwser) = self {
            if anwser is Int {
                //是数字类型结果
            } else if anwser is String {
                //是文字类型结果
            }
        }
    }
}

protocol ATQuestionFormat {
    associatedtype ResultType: Equatable
    
    var questionContent: String { get set }
    var questionResult: ResultType { get set }
    
    func getResult() -> ResultType
    
    func judgeResult(_ result: ResultType) -> Bool
}

extension ATQuestionFormat {
    func getResult() -> ResultType {
         return questionResult
    }
    
    func judgeResult(_ result: ResultType) -> Bool {
        return result == questionResult
    }
}

struct ATCountQuestionModel: ATQuestionFormat {
    typealias ResultType = Int
    
    private var _questionContent = ""
    private var _questionResult: ResultType = 80
    
    var questionContent: String {
        get { return _questionContent }
        set { _questionContent = newValue }
    }
    var questionResult: ResultType {
        get { return _questionResult }
        set { _questionResult = newValue }
    }
}

struct ATStringQuestionModel: ATQuestionFormat {
    typealias ResultType = String
    
    private var _questionContent = ""
    private var _questionResult: ResultType = "80"
    
    var questionContent: String {
        get { return _questionContent }
        set { _questionContent = newValue }
    }
    var questionResult: ResultType {
        get { return _questionResult }
        set { _questionResult = newValue }
    }
}

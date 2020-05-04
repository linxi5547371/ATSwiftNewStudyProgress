//
//  propertyWrapper.swift
//  SwiftNewDemo
//
//  Created by bjhl on 2020/4/20.
//  Copyright © 2020 Albert. All rights reserved.
//

import Foundation

protocol ModelDelegate {
    associatedtype ModelType: Equatable
    var modelType: ModelType { get set }
    func getType() -> ModelType
}

class Animal: ModelDelegate {
    var modelType: AnimalType = .bird
    typealias ModelType = AnimalType
    
    enum AnimalType: Int {
        case bird = 0
        case tiger
        case none = -1
    }
    
    func getType() -> AnimalType {
        return modelType
    }
    
}

//属性包装器  通过公用get set方法减少代码
@propertyWrapper
struct ModelType<T: ModelDelegate> {
    var model: T!
    var wrappedValue: T.ModelType! {
        get {
            return model.getType()
        }
        nonmutating set {
            if (newValue == model.modelType) {
                print("isSame")
            } else {
                print("Not Same")
            }
        }
    }
    
    init(_ model: T) {
        self.model = model
    }
}

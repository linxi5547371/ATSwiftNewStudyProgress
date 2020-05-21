//
//  BaseJsonModel.swift
//  SwiftNewDemo
//
//  Created by bjhl on 2020/5/21.
//  Copyright © 2020 Albert. All rights reserved.
//

import Foundation

protocol BaseJsonModelDelegate: Codable {
    
}

struct Car: Codable {
    static let jsonStr = """
{
    "image":"http://test-xiaozao.gsxcdn.com/upload/20200504/9d33b7d474c5b285dcdef4c84f946ba9.png",
    "name": "Albert"
    }
"""
    
    var name: String?
    var image: URL?
}

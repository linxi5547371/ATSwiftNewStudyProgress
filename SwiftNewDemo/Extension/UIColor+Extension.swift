//
//  UIColor+Extension.swift
//  SwiftNewDemo
//
//  Created by Qing Class on 2019/12/12.
//  Copyright © 2019 Albert. All rights reserved.
//

import UIKit

extension UIColor {
    static func getColorWithRGB(RGBValue: UInt64) -> UIColor {
        let redValue = (RGBValue & 0xFF0000) >> 16
        let greenValue = (RGBValue & 0xFF00) >> 8
        let blueValue = (RGBValue & 0xFF)
        
        return UIColor.init(red: CGFloat(redValue) / 255, green: CGFloat(greenValue) / 255, blue: CGFloat(blueValue) / 255, alpha: 1.0)
    }
    
    static func getColorWithRGBStr(RGBStr: String) -> UIColor {
        return getColorWithRGB(RGBValue: RGBStr.hexStringToInt())
    }
}

//
//  UIImage+Extension.swift
//  SwiftNewDemo
//
//  Created by Qing Class on 2019/12/5.
//  Copyright © 2019 Albert. All rights reserved.
//

import UIKit

extension UIImage {
    //根据图片大小绘制图片节省内存空间
    static func getImageWithSize(size: CGSize, imageURL: URL) -> UIImage? {
        //Plan1 无效
//        let imageSource = CGImageSourceCreateWithURL(imageURL! as CFURL, nil)!
//        let option = [kCGImageSourceThumbnailMaxPixelSize: 100,
//                      kCGImageSourceCreateThumbnailFromImageAlways: true] as [CFString : Any]
//        if let scaledImage = CGImageSourceCreateImageAtIndex(imageSource, 0, option as CFDictionary) {
//            return UIImage(cgImage: scaledImage)
//        } else {
//            return nil
//        }

        //Plan2
        guard let imageSource = CGImageSourceCreateWithURL(imageURL as NSURL, nil),
            let image = CGImageSourceCreateImageAtIndex(imageSource, 0, nil)
        else {
            return nil
        }
        let context = CGContext(data: nil,
                                width: Int(size.width),
                                height: Int(size.height),
                                bitsPerComponent: image.bitsPerComponent,
                                bytesPerRow: image.bytesPerRow,
                                space: image.colorSpace ?? CGColorSpace.sRGB as! CGColorSpace,
                                bitmapInfo: image.bitmapInfo.rawValue)
        context?.interpolationQuality = .high
//        context?.draw(image, in: CGRect(x: size.width / 4, y: size.height / 4, width: size.width / 2, height: size.height / 2))
        context?.draw(image, in: CGRect(x: 0, y: 0, width: size.width, height: size.height))
        guard let scaledImage = context?.makeImage() else { return nil }
        return UIImage(cgImage: scaledImage)
        //裁剪图片
//        let pp = scaledImage.cropping(to: CGRect(x: size.width / 4, y: size.height / 4, width: size.width / 2, height: size.height / 2))!
//        return UIImage(cgImage: pp)
        
//        UIGraphicsBeginImageContext(CGSize(width: size.width / 2, height: size.height / 2))
//        UIImage(cgImage: scaledImage).draw(at: CGPoint(x: -size.width / 4, y: -size.width / 4))
//        let pImage = UIGraphicsGetImageFromCurrentImageContext()
//        return pImage
        
        //Plan3
//        guard let image = UIImage(contentsOfFile: imageURL.path) else {
//            return nil
//        }
//
//        let renderer = UIGraphicsImageRenderer(size: size)
//        return renderer.image { (context) in
//            image.draw(in: CGRect(origin: .zero, size: size))
//        }
    }
    
    static func getImageWithSize(size: CGSize, imageData: Data) -> UIImage? {
        guard let imageSource = CGImageSourceCreateWithData(imageData as CFData, nil),
            let image = CGImageSourceCreateImageAtIndex(imageSource, 0, nil)
        else {
            return nil
        }
        let context = CGContext(data: nil,
                                width: Int(size.width),
                                height: Int(size.height),
                                bitsPerComponent: image.bitsPerComponent,
                                bytesPerRow: image.bytesPerRow,
                                space: image.colorSpace ?? CGColorSpace.sRGB as! CGColorSpace,
                                bitmapInfo: image.bitmapInfo.rawValue)
        context?.interpolationQuality = .high
//        context?.draw(image, in: CGRect(x: size.width / 4, y: size.height / 4, width: size.width / 2, height: size.height / 2))
        context?.draw(image, in: CGRect(x: 0, y: 0, width: size.width, height: size.height))
        guard let scaledImage = context?.makeImage() else { return nil }
        return UIImage(cgImage: scaledImage)
    }
}

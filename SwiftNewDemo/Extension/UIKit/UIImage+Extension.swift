//
//  UIImage+Extension.swift
//  SwiftNewDemo
//
//  Created by Qing Class on 2019/12/5.
//  Copyright © 2019 Albert. All rights reserved.
//

import UIKit

// 加载大图
extension UIImage {
    //根据图片大小绘制图片节省内存空间
    static func getImageWithSize(size: CGSize, imageURL: URL) -> UIImage? {
        //Plan1 无效
        let sourceoptions = [kCGImageSourceShouldCache: false] as CFDictionary
        let imageSource = CGImageSourceCreateWithURL(imageURL as CFURL, sourceoptions)!
        let options: [CFString: Any] = [
            kCGImageSourceCreateThumbnailFromImageIfAbsent: true,
            kCGImageSourceCreateThumbnailWithTransform: true,
            kCGImageSourceShouldCacheImmediately: true,
            kCGImageSourceThumbnailMaxPixelSize: max(size.width, size.height)
        ]
        if let scaledImage = CGImageSourceCreateThumbnailAtIndex(imageSource, 0, options as CFDictionary) {
            return UIImage(cgImage: scaledImage)
        } else {
            return nil
        }

        //Plan2
//        guard let imageSource = CGImageSourceCreateWithURL(imageURL as NSURL, nil),
//            let image = CGImageSourceCreateImageAtIndex(imageSource, 0, nil)
//        else {
//            return nil
//        }
//        let context = CGContext(data: nil,
//                                width: Int(size.width),
//                                height: Int(size.height),
//                                bitsPerComponent: image.bitsPerComponent,
//                                bytesPerRow: image.bytesPerRow,
//                                space: image.colorSpace ?? CGColorSpace.sRGB as! CGColorSpace,
//                                bitmapInfo: image.bitmapInfo.rawValue)
//        context?.interpolationQuality = .low
////        context?.draw(image, in: CGRect(x: size.width / 4, y: size.height / 4, width: size.width / 2, height: size.height / 2))
//        context?.draw(image, in: CGRect(x: 0, y: 0, width: size.width, height: size.height))
//        guard let scaledImage = context?.makeImage() else { return nil }
//        return UIImage(cgImage: scaledImage)
        
        //裁剪图片
//        let pp = scaledImage.cropping(to: CGRect(x: size.width / 4, y: size.height / 4, width: size.width / 2, height: size.height / 2))!
//        return UIImage(cgImage: pp)
        
//        UIGraphicsBeginImageContext(CGSize(width: size.width / 2, height: size.height / 2))
//        UIImage(cgImage: scaledImage).draw(at: CGPoint(x: -size.width / 4, y: -size.width / 4))
//        let pImage = UIGraphicsGetImageFromCurrentImageContext()
//        UIGraphicsEndImageContext()
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
//        guard let imageSource = CGImageSourceCreateWithData(imageData as CFData, nil),
//            let image = CGImageSourceCreateImageAtIndex(imageSource, 0, nil)
//        else {
//            return nil
//        }
//        let context = CGContext(data: nil,
//                                width: Int(size.width),
//                                height: Int(size.height),
//                                bitsPerComponent: image.bitsPerComponent,
//                                bytesPerRow: image.bytesPerRow,
//                                space: image.colorSpace ?? CGColorSpace.sRGB as! CGColorSpace,
//                                bitmapInfo: image.bitmapInfo.rawValue)
//        context?.interpolationQuality = .high
////        context?.draw(image, in: CGRect(x: size.width / 4, y: size.height / 4, width: size.width / 2, height: size.height / 2))
//        context?.draw(image, in: CGRect(x: 0, y: 0, width: size.width, height: size.height))
//        guard let scaledImage = context?.makeImage() else { return nil }
//        return UIImage(cgImage: scaledImage)
        
        let sourceoptions = [kCGImageSourceShouldCache: false] as CFDictionary
        guard let imageSource = CGImageSourceCreateWithData(imageData as CFData, sourceoptions) else { return nil }
        let options: [CFString: Any] = [
            kCGImageSourceCreateThumbnailFromImageAlways: true,
            kCGImageSourceCreateThumbnailFromImageIfAbsent: true,
            kCGImageSourceCreateThumbnailWithTransform: true,
            kCGImageSourceShouldCacheImmediately: true,
            kCGImageSourceThumbnailMaxPixelSize: max(size.width, size.height)
        ]
        if let scaledImage = CGImageSourceCreateThumbnailAtIndex(imageSource, 0, options as CFDictionary) {
            return UIImage(cgImage: scaledImage)
        } else {
            return nil
        }
    }
}

//截取屏幕
extension UIImage {
    class func cutCurrentViewToImage(view: UIView) -> UIImage? {
        var image: UIImage? = nil
        let size = view.bounds.size
        UIGraphicsBeginImageContextWithOptions(size, false, UIScreen.main.scale)
        if let context = UIGraphicsGetCurrentContext() {
            view.layer.render(in: context)
            image = UIGraphicsGetImageFromCurrentImageContext()
        }
        UIGraphicsEndImageContext()
        return image
    }
    
    class func cutCurrentViewWithRender(view: UIView) -> UIImage? {
        let render = UIGraphicsImageRenderer(bounds: view.bounds)
        return render.image(actions: { (context) in
            return view.layer.render(in: context.cgContext)
        })
        
    }
    
    /// 通过颜色和大小创建图片.
    ///
    /// - Parameters:
    ///   - color: 颜色
    ///   - size: 图片大小
    convenience init(color: UIColor, size: CGSize) {
        UIGraphicsBeginImageContextWithOptions(size, false, 1)
        defer {
            UIGraphicsEndImageContext()
        }
        
        color.setFill()
        UIRectFill(CGRect(origin: .zero, size: size))

        guard let aCgImage = UIGraphicsGetImageFromCurrentImageContext()?.cgImage else {
            self.init()
            return
        }
        self.init(cgImage: aCgImage)
    }
}

extension UIImage {
    
    // 灰度图
    func getGreyMap() -> UIImage? {
        guard let cgImage = cgImage else { return nil}
        let width = Int(size.width)
        let height = Int(size.height)
        let colorSpace = CGColorSpaceCreateDeviceGray()
        let context = CGContext(data: nil, width: width, height: height, bitsPerComponent: 8, bytesPerRow: 0, space: colorSpace, bitmapInfo: CGBitmapInfo().rawValue)
        let rect = CGRect(x: 0, y: 0, width: width, height: height)
        context?.draw(cgImage, in: rect)
        if let makeImage = context?.makeImage() {
            return UIImage(cgImage: makeImage)
        } else {
            return nil
        }
    }
    
    // 二值化
    func getBinaryzationMap() -> UIImage? {
        guard let cgImage = cgImage else { return nil}
                let width = 64
                let height = 64
                let bytesPerRow = 4 * width
                let bufferData = UnsafeMutablePointer<UInt8>.allocate(capacity: 4 * width * height)
                bufferData.initialize(repeating: 0, count: 4 * width * height)
        //        let bitmapInfo = CGImageAlphaInfo.premultipliedLast.rawValue
                let bitmapInfo = CGBitmapInfo.byteOrder32Big.rawValue | CGImageAlphaInfo.noneSkipLast.rawValue
                
        //            var bitMaps: [UInt32] = Array.init(repeating: 0, count: width * height)
                let colorSpace = CGColorSpaceCreateDeviceRGB()
                let context = CGContext(data: bufferData, width: width, height: height, bitsPerComponent: 8, bytesPerRow: bytesPerRow, space: colorSpace, bitmapInfo: bitmapInfo)
                print("width = \(width) height = \(height)")
        //        print("context.bitsPerComponent = \(context?.bitsPerComponent) context.bytesPerRow =\(context?.bytesPerRow) context.bitsPerPixel = \(context?.bitsPerPixel)")
                
                let rect = CGRect(x: 0, y: 0, width: width, height: height)
                context?.draw(cgImage, in: rect)
                
                for i in 0..<width*height {
                    let byteStart = i * 4
                    let r = Float(bufferData.advanced(by: byteStart).pointee)
                    let g = Float(bufferData.advanced(by: byteStart + 1).pointee)
                    let b = Float(bufferData.advanced(by: byteStart + 2).pointee)
                    let ap = Float(bufferData.advanced(by: byteStart + 3).pointee)
                    print("RGB r = \(r) g = \(g) b = \(b) ap = \(ap)")
                    if r < 200 || g < 200 || b < 200 {
                        bufferData.advanced(by: byteStart).pointee = 0x00
                        bufferData.advanced(by: byteStart + 1).pointee = 0x00
                        bufferData.advanced(by: byteStart + 2).pointee = 0x00
                        bufferData.advanced(by: byteStart + 3).pointee = 0xFF
                    } else {
                        bufferData.advanced(by: byteStart).pointee = UInt8(r)
                        bufferData.advanced(by: byteStart + 1).pointee = UInt8(g)
                        bufferData.advanced(by: byteStart + 2).pointee = UInt8(b)
                        bufferData.advanced(by: byteStart + 3).pointee = UInt8(ap)
                    }
                }
                
                let dataProvider = CGDataProvider(dataInfo: nil, data: bufferData, size: 4 * width * height) { (_, data, _) in
                    data.deallocate()
                }
                
                guard let provider = dataProvider else {
                    return nil
                }
                
                let cgBitmapInfoUInt32 = CGImageAlphaInfo.premultipliedLast.rawValue | CGBitmapInfo.byteOrder32Big.rawValue
                let cgBitmapInfo = CGBitmapInfo(rawValue: cgBitmapInfoUInt32)
                let newCGImageOptional = CGImage(width: width, height: height,
                                                 bitsPerComponent: 8,
                                                 bitsPerPixel: 32,
                                                 bytesPerRow: bytesPerRow,
                                                 space: colorSpace,
                                                 bitmapInfo: cgBitmapInfo,
                                                 provider: provider,
                                                 decode: nil,
                                                 shouldInterpolate: true,
                                                 intent: CGColorRenderingIntent.defaultIntent)
                guard let newCGImage = newCGImageOptional else {
                    return nil
                }
                return UIImage(cgImage: newCGImage)
    }
    
    // 改变图像颜色
    func getBinaryzationMapV2() -> UIImage? {
        guard let cgImage = cgImage else { return nil}
        let width = 64
        let height = 64
        let bytesPerRow = 4 * width
        let bufferData = UnsafeMutablePointer<UInt8>.allocate(capacity: 4 * width * height)
        bufferData.initialize(repeating: 0, count: 4 * width * height)
//        let bitmapInfo = CGImageAlphaInfo.premultipliedLast.rawValue
        let bitmapInfo = CGBitmapInfo.byteOrder32Big.rawValue | CGImageAlphaInfo.noneSkipLast.rawValue
        
//            var bitMaps: [UInt32] = Array.init(repeating: 0, count: width * height)
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let context = CGContext(data: bufferData, width: width, height: height, bitsPerComponent: 8, bytesPerRow: bytesPerRow, space: colorSpace, bitmapInfo: bitmapInfo)
        print("width = \(width) height = \(height)")
//        print("context.bitsPerComponent = \(context?.bitsPerComponent) context.bytesPerRow =\(context?.bytesPerRow) context.bitsPerPixel = \(context?.bitsPerPixel)")
        
        let rect = CGRect(x: 0, y: 0, width: width, height: height)
        context?.draw(cgImage, in: rect)
        
        for i in 0..<width*height {
            let byteStart = i * 4
            let r = Float(bufferData.advanced(by: byteStart).pointee)
            let g = Float(bufferData.advanced(by: byteStart + 1).pointee)
            let b = Float(bufferData.advanced(by: byteStart + 2).pointee)
            let ap = Float(bufferData.advanced(by: byteStart + 3).pointee)
            print("RGB r = \(r) g = \(g) b = \(b) ap = \(ap)")
            if r < 10 {
                bufferData.advanced(by: byteStart).pointee = 0x00
                bufferData.advanced(by: byteStart + 1).pointee = 0x25
                bufferData.advanced(by: byteStart + 2).pointee = 0xF6
                bufferData.advanced(by: byteStart + 3).pointee = 0xFF
            } else {
                bufferData.advanced(by: byteStart).pointee = UInt8(r)
                bufferData.advanced(by: byteStart + 1).pointee = UInt8(g)
                bufferData.advanced(by: byteStart + 2).pointee = UInt8(b)
                bufferData.advanced(by: byteStart + 3).pointee = UInt8(ap)
            }
        }
        
        let dataProvider = CGDataProvider(dataInfo: nil, data: bufferData, size: 4 * width * height) { (_, data, _) in
            data.deallocate()
        }
        
        guard let provider = dataProvider else {
            return nil
        }
        
        let cgBitmapInfoUInt32 = CGImageAlphaInfo.premultipliedLast.rawValue | CGBitmapInfo.byteOrder32Big.rawValue
        let cgBitmapInfo = CGBitmapInfo(rawValue: cgBitmapInfoUInt32)
        let newCGImageOptional = CGImage(width: width, height: height,
                                         bitsPerComponent: 8,
                                         bitsPerPixel: 32,
                                         bytesPerRow: bytesPerRow,
                                         space: colorSpace,
                                         bitmapInfo: cgBitmapInfo,
                                         provider: provider,
                                         decode: nil,
                                         shouldInterpolate: true,
                                         intent: CGColorRenderingIntent.defaultIntent)
        guard let newCGImage = newCGImageOptional else {
            return nil
        }
        return UIImage(cgImage: newCGImage)
    }
}


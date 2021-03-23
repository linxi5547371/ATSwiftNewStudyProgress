//
//  UIImage+QRCode.swift
//  SwiftNewDemo
//
//  Created by fangmengkai on 2021/3/12.
//  Copyright © 2021 Albert. All rights reserved.
//

import UIKit

extension UIImage {

    public convenience init(text: String, logoImage: UIImage?) {
        let stringData = text.data(using: .utf8, allowLossyConversion: false)
        let qrFilter = CIFilter(name: "CIQRCodeGenerator")
        qrFilter?.setValue(stringData, forKey: "inputMessage")
        qrFilter?.setValue("H", forKey: "inputCorrectionLevel")
        let qrCIImage = qrFilter?.outputImage
        let colorFilter = CIFilter(name: "CIFalseColor")!
        colorFilter.setDefaults()
        colorFilter.setValue(qrCIImage, forKey: "inputImage")
        colorFilter.setValue(CIColor.init(red: 0, green: 0, blue: 0), forKey: "inputColor0")
        colorFilter.setValue(CIColor.init(red: 1, green: 1, blue: 1), forKey: "inputColor1")
        
        guard let outputImage = colorFilter.outputImage else {
            self.init()
            return
        }
        self.init(ciImage: outputImage.transformed(by: CGAffineTransform(scaleX: 5, y: 5)))
        if var logoImage = logoImage {
            let qrCodeImage = NSObject.setupHighDefinitionUIImage(outputImage, size: 300)
            logoImage = NSObject.setCornerImage(logoImage)
            let newImage = NSObject.syntheticImage(qrCodeImage, logoImage: logoImage, width: 90, height: 90)
            if let outputImage = newImage.cgImage {
                self.init(cgImage: outputImage)
            } else {
                self.init()
            }
        } else {
            self.init(ciImage: outputImage.transformed(by: CGAffineTransform(scaleX: 5, y: 5)))
        }
    }
    
    /// 根据文本创建二维码.
    ///
    /// - Parameters:
    ///   - text: 文本
    convenience init(text: String) {
        let stringData = text.data(using: .utf8, allowLossyConversion: false)
        let qrFilter = CIFilter(name: "CIQRCodeGenerator")
        qrFilter?.setValue(stringData, forKey: "inputMessage")
        qrFilter?.setValue("H", forKey: "inputCorrectionLevel")
        let qrCIImage = qrFilter?.outputImage
        let colorFilter = CIFilter(name: "CIFalseColor")!
        colorFilter.setDefaults()
        colorFilter.setValue(qrCIImage, forKey: "inputImage")
        colorFilter.setValue(CIColor.init(red: 0, green: 0, blue: 0), forKey: "inputColor0")
        colorFilter.setValue(CIColor.init(red: 1, green: 1, blue: 1), forKey: "inputColor1")
        
        guard let outputImage = colorFilter.outputImage else {
            self.init()
            return
        }
        self.init(ciImage: outputImage.transformed(by: CGAffineTransform(scaleX: 5, y: 5)))
    }

}


fileprivate extension NSObject {
    
    static func syntheticImage(_ image: UIImage, logoImage:UIImage, width: CGFloat, height: CGFloat) -> UIImage {
        UIGraphicsBeginImageContext(image.size)
        image.draw(in: CGRect(origin: CGPoint.zero, size: image.size))
        let x = (image.size.width - width) * 0.5
        let y = (image.size.height - height) * 0.5
        logoImage.draw(in: CGRect(x: x, y: y, width: width, height: height))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        if let newImage = newImage {
            return newImage
        }
        return UIImage()
    }
    
    static func setupHighDefinitionUIImage(_ image: CIImage, size: CGFloat) -> UIImage {
        let integral: CGRect = image.extent.integral
        let proportion: CGFloat = min(size/integral.width, size/integral.height)
        let width = integral.width * proportion
        let height = integral.height * proportion
        let colorSpace: CGColorSpace = CGColorSpaceCreateDeviceGray()
        let bitmapRef = CGContext(data: nil, width: Int(width), height: Int(height), bitsPerComponent: 8, bytesPerRow: 0, space: colorSpace, bitmapInfo: 0)!
        let context = CIContext(options: nil)
        let bitmapImage: CGImage = context.createCGImage(image, from: integral)!
        bitmapRef.interpolationQuality = CGInterpolationQuality.none
        bitmapRef.scaleBy(x: proportion, y: proportion);
        bitmapRef.draw(bitmapImage, in: integral);
        let image: CGImage = bitmapRef.makeImage()!
        return UIImage(cgImage: image)
    }
    
    static func setCornerImage(_ sourceImage: UIImage) -> UIImage {
        let imageWidth = sourceImage.size.width
        let imageHeight = sourceImage.size.height
        let margin: CGFloat = 4
        let radii: CGFloat = 8
        UIGraphicsBeginImageContextWithOptions(CGSize(width: imageWidth, height: imageHeight), false, 0.0)
        UIGraphicsGetCurrentContext()
        let outerBezierPath = UIBezierPath(roundedRect: CGRect(x: 0, y: 0, width: imageWidth, height: imageHeight), byRoundingCorners: .allCorners, cornerRadii: CGSize(width: radii, height: radii))
        UIColor.white.setFill()
        outerBezierPath.fill()
        outerBezierPath.close()
        outerBezierPath.addClip()
        let bezierPath = UIBezierPath(roundedRect: CGRect(x: margin, y: margin, width: imageWidth - margin * 2, height: imageWidth - margin * 2), byRoundingCorners: .allCorners, cornerRadii: CGSize(width: radii, height: radii))
        bezierPath.fill()
        bezierPath.close()
        bezierPath.addClip()
        sourceImage.draw(in: CGRect(x: margin, y: margin, width: imageWidth - margin * 2, height: imageHeight - margin * 2))
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image!
    }
}

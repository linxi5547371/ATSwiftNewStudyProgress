//
//  ImageShowViewController.swift
//  SwiftNewDemo
//
//  Created by Qing Class on 2019/12/4.
//  Copyright © 2019 Albert. All rights reserved.
//

import Foundation
import UIKit

//大图加载优化学习
class ImageShowViewController: UIViewController, UIScrollViewDelegate {
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var scrollView: UIScrollView!
    var bigImageView: LoadBigImageView!
    var contentView: UIView!
    let imageURL = Bundle.main.url(forResource: "cat", withExtension: ".png")
    var image: UIImage?
    let isUseLayer = true

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if (isUseLayer) {
            //分块加载
            let data = try? Data(contentsOf: imageURL ?? URL(fileURLWithPath: ""))
            image = UIImage(data: data!)
            
            
            var imageRect = CGRect(x: 0, y: 0, width: image?.cgImage?.width ?? 10000, height: image?.cgImage?.height ?? 10000);
            let imageScale = UIScreen.main.bounds.width / imageRect.size.width
            imageRect.size = CGSize(width: imageRect.size.width * imageScale, height: imageRect.size.height * imageScale)
            if (imageRect.height < UIScreen.main.bounds.height - 20) {
                imageRect.origin = CGPoint(x: 0, y: (UIScreen.main.bounds.height - 20 - imageRect.height) / 2)
            }
            
            self.contentView = UIView(frame: imageRect)
            //预览图
            let preImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: imageRect.width, height: imageRect.height))
//            preImageView.image = UIImage.getImageWithSize(size: imageRect.size, imageURL: imageURL!)
            preImageView.image = UIImage.getImageWithSize(size: imageRect.size, imageData: data!)
//            preImageView.contentMode = .scaleAspectFill
            self.contentView.addSubview(preImageView)
            
            self.bigImageView = LoadBigImageView(frame: CGRect(x: 0, y: 0, width: imageRect.width, height: imageRect.height), image: self.image ?? UIImage(), scale: imageScale)
            self.bigImageView.bigImageData = data!
            self.contentView.addSubview(bigImageView)
            
            self.scrollView.minimumZoomScale = 1
            self.scrollView.maximumZoomScale = pow(2, ceil(log2(1/imageScale)) + 1.0)
            self.scrollView.addSubview(self.contentView)
            self.scrollView.frame = CGRect(x: 0, y: 20, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height - 20)
            self.scrollView.delegate = self;
            self.scrollView.contentSize = imageRect.size
        } else {
            self.scrollView.isHidden = true
            let data = try? Data(contentsOf: imageURL ?? URL(fileURLWithPath: ""))
            image = UIImage(data: data!)
//            let size = CGSize(width: 12000, height: 12000)
//            image = UIImage.getImageWithSize(size: size, imageURL: imageURL!)
            self.imageView.image = image
        }
    }
    
    
    
// MARK: - UIScrollViewDelegate
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        if (isUseLayer) {
            return self.contentView
        } else {
            
            return self.imageView
        }
    }
    

}

// 分块加载
class LoadBigImageView: UIView {
    var bigImage: UIImage?
    var imageScale: CGFloat = 0
    var bigImageData: Data!
    
    init(frame: CGRect, image: UIImage, scale: CGFloat) {
        super.init(frame: frame)
        self.bigImage = image
        self.frame = frame
        self.imageScale = scale
        
        let tiledLayer = self.layer as? CATiledLayer
        if let `tiledLayer` = tiledLayer {
            tiledLayer.delegate = self
            //确定重绘的位置
            tiledLayer.levelsOfDetail = Int(ceil(log2(1 / scale))) + 1
            tiledLayer.levelsOfDetailBias = Int(ceil(log2(1 / scale))) + 1
            tiledLayer.tileSize = CGSize(width: 50, height: 50)
        }
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override class var layerClass: AnyClass {
        return CATiledLayer.self
    }
    
    override func draw(_ rect: CGRect) {
        let rec = CGRect(x: rect.origin.x / imageScale, y: rect.origin.y / imageScale, width: rect.size.width / imageScale, height: rect.size.height / imageScale)
        let copImg = self.bigImage?.cgImage?.cropping(to: rec)
        
        if let `copImg` = copImg {
            let image = UIImage(cgImage: copImg)
            image.draw(in: rect)
        }
    }
    
    // MARK: - CALayerDelegate
//    override func draw(_ layer: CALayer, in ctx: CGContext) {
//        print("CALayerDelegate")
//    }
}

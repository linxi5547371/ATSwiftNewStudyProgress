//
//  PictureProcessController.swift
//  SwiftNewDemo
//
//  Created by fangmengkai on 2021/4/15.
//  Copyright © 2021 Albert. All rights reserved.
//

import UIKit

class PictureProcessController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    private func setupUI() {
        view.backgroundColor = .white
        view.addSubview(imageView)
        
        imageView.frame = CGRect(x: 100, y: 200, width: 300, height: 300)
        let image = UIImage(named: "xz_ic_share_wechat_timeline")
        imageView.image = image?.getBinaryzationMap()
    }
    
    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        return imageView
    }()
}

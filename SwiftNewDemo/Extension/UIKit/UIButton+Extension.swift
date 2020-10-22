//
//  UIButton+Extension.swift
//  SwiftNewDemo
//
//  Created by bjhl on 2020/9/15.
//  Copyright © 2020 Albert. All rights reserved.
//

import UIKit

// MARK: - Inset
public extension UIButton {
    
    ///  设置按钮Inset样式，当按钮重新设置了title或图片之后，需要重新设置样式
    /// - Parameters:
    ///   - style: 样式
    ///   - space: 间距
    func setInset(style: InsetStyle, space: CGFloat) {
        guard let titleLabel = titleLabel else { return }
        guard let imageView = imageView else { return }

        let imageSize = imageView.image?.size ?? CGSize.zero
        let titleSize = titleLabel.text?.size(withAttributes: [.font: titleLabel.font ?? UIFont.systemFont(ofSize: 14)]) ?? CGSize.zero

        var imageEdgeInsets = UIEdgeInsets.zero
        var titleEdgeInsets = UIEdgeInsets.zero

        switch (style) {
            case .imageRight:
                imageEdgeInsets.left = titleSize.width + space/2
                imageEdgeInsets.right = -imageEdgeInsets.left

                titleEdgeInsets.left = -(imageSize.width + space/2)
                titleEdgeInsets.right = -titleEdgeInsets.left

            case .imageLeft:
                imageEdgeInsets.left = -space/2
                imageEdgeInsets.right = -imageEdgeInsets.left

                titleEdgeInsets.left = space/2
                titleEdgeInsets.right = -titleEdgeInsets.left

            case .imageBottom:
                imageEdgeInsets.top = titleSize.height + space
                imageEdgeInsets.right = -titleSize.width

                titleEdgeInsets.left = -imageSize.width
                titleEdgeInsets.bottom = imageSize.height + space

            case .imageTop:
                imageEdgeInsets.top = -(titleSize.height + space)
                imageEdgeInsets.right = -titleSize.width

                titleEdgeInsets.left = -imageSize.width
                titleEdgeInsets.bottom = -(imageSize.height + space)
        }
        
        self.imageEdgeInsets = imageEdgeInsets
        self.titleEdgeInsets = titleEdgeInsets
    }
    
    /**
     按钮Inset样式

     - imageLeft: 图片在左，标题在右
     - imageRight: 图片在右，标题在左
     - imageTop: 图片在上，标题在下
     - imageBottom: 图片在下，标题在上
     */
    enum InsetStyle {
        case imageLeft
        case imageRight
        case imageTop
        case imageBottom
    }

}

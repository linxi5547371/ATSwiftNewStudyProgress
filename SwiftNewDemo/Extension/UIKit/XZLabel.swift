//
//  XZLabel.swift
//  SwiftNewDemo
//
//  Created by bjhl on 2020/8/24.
//  Copyright © 2020 Albert. All rights reserved.
//

import UIKit

open class XZLabel: UILabel {
    
    /// 设置文本inset
    open var textInset: UIEdgeInsets = .zero {
        didSet {
            invalidateIntrinsicContentSize()
        }
    }
    
    open override var intrinsicContentSize: CGSize {
        let size = super.intrinsicContentSize
        return CGSize(width: size.width + textInset.left + textInset.right, height: size.height + textInset.top + textInset.bottom)
    }

    open override func textRect(forBounds bounds: CGRect, limitedToNumberOfLines numberOfLines: Int) -> CGRect {
        var rect = super.textRect(forBounds: bounds, limitedToNumberOfLines: numberOfLines)
        rect.origin.x    -= textInset.left
        rect.origin.y    -= textInset.top
        rect.size.width  += (textInset.left + textInset.right)
        rect.size.height += (textInset.top + textInset.bottom)
        return rect
    }
    
    open override func drawText(in rect: CGRect) {
        super.drawText(in: rect.inset(by: textInset))
    }

}


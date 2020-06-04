//
//  UILabel+Extension.swift
//  SwiftNewDemo
//
//  Created by bjhl on 2020/6/3.
//  Copyright © 2020 Albert. All rights reserved.
//

import UIKit

extension UILabel {
    func setText(text: String, lineSpace: CGFloat) {
        if lineSpace < 0.01 {
            self.text = text
        }
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = lineSpace
        paragraphStyle.lineBreakMode = .byWordWrapping
        paragraphStyle.alignment = self.textAlignment
        let attributedText = NSMutableAttributedString(string: text, attributes: [.paragraphStyle : paragraphStyle])
        self.attributedText = attributedText
    }
}

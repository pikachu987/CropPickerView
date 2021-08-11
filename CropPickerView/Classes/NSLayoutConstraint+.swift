//
//  NSLayoutConstraint+.swift
//  CropPickerView
//
//  Created by Gwanho Kim on 02/12/2018.
//

import UIKit

extension NSLayoutConstraint {
    func priority(_ value: CGFloat) -> NSLayoutConstraint {
        priority = UILayoutPriority(Float(value))
        return self
    }
}

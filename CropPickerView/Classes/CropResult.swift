//
//  CropResult.swift
//  CropPickerView
//
//  Created by Apple on 2020/09/05.
//

import Foundation

public struct CropResult {
    public var error: Error?
    public var image: UIImage?
    public var cropFrame: CGRect?
    public var imageSize: CGSize?
    public var realCropFrame: CGRect?

    public init() { }
}

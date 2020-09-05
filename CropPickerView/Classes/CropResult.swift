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

    public init() { }

    public init(error: Error, cropFrame: CGRect? = nil, imageSize: CGSize? = nil) {
        self.error = error
        self.cropFrame = cropFrame
        self.imageSize = imageSize
    }

    public init(image: UIImage, cropFrame: CGRect? = nil, imageSize: CGSize? = nil) {
        self.image = image
        self.cropFrame = cropFrame
        self.imageSize = imageSize
    }
}

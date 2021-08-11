//Copyright (c) 2018 pikachu987 <pikachu77769@gmail.com>
//
//Permission is hereby granted, free of charge, to any person obtaining a copy
//of this software and associated documentation files (the "Software"), to deal
//in the Software without restriction, including without limitation the rights
//to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//copies of the Software, and to permit persons to whom the Software is
//furnished to do so, subject to the following conditions:
//
//The above copyright notice and this permission notice shall be included in
//all copies or substantial portions of the Software.
//
//THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//THE SOFTWARE.

import UIKit

// CropPickerView Delegate
public protocol CropPickerViewDelegate: AnyObject {
    // Called when the image or error.
    func cropPickerView(_ cropPickerView: CropPickerView, result: CropResult)
    func cropPickerView(_ cropPickerView: CropPickerView, didChange frame: CGRect)
}
public extension CropPickerViewDelegate {
    func cropPickerView(_ cropPickerView: CropPickerView, didChange frame: CGRect) {

    }
}

@IBDesignable
public class CropPickerView: UIView {
    public weak var delegate: CropPickerViewDelegate?
    
    // MARK: Public Property
    
    public var cropMinSize: CGFloat = 100

    // Set Image
    @IBInspectable
    public var image: UIImage? {
        get {
            return imageView.image
        }
        set {
            imageView.image = newValue?.fixOrientation
            scrollView.setZoomScale(1, animated: false)
            initVars()
            cropLineHidden(image)
            scrollView.layoutIfNeeded()
            dimLayerMask(animated: false)
            DispatchQueue.main.async {
                self.imageMinAdjustment(animated: false)
            }
        }
    }
    
    // Set Image
    @IBInspectable
    public var changeImage: UIImage? {
        get {
            return imageView.image
        }
        set {
            imageView.image = newValue?.fixOrientation
        }
    }
    
    // Line color of crop view
    @IBInspectable
    public var cropLineColor: UIColor? {
        get {
            return cropView.lineColor
        }
        set {
            cropView.lineColor = newValue
            leftTopButton.edgeLine(newValue)
            leftBottomButton.edgeLine(newValue)
            rightTopButton.edgeLine(newValue)
            rightBottomButton.edgeLine(newValue)
            topButton.edgeLine(newValue)
            leftButton.edgeLine(newValue)
            rightButton.edgeLine(newValue)
            bottomButton.edgeLine(newValue)
        }
    }
    
    // Background color of scroll
    @IBInspectable
    public var scrollBackgroundColor: UIColor? {
        get {
            return scrollView.backgroundColor
        }
        set {
            scrollView.backgroundColor = newValue
        }
    }
    
    // Background color of image
    @IBInspectable
    public var imageBackgroundColor: UIColor? {
        get {
            return imageView.backgroundColor
        }
        set {
            imageView.backgroundColor = newValue
        }
    }
    
    // Color of dim view not in the crop area
    @IBInspectable
    public var dimBackgroundColor: UIColor? {
        get {
            return dimView.backgroundColor
        }
        set {
            dimView.backgroundColor = newValue
        }
    }
    
    // Minimum zoom for scrolling
    @IBInspectable
    public var scrollMinimumZoomScale: CGFloat {
        get {
            return scrollView.minimumZoomScale
        }
        set {
            scrollView.minimumZoomScale = newValue
        }
    }
    
    // Maximum zoom for scrolling
    @IBInspectable
    public var scrollMaximumZoomScale: CGFloat {
        get {
            return scrollView.maximumZoomScale
        }
        set {
            scrollView.maximumZoomScale = newValue
        }
    }

    // crop radius
    @IBInspectable
    public var radius: CGFloat = 0 {
        didSet {
            dimLayerMask(animated: false)
        }
    }

    // If false, the cropview and dimview will disappear and only the view will be zoomed in or out.
    public var isCrop = true {
        willSet {
            topButton.isHidden = !newValue
            bottomButton.isHidden = !newValue
            leftButton.isHidden = !newValue
            rightButton.isHidden = !newValue
            leftTopButton.isHidden = !newValue
            leftBottomButton.isHidden = !newValue
            rightTopButton.isHidden = !newValue
            rightBottomButton.isHidden = !newValue
            centerButton.isHidden = !newValue
            dimView.isHidden = !newValue
            cropView.isHidden = !newValue
        }
    }

    public var aspectRatio: CGFloat = 0 {
        didSet {
            if isRate {
                var leading: CGFloat = 0
                var trailing: CGFloat = 0
                var top: CGFloat = 0
                var bottom: CGFloat = 0
                let width = bounds.width + leading - trailing
                let height = bounds.height + top - bottom
                let widthRate = width / bounds.width
                let heightRate = height / bounds.height
                if widthRate > heightRate {
                    let margin = (bounds.width - (height * aspectRatio)) / 2
                    if margin > 0 {
                        leading = -margin
                        trailing = margin
                    } else {
                        let margin = (bounds.height - (width / aspectRatio)) / 2
                        top = -margin
                        bottom = margin
                    }
                } else {
                    let margin = (bounds.height - (width / aspectRatio)) / 2
                    if margin > 0 {
                        top = -margin
                        bottom = margin
                    } else {
                        let margin = (bounds.width - (height * aspectRatio)) / 2
                        leading = -margin
                        trailing = margin
                    }
                }
                cropLeadingConstraint?.constant = leading
                cropTrailingConstraint?.constant = trailing
                cropTopConstraint?.constant = top
                cropBottomConstraint?.constant = bottom
                dimLayerMask(0, animated: false)
                
                topButton.isHidden = true
                leftButton.isHidden = true
                bottomButton.isHidden = true
                rightButton.isHidden = true
            } else {
                topButton.isHidden = false
                leftButton.isHidden = false
                bottomButton.isHidden = false
                rightButton.isHidden = false
            }
        }
    }

    // MARK: Private Property
    
    public let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.alpha = 1
        return scrollView
    }()
    
    public let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    public let dimView: CropDimView = {
        let view = CropDimView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.alpha = 1
        return view
    }()
    
    public let cropView: CropView = {
        let cropView = CropView()
        cropView.translatesAutoresizingMaskIntoConstraints = false
        return cropView
    }()
    
    // Side button and corner button of crop
    
    public let leftTopButton: LineButton = {
        let button = LineButton(.leftTop)
        return button
    }()
    
    public let leftBottomButton: LineButton = {
        let button = LineButton(.leftBottom)
        return button
    }()
    
    public let rightTopButton: LineButton = {
        let button = LineButton(.rightTop)
        return button
    }()
    
    public let rightBottomButton: LineButton = {
        let button = LineButton(.rightBottom)
        return button
    }()
    
    public let topButton: LineButton = {
        let button = LineButton(.top)
        return button
    }()
    
    public let leftButton: LineButton = {
        let button = LineButton(.left)
        return button
    }()
    
    public let rightButton: LineButton = {
        let button = LineButton(.right)
        return button
    }()
    
    public let bottomButton: LineButton = {
        let button = LineButton(.bottom)
        return button
    }()
    
    public let centerButton: LineButton = {
        let button = LineButton(.center)
        return button
    }()
    
    private var cropLeadingConstraint: NSLayoutConstraint?
    
    private var cropTrailingConstraint: NSLayoutConstraint?
    
    private var cropTopConstraint: NSLayoutConstraint?
    
    private var cropBottomConstraint: NSLayoutConstraint?
    
    private var lineButtonTouchPoint: CGPoint?
    
    private var isInit = false
    
    private var isRate: Bool {
        return aspectRatio != 0
    }
    
    // MARK: Init
    
    public override func awakeFromNib() {
        super.awakeFromNib()
        
        initVars()
    }
    
    public override init(frame: CGRect = .zero) {
        super.init(frame: frame)
        
        initVars()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    // Max Image
    public func imageMaxAdjustment(_ duration: TimeInterval = 0.4, animated: Bool) {
        imageAdjustment(.zero, duration: duration, animated: animated)
    }
    
    // Min Image
    public func imageMinAdjustment(_ duration: TimeInterval = 0.4, animated: Bool) {
        var point: CGPoint
        let imageSize = imageView.frameForImageInImageViewAspectFit
        if isImageRateHeightGreaterThan(imageSize) {
            point = CGPoint(x: 0, y: imageSize.origin.y)
        } else {
            point = CGPoint(x: imageSize.origin.x, y: 0)
        }
        imageAdjustment(point, duration: duration, animated: animated)
    }
    
    public func imageAdjustment(_ point: CGPoint, duration: TimeInterval = 0.4, animated: Bool) {
        var leading = -point.x
        var trailing = point.x
        var top = -point.y
        var bottom = point.y
        if isRate {
            let width = bounds.width + leading - trailing
            let height = bounds.height + top - bottom
            let widthRate = width / bounds.width
            let heightRate = height / bounds.height
            if widthRate > heightRate {
                let margin = (bounds.width - (height * aspectRatio)) / 2
                if margin > 0 {
                    leading = -margin
                    trailing = margin
                } else {
                    let margin = (bounds.height - (width / aspectRatio)) / 2
                    top = -margin
                    bottom = margin
                }
            } else {
                let margin = (bounds.height - (width / aspectRatio)) / 2
                if margin > 0 {
                    top = -margin
                    bottom = margin
                } else {
                    let margin = (bounds.width - (height * aspectRatio)) / 2
                    leading = -margin
                    trailing = margin
                }
            }
        }
        cropLeadingConstraint?.constant = leading
        cropTrailingConstraint?.constant = trailing
        cropTopConstraint?.constant = top
        cropBottomConstraint?.constant = bottom
        if animated {
            dimLayerMask(duration, animated: animated)
            UIView.animate(withDuration: duration, delay: 0, options: UIView.AnimationOptions.curveEaseInOut, animations: {
                self.layoutIfNeeded()
            }, completion: nil)
        } else {
            dimLayerMask(duration, animated: animated)
        }
    }

    /*
     image: UIImage
     isMin: Bool set image after min or max image
     crop: set image after crop size
     isRealCropRect: image real crop or image frame crop
    */
    public func image(_ image: UIImage?, isMin: Bool = true, crop: CGRect? = nil, isRealCropRect: Bool = false) {
        imageView.image = image?.fixOrientation
        if isMin {
            scrollView.setZoomScale(1, animated: false)
        } else {
            imageRealSize(false)
        }
        initVars()
        cropLineHidden(image)
        scrollView.layoutIfNeeded()
        dimLayerMask(animated: false)
        DispatchQueue.main.async {
            var point: CGPoint = .zero
            if isMin {
                let imageSize = self.imageView.frameForImageInImageViewAspectFit
                if self.isImageRateHeightGreaterThan(imageSize) {
                    point = CGPoint(x: 0, y: imageSize.origin.y)
                } else {
                    point = CGPoint(x: imageSize.origin.x, y: 0)
                }
            }
            if isRealCropRect {
                point = .zero
            }
            var leading = -point.x
            var trailing = point.x
            var top = -point.y
            var bottom = point.y
            if let crop = crop {
                leading = -point.x - crop.origin.x
                trailing = (self.bounds.width - (point.x + crop.origin.x + crop.size.width))
                top = -point.y - crop.origin.y
                bottom = (self.bounds.height - (point.y + crop.origin.y + crop.size.height))
            }
            if self.isRate {
                let width = self.bounds.width + leading - trailing
                let height = self.bounds.height + top - bottom
                let widthRate = width / self.bounds.width
                let heightRate = height / self.bounds.height
                if widthRate == heightRate {
                    let margin = (self.bounds.width - height) / 2
                    if margin > 0 {
                        leading = -margin
                        trailing = margin
                    } else {
                        let margin = (self.bounds.height - width) / 2
                        top = -margin
                        bottom = margin
                    }
                } else if widthRate > heightRate {
                    let margin = (self.bounds.width - (height * self.aspectRatio)) / 2
                    if margin > 0 {
                        leading = -margin
                        trailing = margin
                    } else {
                        let margin = (self.bounds.height - (width / self.aspectRatio)) / 2
                        top = -margin
                        bottom = margin
                    }
                } else {
                    let margin = (self.bounds.height - (width / self.aspectRatio)) / 2
                    if margin > 0 {
                        top = -margin
                        bottom = margin
                    } else {
                        let margin = (self.bounds.width - (height * self.aspectRatio)) / 2
                        leading = -margin
                        trailing = margin
                    }
                }
            }
            self.cropLeadingConstraint?.constant = leading
            self.cropTrailingConstraint?.constant = trailing
            self.cropTopConstraint?.constant = top
            self.cropBottomConstraint?.constant = bottom
            self.dimLayerMask(0.0, animated: false)
        }
    }

    // MARK: Public Method
    
    /**
     crop method.
     If there is no image to crop, Error 404 is displayed.
     If there is no image in the crop area, Error 503 is displayed.
     If the image is successfully cropped, the success delegate or callback function is called.
     **/
    public func crop(_ handler: ((CropResult) -> Void)? = nil) {
        var cropResult = CropResult()
        guard let image = imageView.image?.fixOrientation else {
            cropResult.error = NSError(domain: "Image is empty.", code: 404, userInfo: nil)
            handler?(cropResult)
            delegate?.cropPickerView(self, result: cropResult)
            return
        }
        
        DispatchQueue.main.async {
            let imageSize = self.imageView.frameForImageInImageViewAspectFit
            let widthRate =  self.bounds.width / imageSize.width
            let heightRate = self.bounds.height / imageSize.height
            var factor: CGFloat
            if widthRate < heightRate {
                factor = image.size.width / self.scrollView.frame.width
            } else {
                factor = image.size.height / self.scrollView.frame.height
            }
            let scale = 1 / self.scrollView.zoomScale
            let imageFrame = self.imageView.imageFrame

            let frameX = (self.scrollView.contentOffset.x + self.cropView.frame.origin.x - imageFrame.origin.x)
            let frameY = (self.scrollView.contentOffset.y + self.cropView.frame.origin.y - imageFrame.origin.y)
            let frameWidth = self.cropView.frame.size.width
            let frameHeight = self.cropView.frame.size.height
            let realCropFrame = CGRect(x: frameX, y: frameY, width: frameWidth, height: frameHeight)
            cropResult.realCropFrame = realCropFrame
            
            let cropFrameX = frameX > 0 ? frameX : 0
            let cropFrameY = frameY > 0 ? frameY : 0
            var cropFrameWidth = frameWidth
            if frameX < 0 {
                cropFrameWidth += frameX
            }
            if cropFrameWidth > imageSize.width - cropFrameX {
                cropFrameWidth = imageSize.width - cropFrameX
            }
            var cropFrameHeight = frameHeight
            if frameY < 0 {
                cropFrameHeight += frameY
            }
            if cropFrameHeight > imageSize.height - cropFrameY {
                cropFrameHeight = imageSize.height - cropFrameY
            }
            let cropResultFrame = CGRect(x: cropFrameX, y: cropFrameY, width: cropFrameWidth, height: cropFrameHeight)
            let imageResultSize = CGSize(width: imageFrame.width, height: imageFrame.height)

            let croppingX = frameX * scale * factor
            let croppingY = frameY * scale * factor
            let width = self.cropView.frame.size.width * scale * factor
            let height = self.cropView.frame.size.height * scale * factor
            let cropArea = CGRect(x: croppingX, y: croppingY, width: width, height: height)
            
            cropResult.cropFrame = cropResultFrame
            cropResult.imageSize = imageResultSize
            
            guard let cropImage = image.crop(cropArea, radius: self.radius, radiusScale: width / self.cropView.frame.size.width)?.fixOrientation else {
                cropResult.error = NSError(domain: "There is no image in the Crop area.", code: 503, userInfo: nil)
                handler?(cropResult)
                self.delegate?.cropPickerView(self, result: cropResult)
                return
            }
            
            if image.cgImage?.cropping(to: cropArea) == nil {
                cropResult.error = NSError(domain: "There is no image in the Crop area.", code: 503, userInfo: nil)
            }
            
            cropResult.image = cropImage
            handler?(cropResult)
            self.delegate?.cropPickerView(self, result: cropResult)
        }
    }
}

// MARK: Private Method Init
extension CropPickerView {
    // Side button and corner button group of crops
    private var lineButtonGroup: [LineButton] {
        return [leftTopButton, leftBottomButton, rightTopButton, rightBottomButton, topButton, leftButton, bottomButton, rightButton, centerButton]
    }
    
    // Init
    private func initVars() {
        if isInit { return }
        isInit = true
        addSubview(scrollView)
        addSubview(cropView)
        addSubview(dimView)
        addSubview(leftTopButton)
        addSubview(leftBottomButton)
        addSubview(rightTopButton)
        addSubview(rightBottomButton)
        addSubview(topButton)
        addSubview(leftButton)
        addSubview(rightButton)
        addSubview(bottomButton)
        addSubview(centerButton)
        scrollView.addSubview(imageView)
        
        edgesConstraint(subView: scrollView)
        
        scrollView.edgesConstraint(subView: imageView)
        scrollView.sizeConstraint(subView: imageView)
        
        edgesConstraint(subView: dimView)
        
        cropLeadingConstraint = leadingConstraint(subView: cropView, constant: 0).priority(945)
        cropTrailingConstraint = trailingConstraint(subView: cropView, constant: 0).priority(945)
        cropTopConstraint = topConstraint(subView: cropView, constant: 0).priority(945)
        cropBottomConstraint = bottomConstraint(subView: cropView, constant: 0).priority(945)

        topConstraint(item: cropView, subView: leftTopButton, constant: 10)
        leadingConstraint(item: cropView, subView: leftTopButton, constant: 10)
        
        bottomConstraint(item: cropView, subView: leftBottomButton, constant: -10)
        leadingConstraint(item: cropView, subView: leftBottomButton, constant: 10)
        
        topConstraint(item: cropView, subView: rightTopButton, constant: 10)
        trailingConstraint(item: cropView, subView: rightTopButton, constant: -10)
        
        bottomConstraint(item: cropView, subView: rightBottomButton, constant: -10)
        trailingConstraint(item: cropView, subView: rightBottomButton, constant: -10)
        
        topConstraint(item: cropView, subView: topButton, constant: 10)
        centerXConstraint(item: cropView, subView: topButton)
        
        centerYConstraint(item: cropView, subView: leftButton)
        leadingConstraint(item: cropView, subView: leftButton, constant: 10)
        
        centerYConstraint(item: cropView, subView: rightButton)
        trailingConstraint(item: cropView, subView: rightButton, constant: -10)
        
        bottomConstraint(item: cropView, subView: bottomButton, constant: -10)
        centerXConstraint(item: cropView, subView: bottomButton)
        
        centerButton.widthConstraint(constant: 80, relatedBy: .equal).priority = UILayoutPriority(700)
        centerButton.heightConstraint(constant: 80, relatedBy: .equal).priority = UILayoutPriority(700)
        centerXConstraint(item: cropView, subView: centerButton)
        centerYConstraint(item: cropView, subView: centerButton)
        
        let leading = NSLayoutConstraint(item: leftButton, attribute: .trailing, relatedBy: .greaterThanOrEqual, toItem: centerButton, attribute: .leading, multiplier: 1, constant: 0)
        let trailing = NSLayoutConstraint(item: rightButton, attribute: .leading, relatedBy: .greaterThanOrEqual, toItem: centerButton, attribute: .trailing, multiplier: 1, constant: 0)
        let top = NSLayoutConstraint(item: topButton, attribute: .bottom, relatedBy: .greaterThanOrEqual, toItem: centerButton, attribute: .top, multiplier: 1, constant: 0)
        let bottom = NSLayoutConstraint(item: bottomButton, attribute: .top, relatedBy: .greaterThanOrEqual, toItem: centerButton, attribute: .bottom, multiplier: 1, constant: 0)
        
        leading.priority = UILayoutPriority(600)
        trailing.priority = UILayoutPriority(600)
        top.priority = UILayoutPriority(600)
        bottom.priority = UILayoutPriority(600)
        
        addConstraints([leading, trailing, top, bottom])
        
        scrollView.clipsToBounds = true
        scrollView.delegate = self
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFit
        
        cropLineHidden(image)
        
        cropLineColor = cropLineColor ?? .white
        scrollMinimumZoomScale = 0.3
        scrollMaximumZoomScale = 5
        scrollBackgroundColor = scrollBackgroundColor ?? .black
        imageBackgroundColor = imageBackgroundColor ?? .black
        dimBackgroundColor = dimBackgroundColor ?? UIColor(white: 0, alpha: 0.6)
        
        let doubleTapGesture = UITapGestureRecognizer(target: self, action: #selector(imageDoubleTap(_:)))
        doubleTapGesture.numberOfTapsRequired = 2
        scrollView.addGestureRecognizer(doubleTapGesture)
        
        lineButtonGroup.forEach { (button) in
            button.delegate = self
            button.addTarget(self, action: #selector(cropButtonTouchDown(_:forEvent:)), for: .touchDown)
            button.addTarget(self, action: #selector(cropButtonTouchUpInside(_:forEvent:)), for: .touchUpInside)
        }
        
        leftTopButton.addTarget(self, action: #selector(cropButtonLeftTopDrag(_:forEvent:)), for: .touchDragInside)
        leftBottomButton.addTarget(self, action: #selector(cropButtonLeftBottomDrag(_:forEvent:)), for: .touchDragInside)
        rightTopButton.addTarget(self, action: #selector(cropButtonRightTopDrag(_:forEvent:)), for: .touchDragInside)
        rightBottomButton.addTarget(self, action: #selector(cropButtonRightBottomDrag(_:forEvent:)), for: .touchDragInside)
        topButton.addTarget(self, action: #selector(cropButtonTopDrag(_:forEvent:)), for: .touchDragInside)
        leftButton.addTarget(self, action: #selector(cropButtonLeftDrag(_:forEvent:)), for: .touchDragInside)
        rightButton.addTarget(self, action: #selector(cropButtonRightDrag(_:forEvent:)), for: .touchDragInside)
        bottomButton.addTarget(self, action: #selector(cropButtonBottomDrag(_:forEvent:)), for: .touchDragInside)
        
        centerButton.addTarget(self, action: #selector(centerDoubleTap(_:)), for: .touchDownRepeat)
        centerButton.addTarget(self, action: #selector(cropButtonCenterDrag(_:forEvent:)), for: .touchDragInside)
        
        if isRate {
            topButton.isHidden = true
            leftButton.isHidden = true
            bottomButton.isHidden = true
            rightButton.isHidden = true
        }
        
        layoutIfNeeded()
    }
    
    // Does not display lines when the image is nil.
    private func cropLineHidden(_ image: UIImage?) {
        cropView.alpha = image == nil ? 0 : 1
        leftTopButton.alpha = image == nil ? 0 : 1
        leftBottomButton.alpha = image == nil ? 0 : 1
        rightBottomButton.alpha = image == nil ? 0 : 1
        rightTopButton.alpha = image == nil ? 0 : 1
        topButton.alpha = image == nil ? 0 : 1
        bottomButton.alpha = image == nil ? 0 : 1
        leftButton.alpha = image == nil ? 0 : 1
        rightButton.alpha = image == nil ? 0 : 1
    }
}

// MARK: Private Method Touch Action
extension CropPickerView {
    // Center Button Double Tap
    @objc private func centerDoubleTap(_ sender: UITapGestureRecognizer) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.imageDoubleTap(sender)
        }
    }
    
    // ImageView Double Tap
    @objc private func imageDoubleTap(_ sender: UITapGestureRecognizer) {
        if scrollView.zoomScale == 1 {
            imageRealSize(true)
            DispatchQueue.main.async {
                self.imageMaxAdjustment(animated: true)
            }
        } else {
            scrollView.setZoomScale(1, animated: true)
            DispatchQueue.main.async {
                self.imageMinAdjustment(animated: true)
            }
        }
    }
    
    // Touch Down Button
    @objc private func cropButtonTouchDown(_ sender: LineButton, forEvent event: UIEvent) {
        guard let touch = event.touches(for: sender)?.first else { return }
        lineButtonTouchPoint = touch.location(in: self)
        cropView.line(false, animated: true)
        dimLayerMask(animated: false)
        lineButtonGroup
            .filter { sender != $0 }
            .forEach { $0.isUserInteractionEnabled = false }
    }
    
    
    // Touch Up Inside Button
    @objc private func cropButtonTouchUpInside(_ sender: LineButton, forEvent event: UIEvent) {
        lineButtonTouchPoint = nil
        cropView.line(true, animated: true)
        dimLayerMask(animated: false)
        lineButtonGroup
            .forEach { $0.isUserInteractionEnabled = true }
    }
    
    @objc private func cropButtonLeftTopDrag(_ sender: LineButton, forEvent event: UIEvent) {
        guard let cropLeadingConstraint = cropLeadingConstraint,
            let cropTrailingConstraint = cropTrailingConstraint,
            let cropTopConstraint =  cropTopConstraint,
            let cropBottomConstraint =  cropBottomConstraint else { return }
        guard let touchPoint = lineButtonTouchPoint, let currentPoint = event.touches(for: sender)?.first?.location(in: self) else { return }
        
        let hConstant = cropLeadingConstraint.constant - (currentPoint.x - touchPoint.x)
        let vConstant = cropTopConstraint.constant - (currentPoint.y - touchPoint.y)
        if isRate {
            let xMargin = touchPoint.x - currentPoint.x
            let yMargin = touchPoint.y - currentPoint.y
            if abs(xMargin) > abs(yMargin) {
                let width = bounds.width + hConstant - cropTrailingConstraint.constant
                let vConstant = bounds.height - cropBottomConstraint.constant - (width / aspectRatio)
                let height = bounds.height - vConstant - cropBottomConstraint.constant
                if (-hConstant) >= 0 && vConstant >= 0 && width > cropMinSize && height > cropMinSize {
                    self.cropLeadingConstraint?.constant = hConstant
                    self.cropTopConstraint?.constant = -vConstant
                }
            } else {
                let height = bounds.height + vConstant - cropBottomConstraint.constant
                let hConstant = bounds.width - cropTrailingConstraint.constant - (height * aspectRatio)
                let width = bounds.width - hConstant - cropTrailingConstraint.constant
                if hConstant >= 0 && (-vConstant) >= 0 && height > cropMinSize && width > cropMinSize {
                    self.cropTopConstraint?.constant = vConstant
                    self.cropLeadingConstraint?.constant = -hConstant
                }
            }
        } else {
            if (hConstant <= 0 || currentPoint.x - touchPoint.x > 0) && bounds.width + (hConstant - cropTrailingConstraint.constant) > cropMinSize {
                self.cropLeadingConstraint?.constant = hConstant
            }
            if (vConstant <= 0 || currentPoint.y - touchPoint.y > 0) && bounds.height + (vConstant - cropBottomConstraint.constant) > cropMinSize {
                self.cropTopConstraint?.constant = vConstant
            }
        }
        lineButtonTouchPoint = currentPoint
        dimLayerMask(animated: false)
    }
    
    @objc private func cropButtonLeftBottomDrag(_ sender: LineButton, forEvent event: UIEvent) {
        guard let cropLeadingConstraint = cropLeadingConstraint,
            let cropTrailingConstraint = cropTrailingConstraint,
            let cropTopConstraint =  cropTopConstraint,
            let cropBottomConstraint =  cropBottomConstraint else { return }
        guard let touchPoint = lineButtonTouchPoint, let currentPoint = event.touches(for: sender)?.first?.location(in: self) else { return }

        let hConstant = cropLeadingConstraint.constant - (currentPoint.x - touchPoint.x)
        let vConstant = cropBottomConstraint.constant - (currentPoint.y - touchPoint.y)
        if isRate {
            let xMargin = touchPoint.x - currentPoint.x
            let yMargin = touchPoint.y - currentPoint.y
            if abs(xMargin) > abs(yMargin) {
                let width = bounds.width + hConstant - cropTrailingConstraint.constant
                let vConstant = bounds.height + cropTopConstraint.constant - (width / aspectRatio)
                let height = bounds.height - vConstant + cropTopConstraint.constant
                if (-hConstant) >= 0 && vConstant >= 0 && width > cropMinSize && height > cropMinSize {
                    self.cropLeadingConstraint?.constant = hConstant
                    self.cropBottomConstraint?.constant = vConstant
                }
            } else {
                let height = bounds.height - vConstant + cropTopConstraint.constant
                let hConstant = bounds.width - cropTrailingConstraint.constant - (height * aspectRatio)
                let width = bounds.width - hConstant - cropTrailingConstraint.constant
                if hConstant >= 0 && vConstant >= 0 && height > cropMinSize && width > cropMinSize {
                    self.cropBottomConstraint?.constant = vConstant
                    self.cropLeadingConstraint?.constant = -hConstant
                }
            }
        } else {
            if (hConstant <= 0 || currentPoint.x - touchPoint.x > 0) && bounds.width + (hConstant - cropTrailingConstraint.constant) > cropMinSize {
                self.cropLeadingConstraint?.constant = hConstant
            }
            if (vConstant > 0 || currentPoint.y - touchPoint.y < 0) && bounds.height - (vConstant - cropTopConstraint.constant) > cropMinSize {
                self.cropBottomConstraint?.constant = vConstant
            }
        }
        lineButtonTouchPoint = currentPoint
        dimLayerMask(animated: false)
    }
    
    @objc private func cropButtonRightTopDrag(_ sender: LineButton, forEvent event: UIEvent) {
        guard let cropLeadingConstraint = cropLeadingConstraint,
            let cropTrailingConstraint = cropTrailingConstraint,
            let cropTopConstraint =  cropTopConstraint,
            let cropBottomConstraint =  cropBottomConstraint else { return }
        guard let touchPoint = lineButtonTouchPoint, let currentPoint = event.touches(for: sender)?.first?.location(in: self) else { return }
        
        lineButtonTouchPoint?.x = currentPoint.x
        
        let hConstant = cropTrailingConstraint.constant - (currentPoint.x - touchPoint.x)
        let vConstant = cropTopConstraint.constant - (currentPoint.y - touchPoint.y)
        if isRate {
            let xMargin = touchPoint.x - currentPoint.x
            let yMargin = touchPoint.y - currentPoint.y
            if abs(xMargin) > abs(yMargin) {
                let width = bounds.width - hConstant + cropLeadingConstraint.constant
                let vConstant = bounds.height - cropBottomConstraint.constant - (width / aspectRatio)
                let height = bounds.height - vConstant - cropBottomConstraint.constant
                if hConstant >= 0 && vConstant >= 0 && width > cropMinSize && height > cropMinSize {
                    self.cropTrailingConstraint?.constant = hConstant
                    self.cropTopConstraint?.constant = -vConstant
                }
            } else {
                let height = bounds.height + vConstant - cropBottomConstraint.constant
                let hConstant = bounds.width + cropLeadingConstraint.constant - (height * aspectRatio)
                let width = bounds.width - hConstant + cropLeadingConstraint.constant
                if hConstant >= 0 && (-vConstant) >= 0 && height > cropMinSize && width > cropMinSize {
                    self.cropTopConstraint?.constant = vConstant
                    self.cropTrailingConstraint?.constant = hConstant
                }
            }
        } else {
            if (hConstant > 0 || currentPoint.x - touchPoint.x < 0) && bounds.width - (hConstant - cropLeadingConstraint.constant) > cropMinSize {
                self.cropTrailingConstraint?.constant = hConstant
            }
            if (vConstant <= 0 || currentPoint.y - touchPoint.y > 0) && bounds.height + (vConstant - cropBottomConstraint.constant) > cropMinSize {
                self.cropTopConstraint?.constant = vConstant
            }
        }
        lineButtonTouchPoint = currentPoint
        dimLayerMask(animated: false)
    }
    
    @objc private func cropButtonRightBottomDrag(_ sender: LineButton, forEvent event: UIEvent) {
        guard let cropLeadingConstraint = cropLeadingConstraint,
            let cropTrailingConstraint = cropTrailingConstraint,
            let cropTopConstraint =  cropTopConstraint,
            let cropBottomConstraint =  cropBottomConstraint else { return }
        guard let touchPoint = lineButtonTouchPoint, let currentPoint = event.touches(for: sender)?.first?.location(in: self) else { return }
        
        lineButtonTouchPoint?.x = currentPoint.x
        lineButtonTouchPoint?.y = currentPoint.y
        
        let hConstant = cropTrailingConstraint.constant - (currentPoint.x - touchPoint.x)
        let vConstant = cropBottomConstraint.constant - (currentPoint.y - touchPoint.y)
        if isRate {
            let xMargin = touchPoint.x - currentPoint.x
            let yMargin = touchPoint.y - currentPoint.y
            if abs(xMargin) > abs(yMargin) {
                let width = bounds.width - hConstant + cropLeadingConstraint.constant
                let vConstant = bounds.height + cropTopConstraint.constant - (width / aspectRatio)
                let height = bounds.height - vConstant + cropTopConstraint.constant
                if hConstant >= 0 && vConstant >= 0 && width > cropMinSize && height > cropMinSize {
                    self.cropTrailingConstraint?.constant = hConstant
                    self.cropBottomConstraint?.constant = vConstant
                }
            } else {
                let height = bounds.height - vConstant + cropTopConstraint.constant
                let hConstant = bounds.width + cropLeadingConstraint.constant - (height * aspectRatio)
                let width = bounds.width - hConstant + cropLeadingConstraint.constant
                if hConstant >= 0 && vConstant >= 0 && height > cropMinSize && width > cropMinSize {
                    self.cropBottomConstraint?.constant = vConstant
                    self.cropTrailingConstraint?.constant = hConstant
                }
            }
        } else {
            if (hConstant > 0 || currentPoint.x - touchPoint.x < 0) && bounds.width - (hConstant - cropLeadingConstraint.constant) > cropMinSize {
                self.cropTrailingConstraint?.constant = hConstant
            }
            if (vConstant > 0 || currentPoint.y - touchPoint.y < 0) && bounds.height - (vConstant - cropTopConstraint.constant) > cropMinSize {
                self.cropBottomConstraint?.constant = vConstant
            }
        }
        lineButtonTouchPoint = currentPoint
        dimLayerMask(animated: false)
    }
    
    @objc private func cropButtonLeftDrag(_ sender: LineButton, forEvent event: UIEvent) {
        guard let cropLeadingConstraint = cropLeadingConstraint,
            let cropTrailingConstraint = cropTrailingConstraint else { return }
        guard let touchPoint = lineButtonTouchPoint, let currentPoint = event.touches(for: sender)?.first?.location(in: self) else { return }
        
        let hConstant = cropLeadingConstraint.constant - (currentPoint.x - touchPoint.x)
        
        if (hConstant <= 0 || currentPoint.x - touchPoint.x > 0) && bounds.width + (hConstant - cropTrailingConstraint.constant) > cropMinSize {
            self.cropLeadingConstraint?.constant = hConstant
        }
        lineButtonTouchPoint = currentPoint
        dimLayerMask(animated: false)
    }
    
    @objc private func cropButtonTopDrag(_ sender: LineButton, forEvent event: UIEvent) {
        guard let cropTopConstraint =  cropTopConstraint,
            let cropBottomConstraint =  cropBottomConstraint else { return }
        guard let touchPoint = lineButtonTouchPoint, let currentPoint = event.touches(for: sender)?.first?.location(in: self) else { return }
        
        let vConstant = cropTopConstraint.constant - (currentPoint.y - touchPoint.y)
        
        if (vConstant <= 0 || currentPoint.y - touchPoint.y > 0) && bounds.height + (vConstant - cropBottomConstraint.constant) > cropMinSize {
            self.cropTopConstraint?.constant = vConstant
        }
        lineButtonTouchPoint = currentPoint
        dimLayerMask(animated: false)
    }
    
    @objc private func cropButtonRightDrag(_ sender: LineButton, forEvent event: UIEvent) {
        guard let cropLeadingConstraint = cropLeadingConstraint,
            let cropTrailingConstraint = cropTrailingConstraint else { return }
        guard let touchPoint = lineButtonTouchPoint, let currentPoint = event.touches(for: sender)?.first?.location(in: self) else { return }
        
        lineButtonTouchPoint?.x = currentPoint.x
        
        let hConstant = cropTrailingConstraint.constant - (currentPoint.x - touchPoint.x)
        
        if (hConstant > 0 || currentPoint.x - touchPoint.x < 0) && bounds.width - (hConstant - cropLeadingConstraint.constant) > cropMinSize {
            self.cropTrailingConstraint?.constant = hConstant
        }
        lineButtonTouchPoint = currentPoint
        dimLayerMask(animated: false)
    }
    
    @objc private func cropButtonBottomDrag(_ sender: LineButton, forEvent event: UIEvent) {
        guard let cropTopConstraint =  cropTopConstraint,
            let cropBottomConstraint =  cropBottomConstraint else { return }
        guard let touchPoint = lineButtonTouchPoint, let currentPoint = event.touches(for: sender)?.first?.location(in: self) else { return }
        
        lineButtonTouchPoint?.y = currentPoint.y
        
        let vConstant = cropBottomConstraint.constant - (currentPoint.y - touchPoint.y)
        
        if (vConstant > 0 || currentPoint.y - touchPoint.y < 0) && bounds.height - (vConstant - cropTopConstraint.constant) > cropMinSize {
            self.cropBottomConstraint?.constant = vConstant
        }
        lineButtonTouchPoint = currentPoint
        dimLayerMask(animated: false)
    }
    
    @objc private func cropButtonCenterDrag(_ sender: LineButton, forEvent event: UIEvent) {
        guard let cropLeadingConstraint = cropLeadingConstraint,
            let cropTrailingConstraint = cropTrailingConstraint,
            let cropTopConstraint = cropTopConstraint,
            let cropBottomConstraint = cropBottomConstraint else { return }
        guard let touchPoint = lineButtonTouchPoint, let currentPoint = event.touches(for: sender)?.first?.location(in: self) else { return }
        
        let lConstant = cropLeadingConstraint.constant - (currentPoint.x - touchPoint.x)
        let rConstant = cropTrailingConstraint.constant - (currentPoint.x - touchPoint.x)
        
        if (lConstant <= 0 || currentPoint.x - touchPoint.x > 0) &&
            (rConstant > 0 || currentPoint.x - touchPoint.x < 0) {
            self.cropLeadingConstraint?.constant = lConstant
            self.cropTrailingConstraint?.constant = rConstant
        }
        
        let tConstant = cropTopConstraint.constant - (currentPoint.y - touchPoint.y)
        let bConstant = cropBottomConstraint.constant - (currentPoint.y - touchPoint.y)
        if (tConstant <= 0 || currentPoint.y - touchPoint.y > 0) &&
            (bConstant > 0 || currentPoint.y - touchPoint.y < 0) {
            self.cropTopConstraint?.constant = tConstant
            self.cropBottomConstraint?.constant = bConstant
        }
        lineButtonTouchPoint = currentPoint
        dimLayerMask(animated: false)
    }
}

// MARK: Private Method Image
extension CropPickerView {
    // Modify the contentOffset of the scrollView so that the scroll view fills the image.
    private func imageRealSize(_ animated: Bool = false) {
        if imageView.image == nil { return }
        scrollView.setZoomScale(1, animated: false)
        
        let imageSize = imageView.frameForImageInImageViewAspectFit
        let widthRate =  bounds.width / imageSize.width
        let heightRate = bounds.height / imageSize.height
        if widthRate < heightRate {
            scrollView.setZoomScale(heightRate, animated: animated)
        } else {
            scrollView.setZoomScale(widthRate, animated: animated)
        }
        let x = scrollView.contentSize.width/2 - scrollView.bounds.size.width/2
        let y = scrollView.contentSize.height/2 - scrollView.bounds.size.height/2
        scrollView.contentOffset = CGPoint(x: x, y: y)
    }
}

// MARK: Private Method Crop
extension CropPickerView {
    private func isImageRateHeightGreaterThan(_ imageSize: CGRect) -> Bool {
        let widthRate =  bounds.width / imageSize.width
        let heightRate = bounds.height / imageSize.height
        return widthRate < heightRate
    }
}

// MARK: Private Method Dim
extension CropPickerView {
    // Modify the dim screen mask.
    private func dimLayerMask(_ duration: TimeInterval = 0.4, animated: Bool) {
        guard let cropLeadingConstraint = cropLeadingConstraint,
            let cropTrailingConstraint = cropTrailingConstraint,
            let cropTopConstraint = cropTopConstraint,
            let cropBottomConstraint = cropBottomConstraint else { return }
        let width = scrollView.bounds.width - (-cropLeadingConstraint.constant + cropTrailingConstraint.constant)
        let height = scrollView.bounds.height - (-cropTopConstraint.constant + cropBottomConstraint.constant)
        dimView.layoutIfNeeded()
        
        delegate?.cropPickerView(self, didChange: CGRect(x: -cropLeadingConstraint.constant, y: -cropTopConstraint.constant, width: width, height: height))

        let path: UIBezierPath
        if radius == 0 {
            path = UIBezierPath(rect: CGRect(
                x: -cropLeadingConstraint.constant,
                y: -cropTopConstraint.constant,
                width: width,
                height: height
            ))
        } else {
            path = UIBezierPath(roundedRect: CGRect(
                x: -cropLeadingConstraint.constant,
                y: -cropTopConstraint.constant,
                width: width,
                height: height
            ), cornerRadius: radius)
        }
        path.append(UIBezierPath(rect: dimView.bounds))
        
        dimView.mask(path.cgPath, duration: duration, animated: animated)
    }
}

// MARK: LineButtonDelegate
extension CropPickerView: LineButtonDelegate {
    // When highlighted on the line button disappears, Enable interaction for all buttons.
    func lineButtonUnHighlighted() {
        lineButtonTouchPoint = nil
        cropView.line(true, animated: true)
        dimLayerMask(animated: false)
        lineButtonGroup
            .forEach { $0.isUserInteractionEnabled = true }
    }
}

// MARK: UIScrollViewDelegate
extension CropPickerView: UIScrollViewDelegate {
    public func scrollViewDidZoom(_ scrollView: UIScrollView) {
        if scrollView.zoomScale <= 1 {
            let offsetX = max((scrollView.bounds.width - scrollView.contentSize.width) * 0.5, 0)
            let offsetY = max((scrollView.bounds.height - scrollView.contentSize.height) * 0.5, 0)
            scrollView.contentInset = UIEdgeInsets(top: offsetY, left: offsetX, bottom: 0, right: 0)
        } else {
            let imageSize = imageView.frameForImageInImageViewAspectFit
            if isImageRateHeightGreaterThan(imageSize) {
                let imageOffset = -imageSize.origin.y
                let scrollOffset = (scrollView.bounds.height - scrollView.contentSize.height) * 0.5
                if imageOffset > scrollOffset {
                    scrollView.contentInset = UIEdgeInsets(top: imageOffset, left: 0, bottom: imageOffset, right: 0)
                } else {
                    scrollView.contentInset = UIEdgeInsets(top: scrollOffset, left: 0, bottom: scrollOffset, right: 0)
                }
            } else {
                let imageOffset = -imageSize.origin.x
                let scrollOffset = (scrollView.bounds.width - scrollView.contentSize.width) * 0.5
                if imageOffset > scrollOffset {
                    scrollView.contentInset = UIEdgeInsets(top: 0, left: imageOffset, bottom: 0, right: imageOffset)
                } else {
                    scrollView.contentInset = UIEdgeInsets(top: 0, left: scrollOffset, bottom: 0, right: scrollOffset)
                }
            }
        }
    }

    public func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }
}

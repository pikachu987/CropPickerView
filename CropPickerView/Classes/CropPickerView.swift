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
public protocol CropPickerViewDelegate: class {
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
            return self.imageView.image
        }
        set {
            self.imageView.image = newValue?.fixOrientation
            self.scrollView.setZoomScale(1, animated: false)
            self.initVars()
            self.cropLineHidden(self.image)
            self.scrollView.layoutIfNeeded()
            self.dimLayerMask(animated: false)
            DispatchQueue.main.async {
                self.imageMinAdjustment(animated: false)
            }
        }
    }
    
    // Set Image
    @IBInspectable
    public var changeImage: UIImage? {
        get {
            return self.imageView.image
        }
        set {
            self.imageView.image = newValue?.fixOrientation
        }
    }
    
    // Line color of crop view
    @IBInspectable
    public var cropLineColor: UIColor? {
        get {
            return self.cropView.lineColor
        }
        set {
            self.cropView.lineColor = newValue
            self.leftTopButton.edgeLine(newValue)
            self.leftBottomButton.edgeLine(newValue)
            self.rightTopButton.edgeLine(newValue)
            self.rightBottomButton.edgeLine(newValue)
            self.topButton.edgeLine(newValue)
            self.leftButton.edgeLine(newValue)
            self.rightButton.edgeLine(newValue)
            self.bottomButton.edgeLine(newValue)
        }
    }
    
    // Background color of scroll
    @IBInspectable
    public var scrollBackgroundColor: UIColor? {
        get {
            return self.scrollView.backgroundColor
        }
        set {
            self.scrollView.backgroundColor = newValue
        }
    }
    
    // Background color of image
    @IBInspectable
    public var imageBackgroundColor: UIColor? {
        get {
            return self.imageView.backgroundColor
        }
        set {
            self.imageView.backgroundColor = newValue
        }
    }
    
    // Color of dim view not in the crop area
    @IBInspectable
    public var dimBackgroundColor: UIColor? {
        get {
            return self.dimView.backgroundColor
        }
        set {
            self.dimView.backgroundColor = newValue
        }
    }
    
    // Minimum zoom for scrolling
    @IBInspectable
    public var scrollMinimumZoomScale: CGFloat {
        get {
            return self.scrollView.minimumZoomScale
        }
        set {
            self.scrollView.minimumZoomScale = newValue
        }
    }
    
    // Maximum zoom for scrolling
    @IBInspectable
    public var scrollMaximumZoomScale: CGFloat {
        get {
            return self.scrollView.maximumZoomScale
        }
        set {
            self.scrollView.maximumZoomScale = newValue
        }
    }

    // crop radius
    @IBInspectable
    public var radius: CGFloat = 0 {
        didSet {
            self.dimLayerMask(animated: false)
        }
    }

    // If false, the cropview and dimview will disappear and only the view will be zoomed in or out.
    public var isCrop = true {
        willSet {
            self.topButton.isHidden = !newValue
            self.bottomButton.isHidden = !newValue
            self.leftButton.isHidden = !newValue
            self.rightButton.isHidden = !newValue
            self.leftTopButton.isHidden = !newValue
            self.leftBottomButton.isHidden = !newValue
            self.rightTopButton.isHidden = !newValue
            self.rightBottomButton.isHidden = !newValue
            self.centerButton.isHidden = !newValue
            self.dimView.isHidden = !newValue
            self.cropView.isHidden = !newValue
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
    
    public var isSquare: Bool = false
    
    private var isInit = false
    
    // MARK: Init
    
    public override func awakeFromNib() {
        super.awakeFromNib()
        
        self.initVars()
    }
    
    public init(frame: CGRect = .zero, isSquare: Bool = false) {
        super.init(frame: frame)
        
        self.isSquare = isSquare
        self.initVars()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    // Max Image
    public func imageMaxAdjustment(_ duration: TimeInterval = 0.4, animated: Bool) {
        self.imageAdjustment(.zero, duration: duration, animated: animated)
    }
    
    // Min Image
    public func imageMinAdjustment(_ duration: TimeInterval = 0.4, animated: Bool) {
        var point: CGPoint
        let imageSize = self.imageView.frameForImageInImageViewAspectFit
        if self.isImageRateHeightGreaterThan(imageSize) {
            point = CGPoint(x: 0, y: imageSize.origin.y)
        } else {
            point = CGPoint(x: imageSize.origin.x, y: 0)
        }
        self.imageAdjustment(point, duration: duration, animated: animated)
    }
    
    public func imageAdjustment(_ point: CGPoint, duration: TimeInterval = 0.4, animated: Bool) {
        self.cropLeadingConstraint?.constant = -point.x
        self.cropTrailingConstraint?.constant = point.x
        self.cropTopConstraint?.constant = -point.y
        self.cropBottomConstraint?.constant = point.y
        if animated {
            self.dimLayerMask(duration, animated: animated)
            UIView.animate(withDuration: duration, delay: 0, options: UIView.AnimationOptions.curveEaseInOut, animations: {
                self.layoutIfNeeded()
            }, completion: nil)
        } else {
            self.dimLayerMask(duration, animated: animated)
        }
    }

    /*
     image: UIImage
     isMin: Bool set image after min or max image
     crop: set image after crop size
     isRealCropRect: image real crop or image frame crop
    */
    public func image(_ image: UIImage?, isMin: Bool = true, crop: CGRect? = nil, isRealCropRect: Bool = false) {
        self.imageView.image = image?.fixOrientation
        if isMin {
            self.scrollView.setZoomScale(1, animated: false)
        } else {
            self.imageRealSize(false)
        }
        self.initVars()
        self.cropLineHidden(image)
        self.scrollView.layoutIfNeeded()
        self.dimLayerMask(animated: false)
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
            if self.isSquare {
                let width = self.bounds.width + leading - trailing
                let height = self.bounds.height + top - bottom
                let widthRate = width / self.bounds.width
                let heightRate = height / self.bounds.height
                if widthRate > heightRate {
                    let margin = (self.bounds.width - height) / 2
                    if margin > 0 {
                        leading = -margin
                        trailing = margin
                    } else {
                        let margin = (self.bounds.height - width) / 2
                        top = -margin
                        bottom = margin
                    }
                } else {
                    let margin = (self.bounds.height - width) / 2
                    if margin > 0 {
                        top = -margin
                        bottom = margin
                    } else {
                        let margin = (self.bounds.width - height) / 2
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
        guard let image = self.imageView.image?.fixOrientation else {
            cropResult.error = NSError(domain: "Image is empty.", code: 404, userInfo: nil)
            handler?(cropResult)
            self.delegate?.cropPickerView(self, result: cropResult)
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
        return [self.leftTopButton, self.leftBottomButton, self.rightTopButton, self.rightBottomButton, self.topButton, self.leftButton, self.bottomButton, self.rightButton, self.centerButton]
    }
    
    // Init
    private func initVars() {
        if self.isInit { return }
        self.isInit = true
        self.addSubview(self.scrollView)
        self.addSubview(self.cropView)
        self.addSubview(self.dimView)
        self.addSubview(self.leftTopButton)
        self.addSubview(self.leftBottomButton)
        self.addSubview(self.rightTopButton)
        self.addSubview(self.rightBottomButton)
        self.addSubview(self.topButton)
        self.addSubview(self.leftButton)
        self.addSubview(self.rightButton)
        self.addSubview(self.bottomButton)
        self.addSubview(self.centerButton)
        self.scrollView.addSubview(self.imageView)
        
        self.edgesConstraint(subView: self.scrollView)
        
        self.scrollView.edgesConstraint(subView: self.imageView)
        self.scrollView.sizeConstraint(subView: self.imageView)
        
        self.edgesConstraint(subView: self.dimView)
        
        self.cropLeadingConstraint = self.leadingConstraint(subView: self.cropView, constant: 0).priority(945)
        self.cropTrailingConstraint = self.trailingConstraint(subView: self.cropView, constant: 0).priority(945)
        self.cropTopConstraint = self.topConstraint(subView: self.cropView, constant: 0).priority(945)
        self.cropBottomConstraint = self.bottomConstraint(subView: self.cropView, constant: 0).priority(945)

        self.topConstraint(item: self.cropView, subView: self.leftTopButton, constant: 10)
        self.leadingConstraint(item: self.cropView, subView: self.leftTopButton, constant: 10)
        
        self.bottomConstraint(item: self.cropView, subView: self.leftBottomButton, constant: -10)
        self.leadingConstraint(item: self.cropView, subView: self.leftBottomButton, constant: 10)
        
        self.topConstraint(item: self.cropView, subView: self.rightTopButton, constant: 10)
        self.trailingConstraint(item: self.cropView, subView: self.rightTopButton, constant: -10)
        
        self.bottomConstraint(item: self.cropView, subView: self.rightBottomButton, constant: -10)
        self.trailingConstraint(item: self.cropView, subView: self.rightBottomButton, constant: -10)
        
        self.topConstraint(item: self.cropView, subView: self.topButton, constant: 10)
        self.centerXConstraint(item: self.cropView, subView: self.topButton)
        
        self.centerYConstraint(item: self.cropView, subView: self.leftButton)
        self.leadingConstraint(item: self.cropView, subView: self.leftButton, constant: 10)
        
        self.centerYConstraint(item: self.cropView, subView: self.rightButton)
        self.trailingConstraint(item: self.cropView, subView: self.rightButton, constant: -10)
        
        self.bottomConstraint(item: self.cropView, subView: self.bottomButton, constant: -10)
        self.centerXConstraint(item: self.cropView, subView: self.bottomButton)
        
        self.centerButton.widthConstraint(constant: 80, relatedBy: .equal).priority = UILayoutPriority(700)
        self.centerButton.heightConstraint(constant: 80, relatedBy: .equal).priority = UILayoutPriority(700)
        self.centerXConstraint(item: self.cropView, subView: self.centerButton)
        self.centerYConstraint(item: self.cropView, subView: self.centerButton)
        
        let leading = NSLayoutConstraint(item: self.leftButton, attribute: .trailing, relatedBy: .greaterThanOrEqual, toItem: self.centerButton, attribute: .leading, multiplier: 1, constant: 0)
        let trailing = NSLayoutConstraint(item: self.rightButton, attribute: .leading, relatedBy: .greaterThanOrEqual, toItem: self.centerButton, attribute: .trailing, multiplier: 1, constant: 0)
        let top = NSLayoutConstraint(item: self.topButton, attribute: .bottom, relatedBy: .greaterThanOrEqual, toItem: self.centerButton, attribute: .top, multiplier: 1, constant: 0)
        let bottom = NSLayoutConstraint(item: self.bottomButton, attribute: .top, relatedBy: .greaterThanOrEqual, toItem: self.centerButton, attribute: .bottom, multiplier: 1, constant: 0)
        
        leading.priority = UILayoutPriority(600)
        trailing.priority = UILayoutPriority(600)
        top.priority = UILayoutPriority(600)
        bottom.priority = UILayoutPriority(600)
        
        self.addConstraints([leading, trailing, top, bottom])
        
        self.scrollView.clipsToBounds = true
        self.scrollView.delegate = self
        self.scrollView.showsVerticalScrollIndicator = false
        self.scrollView.showsHorizontalScrollIndicator = false
        
        self.imageView.clipsToBounds = true
        self.imageView.contentMode = .scaleAspectFit
        
        self.cropLineHidden(self.image)
        
        self.cropLineColor = self.cropLineColor ?? .white
        self.scrollMinimumZoomScale = 0.3
        self.scrollMaximumZoomScale = 5
        self.scrollBackgroundColor = self.scrollBackgroundColor ?? .black
        self.imageBackgroundColor = self.imageBackgroundColor ?? .black
        self.dimBackgroundColor = self.dimBackgroundColor ?? UIColor(white: 0, alpha: 0.6)
        
        let doubleTapGesture = UITapGestureRecognizer(target: self, action: #selector(self.imageDoubleTap(_:)))
        doubleTapGesture.numberOfTapsRequired = 2
        self.scrollView.addGestureRecognizer(doubleTapGesture)
        
        self.lineButtonGroup.forEach { (button) in
            button.delegate = self
            button.addTarget(self, action: #selector(self.cropButtonTouchDown(_:forEvent:)), for: .touchDown)
            button.addTarget(self, action: #selector(self.cropButtonTouchUpInside(_:forEvent:)), for: .touchUpInside)
        }
        
        self.leftTopButton.addTarget(self, action: #selector(self.cropButtonLeftTopDrag(_:forEvent:)), for: .touchDragInside)
        self.leftBottomButton.addTarget(self, action: #selector(self.cropButtonLeftBottomDrag(_:forEvent:)), for: .touchDragInside)
        self.rightTopButton.addTarget(self, action: #selector(self.cropButtonRightTopDrag(_:forEvent:)), for: .touchDragInside)
        self.rightBottomButton.addTarget(self, action: #selector(self.cropButtonRightBottomDrag(_:forEvent:)), for: .touchDragInside)
        self.topButton.addTarget(self, action: #selector(self.cropButtonTopDrag(_:forEvent:)), for: .touchDragInside)
        self.leftButton.addTarget(self, action: #selector(self.cropButtonLeftDrag(_:forEvent:)), for: .touchDragInside)
        self.rightButton.addTarget(self, action: #selector(self.cropButtonRightDrag(_:forEvent:)), for: .touchDragInside)
        self.bottomButton.addTarget(self, action: #selector(self.cropButtonBottomDrag(_:forEvent:)), for: .touchDragInside)
        
        self.centerButton.addTarget(self, action: #selector(self.centerDoubleTap(_:)), for: .touchDownRepeat)
        self.centerButton.addTarget(self, action: #selector(self.cropButtonCenterDrag(_:forEvent:)), for: .touchDragInside)
        
        if self.isSquare {
            self.topButton.isHidden = true
            self.leftButton.isHidden = true
            self.bottomButton.isHidden = true
            self.rightButton.isHidden = true
        }
        
        self.layoutIfNeeded()
    }
    
    // Does not display lines when the image is nil.
    private func cropLineHidden(_ image: UIImage?) {
        self.cropView.alpha = image == nil ? 0 : 1
        self.leftTopButton.alpha = image == nil ? 0 : 1
        self.leftBottomButton.alpha = image == nil ? 0 : 1
        self.rightBottomButton.alpha = image == nil ? 0 : 1
        self.rightTopButton.alpha = image == nil ? 0 : 1
        self.topButton.alpha = image == nil ? 0 : 1
        self.bottomButton.alpha = image == nil ? 0 : 1
        self.leftButton.alpha = image == nil ? 0 : 1
        self.rightButton.alpha = image == nil ? 0 : 1
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
        if self.scrollView.zoomScale == 1 {
            self.imageRealSize(true)
            DispatchQueue.main.async {
                self.imageMaxAdjustment(animated: true)
            }
        } else {
            self.scrollView.setZoomScale(1, animated: true)
            DispatchQueue.main.async {
                self.imageMinAdjustment(animated: true)
            }
        }
    }
    
    // Touch Down Button
    @objc private func cropButtonTouchDown(_ sender: LineButton, forEvent event: UIEvent) {
        guard let touch = event.touches(for: sender)?.first else { return }
        self.lineButtonTouchPoint = touch.location(in: self.cropView)
        self.cropView.line(false, animated: true)
        self.dimLayerMask(animated: false)
        self.lineButtonGroup
            .filter { sender != $0 }
            .forEach { $0.isUserInteractionEnabled = false }
    }
    
    
    // Touch Up Inside Button
    @objc private func cropButtonTouchUpInside(_ sender: LineButton, forEvent event: UIEvent) {
        self.lineButtonTouchPoint = nil
        self.cropView.line(true, animated: true)
        self.dimLayerMask(animated: false)
        self.lineButtonGroup
            .forEach { $0.isUserInteractionEnabled = true }
    }
    
    private func cropButtonDrag(_ sender: LineButton, forEvent event: UIEvent) -> CGPoint? {
        guard let touch = event.touches(for: sender)?.first else { return nil }
        return touch.location(in: self.cropView)
    }
    
    @objc private func cropButtonLeftTopDrag(_ sender: LineButton, forEvent event: UIEvent) {
        guard let cropLeadingConstraint = self.cropLeadingConstraint,
            let cropTrailingConstraint = self.cropTrailingConstraint,
            let cropTopConstraint =  self.cropTopConstraint,
            let cropBottomConstraint =  self.cropBottomConstraint else { return }
        guard let touchPoint = self.lineButtonTouchPoint,
            let currentPoint = self.cropButtonDrag(sender, forEvent: event) else { return }
        
        let hConstant = cropLeadingConstraint.constant - (currentPoint.x - touchPoint.x)
        let vConstant = cropTopConstraint.constant - (currentPoint.y - touchPoint.y)
        
        if self.isSquare {
            if currentPoint.x - touchPoint.x > currentPoint.y - touchPoint.y {
                let width = self.bounds.width + hConstant - (self.cropTrailingConstraint?.constant ?? 0)
                let vConstant = self.bounds.height - (self.cropBottomConstraint?.constant ?? 0) - width
                if (-hConstant) >= 0 && vConstant >= 0 {
                    self.cropLeadingConstraint?.constant = hConstant
                    self.cropTopConstraint?.constant = -vConstant
                }
            } else {
                let height = self.bounds.height + vConstant - (self.cropBottomConstraint?.constant ?? 0)
                let hConstant = self.bounds.width - (self.cropTrailingConstraint?.constant ?? 0) - height
                if hConstant >= 0 && (-vConstant) >= 0 {
                    self.cropTopConstraint?.constant = vConstant
                    self.cropLeadingConstraint?.constant = -hConstant
                }
            }
        } else {
            if (hConstant <= 0 || currentPoint.x - touchPoint.x > 0) && self.bounds.width + (hConstant - cropTrailingConstraint.constant) > self.cropMinSize {
                self.cropLeadingConstraint?.constant = hConstant
            }
            if (vConstant <= 0 || currentPoint.y - touchPoint.y > 0) && self.bounds.height + (vConstant - cropBottomConstraint.constant) > self.cropMinSize {
                self.cropTopConstraint?.constant = vConstant
            }
        }
        self.dimLayerMask(animated: false)
    }
    
    @objc private func cropButtonLeftBottomDrag(_ sender: LineButton, forEvent event: UIEvent) {
        guard let cropLeadingConstraint = self.cropLeadingConstraint,
            let cropTrailingConstraint = self.cropTrailingConstraint,
            let cropTopConstraint =  self.cropTopConstraint,
            let cropBottomConstraint =  self.cropBottomConstraint else { return }
        guard let touchPoint = self.lineButtonTouchPoint,
            let currentPoint = self.cropButtonDrag(sender, forEvent: event) else { return }
        
        self.lineButtonTouchPoint?.y = currentPoint.y
        
        let hConstant = cropLeadingConstraint.constant - (currentPoint.x - touchPoint.x)
        let vConstant = cropBottomConstraint.constant - (currentPoint.y - touchPoint.y)
        
        if self.isSquare {
//            print("currentPoint.x - touchPoint.x: \(currentPoint.x - touchPoint.x), currentPoint.y - touchPoint.y: \(currentPoint.y - touchPoint.y)")
            if currentPoint.x - touchPoint.x < -(currentPoint.y - touchPoint.y) {
                let width = self.bounds.width + hConstant - (self.cropTrailingConstraint?.constant ?? 0)
                let vConstant = self.bounds.height + (self.cropTopConstraint?.constant ?? 0) - width
                print("hConstant: \(hConstant), vConstant: \(vConstant)")
//                if (-hConstant) >= 0 && (-vConstant) >= 0 {
                    self.cropLeadingConstraint?.constant = hConstant
                    self.cropBottomConstraint?.constant = vConstant
//                }
            } else {
//                let height = self.bounds.height + vConstant - (self.cropBottomConstraint?.constant ?? 0)
//                let hConstant = self.bounds.width - (self.cropTrailingConstraint?.constant ?? 0) - height
//                if hConstant >= 0 && (-vConstant) >= 0 {
//                    self.cropTopConstraint?.constant = vConstant
//                    self.cropLeadingConstraint?.constant = -hConstant
//                }
            }
        } else {
            if (hConstant <= 0 || currentPoint.x - touchPoint.x > 0) && self.bounds.width + (hConstant - cropTrailingConstraint.constant) > self.cropMinSize {
                self.cropLeadingConstraint?.constant = hConstant
            }
            if (vConstant > 0 || currentPoint.y - touchPoint.y < 0) && self.bounds.height - (vConstant - cropTopConstraint.constant) > self.cropMinSize {
                self.cropBottomConstraint?.constant = vConstant
            }
        }
        self.dimLayerMask(animated: false)
    }
    
    @objc private func cropButtonRightTopDrag(_ sender: LineButton, forEvent event: UIEvent) {
        guard let cropLeadingConstraint = self.cropLeadingConstraint,
            let cropTrailingConstraint = self.cropTrailingConstraint,
            let cropTopConstraint =  self.cropTopConstraint,
            let cropBottomConstraint =  self.cropBottomConstraint else { return }
        guard let touchPoint = self.lineButtonTouchPoint,
            let currentPoint = self.cropButtonDrag(sender, forEvent: event) else { return }
        
        self.lineButtonTouchPoint?.x = currentPoint.x
        
        let hConstant = cropTrailingConstraint.constant - (currentPoint.x - touchPoint.x)
        let vConstant = cropTopConstraint.constant - (currentPoint.y - touchPoint.y)
        
        if (hConstant > 0 || currentPoint.x - touchPoint.x < 0) && self.bounds.width - (hConstant - cropLeadingConstraint.constant) > self.cropMinSize {
            self.cropTrailingConstraint?.constant = hConstant
        }
        if (vConstant <= 0 || currentPoint.y - touchPoint.y > 0) && self.bounds.height + (vConstant - cropBottomConstraint.constant) > self.cropMinSize {
            self.cropTopConstraint?.constant = vConstant
        }
        self.dimLayerMask(animated: false)
    }
    
    @objc private func cropButtonRightBottomDrag(_ sender: LineButton, forEvent event: UIEvent) {
        guard let cropLeadingConstraint = self.cropLeadingConstraint,
            let cropTrailingConstraint = self.cropTrailingConstraint,
            let cropTopConstraint =  self.cropTopConstraint,
            let cropBottomConstraint =  self.cropBottomConstraint else { return }
        guard let touchPoint = self.lineButtonTouchPoint,
            let currentPoint = self.cropButtonDrag(sender, forEvent: event) else { return }
        
        self.lineButtonTouchPoint?.x = currentPoint.x
        self.lineButtonTouchPoint?.y = currentPoint.y
        
        let hConstant = cropTrailingConstraint.constant - (currentPoint.x - touchPoint.x)
        let vConstant = cropBottomConstraint.constant - (currentPoint.y - touchPoint.y)
        
        if (hConstant > 0 || currentPoint.x - touchPoint.x < 0) && self.bounds.width - (hConstant - cropLeadingConstraint.constant) > self.cropMinSize {
            self.cropTrailingConstraint?.constant = hConstant
        }
        if (vConstant > 0 || currentPoint.y - touchPoint.y < 0) && self.bounds.height - (vConstant - cropTopConstraint.constant) > self.cropMinSize {
            self.cropBottomConstraint?.constant = vConstant
        }
        self.dimLayerMask(animated: false)
    }
    
    @objc private func cropButtonLeftDrag(_ sender: LineButton, forEvent event: UIEvent) {
        guard let cropLeadingConstraint = self.cropLeadingConstraint,
            let cropTrailingConstraint = self.cropTrailingConstraint else { return }
        guard let touchPoint = self.lineButtonTouchPoint,
            let currentPoint = self.cropButtonDrag(sender, forEvent: event) else { return }
        
        let hConstant = cropLeadingConstraint.constant - (currentPoint.x - touchPoint.x)
        
        if (hConstant <= 0 || currentPoint.x - touchPoint.x > 0) && self.bounds.width + (hConstant - cropTrailingConstraint.constant) > self.cropMinSize {
            self.cropLeadingConstraint?.constant = hConstant
        }
        self.dimLayerMask(animated: false)
    }
    
    @objc private func cropButtonTopDrag(_ sender: LineButton, forEvent event: UIEvent) {
        guard let cropTopConstraint =  self.cropTopConstraint,
            let cropBottomConstraint =  self.cropBottomConstraint else { return }
        guard let touchPoint = self.lineButtonTouchPoint,
            let currentPoint = self.cropButtonDrag(sender, forEvent: event) else { return }
        
        let vConstant = cropTopConstraint.constant - (currentPoint.y - touchPoint.y)
        
        if (vConstant <= 0 || currentPoint.y - touchPoint.y > 0) && self.bounds.height + (vConstant - cropBottomConstraint.constant) > self.cropMinSize {
            self.cropTopConstraint?.constant = vConstant
        }
        self.dimLayerMask(animated: false)
    }
    
    @objc private func cropButtonRightDrag(_ sender: LineButton, forEvent event: UIEvent) {
        guard let cropLeadingConstraint = self.cropLeadingConstraint,
            let cropTrailingConstraint = self.cropTrailingConstraint else { return }
        guard let touchPoint = self.lineButtonTouchPoint,
            let currentPoint = self.cropButtonDrag(sender, forEvent: event) else { return }
        
        self.lineButtonTouchPoint?.x = currentPoint.x
        
        let hConstant = cropTrailingConstraint.constant - (currentPoint.x - touchPoint.x)
        
        if (hConstant > 0 || currentPoint.x - touchPoint.x < 0) && self.bounds.width - (hConstant - cropLeadingConstraint.constant) > self.cropMinSize {
            self.cropTrailingConstraint?.constant = hConstant
        }
        self.dimLayerMask(animated: false)
    }
    
    @objc private func cropButtonBottomDrag(_ sender: LineButton, forEvent event: UIEvent) {
        guard let cropTopConstraint =  self.cropTopConstraint,
            let cropBottomConstraint =  self.cropBottomConstraint else { return }
        guard let touchPoint = self.lineButtonTouchPoint,
            let currentPoint = self.cropButtonDrag(sender, forEvent: event) else { return }
        
        self.lineButtonTouchPoint?.y = currentPoint.y
        
        let vConstant = cropBottomConstraint.constant - (currentPoint.y - touchPoint.y)
        
        if (vConstant > 0 || currentPoint.y - touchPoint.y < 0) && self.bounds.height - (vConstant - cropTopConstraint.constant) > self.cropMinSize {
            self.cropBottomConstraint?.constant = vConstant
        }
        self.dimLayerMask(animated: false)
    }
    
    @objc private func cropButtonCenterDrag(_ sender: LineButton, forEvent event: UIEvent) {
        guard let cropLeadingConstraint = self.cropLeadingConstraint,
            let cropTrailingConstraint = self.cropTrailingConstraint,
            let cropTopConstraint =  self.cropTopConstraint,
            let cropBottomConstraint =  self.cropBottomConstraint else { return }
        guard let touchPoint = self.lineButtonTouchPoint,
            let currentPoint = self.cropButtonDrag(sender, forEvent: event) else { return }
        
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
        self.dimLayerMask(animated: false)
    }
}

// MARK: Private Method Image
extension CropPickerView {
    // Modify the contentOffset of the scrollView so that the scroll view fills the image.
    private func imageRealSize(_ animated: Bool = false) {
        if self.imageView.image == nil { return }
        self.scrollView.setZoomScale(1, animated: false)
        
        let imageSize = self.imageView.frameForImageInImageViewAspectFit
        let widthRate =  self.bounds.width / imageSize.width
        let heightRate = self.bounds.height / imageSize.height
        if widthRate < heightRate {
            self.scrollView.setZoomScale(heightRate, animated: animated)
        } else {
            self.scrollView.setZoomScale(widthRate, animated: animated)
        }
        let x = self.scrollView.contentSize.width/2 - self.scrollView.bounds.size.width/2
        let y = self.scrollView.contentSize.height/2 - self.scrollView.bounds.size.height/2
        self.scrollView.contentOffset = CGPoint(x: x, y: y)
    }
}

// MARK: Private Method Crop
extension CropPickerView {
    private func isImageRateHeightGreaterThan(_ imageSize: CGRect) -> Bool {
        let widthRate =  self.bounds.width / imageSize.width
        let heightRate = self.bounds.height / imageSize.height
        return widthRate < heightRate
    }
}

// MARK: Private Method Dim
extension CropPickerView {
    // Modify the dim screen mask.
    private func dimLayerMask(_ duration: TimeInterval = 0.4, animated: Bool) {
        guard let cropLeadingConstraint = self.cropLeadingConstraint,
            let cropTrailingConstraint = self.cropTrailingConstraint,
            let cropTopConstraint = self.cropTopConstraint,
            let cropBottomConstraint = self.cropBottomConstraint else { return }
        let width = self.scrollView.bounds.width - (-cropLeadingConstraint.constant + cropTrailingConstraint.constant)
        let height = self.scrollView.bounds.height - (-cropTopConstraint.constant + cropBottomConstraint.constant)
        self.dimView.layoutIfNeeded()
        
        self.delegate?.cropPickerView(self, didChange: CGRect(x: -cropLeadingConstraint.constant, y: -cropTopConstraint.constant, width: width, height: height))

        let path: UIBezierPath
        if self.radius == 0 {
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
            ), cornerRadius: self.radius)
        }
        path.append(UIBezierPath(rect: self.dimView.bounds))
        
        self.dimView.mask(path.cgPath, duration: duration, animated: animated)
    }
}

// MARK: LineButtonDelegate
extension CropPickerView: LineButtonDelegate {
    // When highlighted on the line button disappears, Enable interaction for all buttons.
    func lineButtonUnHighlighted() {
        self.lineButtonTouchPoint = nil
        self.cropView.line(true, animated: true)
        self.dimLayerMask(animated: false)
        self.lineButtonGroup
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
            let imageSize = self.imageView.frameForImageInImageViewAspectFit
            if self.isImageRateHeightGreaterThan(imageSize) {
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
        return self.imageView
    }
}

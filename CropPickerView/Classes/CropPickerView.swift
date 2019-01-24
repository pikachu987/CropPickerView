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
    // Called when the image is successfully extracted.
    func cropPickerView(_ cropPickerView: CropPickerView, image: UIImage)
    // Called when an attempt to extract an image fails.
    func cropPickerView(_ cropPickerView: CropPickerView, error: Error)
}

@IBDesignable
public class CropPickerView: UIView {
    public weak var delegate: CropPickerViewDelegate?
    
    // MARK: Public Property
    
    // Set Image
    @IBInspectable
    public var image: UIImage? {
        get {
            return self.imageView.image
        }
        set {
            self.imageView.image = newValue
            self.scrollView.setZoomScale(1, animated: false)
            if self.scrollView.delegate == nil {
                self.initVars()
            } 
            self.cropLineHidden(newValue)
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
            self.imageView.image = newValue
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
    
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        self.addSubview(scrollView)
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        self.edgesConstraint(subView: scrollView)
        return scrollView
    }()
    
    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        self.scrollView.addSubview(imageView)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        self.scrollView.edgesConstraint(subView: imageView)
        self.scrollView.sizeConstraint(subView: imageView)
        return imageView
    }()
    
    private lazy var dimView: CropDimView = {
        self.scrollView.alpha = 1
        let view = CropDimView()
        self.addSubview(view)
        view.translatesAutoresizingMaskIntoConstraints = false
        self.edgesConstraint(subView: view)
        return view
    }()
    
    private lazy var cropView: CropView = {
        self.dimView.alpha = 1
        let cropView = CropView()
        self.addSubview(cropView)
        cropView.translatesAutoresizingMaskIntoConstraints = false
        self.cropLeadingConstraint = self.leadingConstraint(subView: cropView, constant: 0).priority(945)
        self.cropTrailingConstraint = self.trailingConstraint(subView: cropView, constant: 0).priority(945)
        self.cropTopConstraint = self.topConstraint(subView: cropView, constant: 0).priority(945)
        self.cropBottomConstraint = self.bottomConstraint(subView: cropView, constant: 0).priority(945)
        return cropView
    }()
    
    // Side button and corner button of crop
    
    private lazy var leftTopButton: LineButton = {
        let button = LineButton(.leftTop)
        let cropView = self.cropView
        self.addSubview(button)
        self.topConstraint(item: cropView, subView: button, constant: 10)
        self.leadingConstraint(item: cropView, subView: button, constant: 10)
        button.addTarget(self, action: #selector(self.cropButtonLeftTopDrag(_:forEvent:)), for: .touchDragInside)
        return button
    }()
    
    private lazy var leftBottomButton: LineButton = {
        let button = LineButton(.leftBottom)
        let cropView = self.cropView
        self.addSubview(button)
        self.bottomConstraint(item: cropView, subView: button, constant: -10)
        self.leadingConstraint(item: cropView, subView: button, constant: 10)
        button.addTarget(self, action: #selector(self.cropButtonLeftBottomDrag(_:forEvent:)), for: .touchDragInside)
        return button
    }()
    
    private lazy var rightTopButton: LineButton = {
        let button = LineButton(.rightTop)
        let cropView = self.cropView
        self.addSubview(button)
        self.topConstraint(item: cropView, subView: button, constant: 10)
        self.trailingConstraint(item: cropView, subView: button, constant: -10)
        button.addTarget(self, action: #selector(self.cropButtonRightTopDrag(_:forEvent:)), for: .touchDragInside)
        return button
    }()
    
    private lazy var rightBottomButton: LineButton = {
        let button = LineButton(.rightBottom)
        let cropView = self.cropView
        self.addSubview(button)
        self.bottomConstraint(item: cropView, subView: button, constant: -10)
        self.trailingConstraint(item: cropView, subView: button, constant: -10)
        button.addTarget(self, action: #selector(self.cropButtonRightBottomDrag(_:forEvent:)), for: .touchDragInside)
        return button
    }()
    
    private lazy var topButton: LineButton = {
        let button = LineButton(.top)
        let cropView = self.cropView
        self.addSubview(button)
        self.topConstraint(item: cropView, subView: button, constant: 10)
        self.centerXConstraint(item: cropView, subView: button)
        button.addTarget(self, action: #selector(self.cropButtonTopDrag(_:forEvent:)), for: .touchDragInside)
        return button
    }()
    
    private lazy var leftButton: LineButton = {
        let button = LineButton(.left)
        let cropView = self.cropView
        self.addSubview(button)
        self.centerYConstraint(item: cropView, subView: button)
        self.leadingConstraint(item: cropView, subView: button, constant: 10)
        button.addTarget(self, action: #selector(self.cropButtonLeftDrag(_:forEvent:)), for: .touchDragInside)
        return button
    }()
    
    private lazy var rightButton: LineButton = {
        let button = LineButton(.right)
        let cropView = self.cropView
        self.addSubview(button)
        self.centerYConstraint(item: cropView, subView: button)
        self.trailingConstraint(item: cropView, subView: button, constant: -10)
        button.addTarget(self, action: #selector(self.cropButtonRightDrag(_:forEvent:)), for: .touchDragInside)
        return button
    }()
    
    private lazy var bottomButton: LineButton = {
        let button = LineButton(.bottom)
        let cropView = self.cropView
        self.addSubview(button)
        self.bottomConstraint(item: cropView, subView: button, constant: -10)
        self.centerXConstraint(item: cropView, subView: button)
        button.addTarget(self, action: #selector(self.cropButtonBottomDrag(_:forEvent:)), for: .touchDragInside)
        return button
    }()
    
    private lazy var centerButton: LineButton = {
        let button = LineButton(.center)
        self.addSubview(button)
        button.widthConstraint(constant: 80, relatedBy: .equal).priority = UILayoutPriority(700)
        button.heightConstraint(constant: 80, relatedBy: .equal).priority = UILayoutPriority(700)
        self.centerXConstraint(item: self.cropView, subView: button)
        self.centerYConstraint(item: self.cropView, subView: button)
        
        let leading = NSLayoutConstraint(item: self.leftButton, attribute: .trailing, relatedBy: .greaterThanOrEqual, toItem: button, attribute: .leading, multiplier: 1, constant: 0)
        let trailing = NSLayoutConstraint(item: self.rightButton, attribute: .leading, relatedBy: .greaterThanOrEqual, toItem: button, attribute: .trailing, multiplier: 1, constant: 0)
        let top = NSLayoutConstraint(item: self.topButton, attribute: .bottom, relatedBy: .greaterThanOrEqual, toItem: button, attribute: .top, multiplier: 1, constant: 0)
        let bottom = NSLayoutConstraint(item: self.bottomButton, attribute: .top, relatedBy: .greaterThanOrEqual, toItem: button, attribute: .bottom, multiplier: 1, constant: 0)
        
        leading.priority = UILayoutPriority(600)
        trailing.priority = UILayoutPriority(600)
        top.priority = UILayoutPriority(600)
        bottom.priority = UILayoutPriority(600)
        
        self.addConstraints([leading, trailing, top, bottom])
        button.addTarget(self, action: #selector(self.centerDoubleTap(_:)), for: .touchDownRepeat)
        button.addTarget(self, action: #selector(self.cropButtonCenterDrag(_:forEvent:)), for: .touchDragInside)
        return button
    }()
    
    private var cropLeadingConstraint: NSLayoutConstraint?
    
    private var cropTrailingConstraint: NSLayoutConstraint?
    
    private var cropTopConstraint: NSLayoutConstraint?
    
    private var cropBottomConstraint: NSLayoutConstraint?
    
    private var lineButtonTouchPoint: CGPoint?
    
    // MARK: Init
    
    public override func awakeFromNib() {
        super.awakeFromNib()
        
        if self.scrollView.delegate == nil {
            self.initVars()
        }
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        
        if self.scrollView.delegate == nil {
            self.initVars()
        }
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    
    // MARK: Public Method
    
    /**
     crop method.
     If there is no image to crop, Error 404 is displayed.
     If there is no image in the crop area, Error 503 is displayed.
     If the image is successfully cropped, the success delegate or callback function is called.
     **/
    public func crop(_ handler: ((Error?, UIImage?) -> Void)? = nil) {
        guard let image = self.imageView.image else {
            let error = NSError(domain: "Image is empty.", code: 404, userInfo: nil)
            handler?(error, nil)
            self.delegate?.cropPickerView(self, error: error)
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
            let x = (self.scrollView.contentOffset.x + self.cropView.frame.origin.x - imageFrame.origin.x) * scale * factor
            let y = (self.scrollView.contentOffset.y + self.cropView.frame.origin.y - imageFrame.origin.y) * scale * factor
            let width = self.cropView.frame.size.width * scale * factor
            let height = self.cropView.frame.size.height * scale * factor
            let cropArea = CGRect(x: x, y: y, width: width, height: height)
            
            guard let cropCGImage = image.cgImage?.cropping(to: cropArea) else {
                let error = NSError(domain: "There is no image in the Crop area.", code: 503, userInfo: nil)
                handler?(error, nil)
                self.delegate?.cropPickerView(self, error: error)
                return
            }
            let cropImage = UIImage(cgImage: cropCGImage)
            handler?(nil, cropImage)
            self.delegate?.cropPickerView(self, image: cropImage)
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
        
        if (hConstant <= 0 || currentPoint.x - touchPoint.x > 0) && self.bounds.width + (hConstant - cropTrailingConstraint.constant) > 100 {
            self.cropLeadingConstraint?.constant = hConstant
        }
        if (vConstant <= 0 || currentPoint.y - touchPoint.y > 0) && self.bounds.height + (vConstant - cropBottomConstraint.constant) > 100 {
            self.cropTopConstraint?.constant = vConstant
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
        
        if (hConstant <= 0 || currentPoint.x - touchPoint.x > 0) && self.bounds.width + (hConstant - cropTrailingConstraint.constant) > 100 {
            self.cropLeadingConstraint?.constant = hConstant
        }
        if (vConstant > 0 || currentPoint.y - touchPoint.y < 0) && self.bounds.height - (vConstant - cropTopConstraint.constant) > 100 {
            self.cropBottomConstraint?.constant = vConstant
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
        
        if (hConstant > 0 || currentPoint.x - touchPoint.x < 0) && self.bounds.width - (hConstant - cropLeadingConstraint.constant) > 100 {
            self.cropTrailingConstraint?.constant = hConstant
        }
        if (vConstant <= 0 || currentPoint.y - touchPoint.y > 0) && self.bounds.height + (vConstant - cropBottomConstraint.constant) > 100 {
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
        
        if (hConstant > 0 || currentPoint.x - touchPoint.x < 0) && self.bounds.width - (hConstant - cropLeadingConstraint.constant) > 100 {
            self.cropTrailingConstraint?.constant = hConstant
        }
        if (vConstant > 0 || currentPoint.y - touchPoint.y < 0) && self.bounds.height - (vConstant - cropTopConstraint.constant) > 100 {
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
        
        if (hConstant <= 0 || currentPoint.x - touchPoint.x > 0) && self.bounds.width + (hConstant - cropTrailingConstraint.constant) > 100 {
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
        
        if (vConstant <= 0 || currentPoint.y - touchPoint.y > 0) && self.bounds.height + (vConstant - cropBottomConstraint.constant) > 100 {
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
        
        if (hConstant > 0 || currentPoint.x - touchPoint.x < 0) && self.bounds.width - (hConstant - cropLeadingConstraint.constant) > 100 {
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
        
        if (vConstant > 0 || currentPoint.y - touchPoint.y < 0) && self.bounds.height - (vConstant - cropTopConstraint.constant) > 100 {
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
    
    // Max Image
    private func imageMaxAdjustment(_ duration: TimeInterval = 0.4, animated: Bool) {
        self.imageAdjustment(.zero, duration: duration, animated: animated)
    }
    
    // Min Image
    private func imageMinAdjustment(_ duration: TimeInterval = 0.4, animated: Bool) {
        var point: CGPoint
        let imageSize = self.imageView.frameForImageInImageViewAspectFit
        if self.isImageRateHeightGreaterThan(imageSize) {
            point = CGPoint(x: 0, y: imageSize.origin.y)
        } else {
            point = CGPoint(x: imageSize.origin.x, y: 0)
        }
        self.imageAdjustment(point, duration: duration, animated: animated)
    }
    
    private func imageAdjustment(_ point: CGPoint, duration: TimeInterval = 0.4, animated: Bool) {
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
        
        let path = UIBezierPath(rect: CGRect(
            x: -cropLeadingConstraint.constant,
            y: -cropTopConstraint.constant,
            width: width,
            height: height
        ))
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

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

extension UIView {
    
    var imageWithView: UIImage? {
        if #available(iOS 10.0, *) {
            let renderer = UIGraphicsImageRenderer(bounds: self.bounds)
            return renderer.image { rendererContext in
                self.layer.render(in: rendererContext.cgContext)
            }
        } else {
            UIGraphicsBeginImageContextWithOptions(self.bounds.size, self.isOpaque, 0.0)
            if let cgContext = UIGraphicsGetCurrentContext() {
                self.layer.render(in: cgContext)
            }
            self.drawHierarchy(in: self.bounds, afterScreenUpdates: true)
            let image = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            return image
        }
    }
    
    func edgesConstraint(subView: UIView, constant: CGFloat = 0) {
        self.leadingConstraint(subView: subView, constant: constant)
        self.trailingConstraint(subView: subView, constant: constant)
        self.topConstraint(subView: subView, constant: constant)
        self.bottomConstraint(subView: subView, constant: constant)
    }
    
    func sizeConstraint(subView: UIView, constant: CGFloat = 0) {
        self.widthConstraint(subView: subView, constant: constant)
        self.heightConstraint(subView: subView, constant: constant)
    }
    
    func sizeConstraint(constant: CGFloat = 0) {
        self.widthConstraint(constant: constant)
        self.heightConstraint(constant: constant)
    }
    
    @discardableResult
    func leadingConstraint(subView: UIView, constant: CGFloat = 0, multiplier: CGFloat = 1, relatedBy: NSLayoutConstraint.Relation = .equal) -> NSLayoutConstraint {
        let constraint = NSLayoutConstraint(item: self, attribute: .leading, relatedBy: relatedBy, toItem: subView, attribute: .leading, multiplier: multiplier, constant: constant)
        self.addConstraint(constraint)
        return constraint
    }
    
    @discardableResult
    func trailingConstraint(subView: UIView, constant: CGFloat = 0, multiplier: CGFloat = 1, relatedBy: NSLayoutConstraint.Relation = .equal) -> NSLayoutConstraint {
        let constraint = NSLayoutConstraint(item: self, attribute: .trailing, relatedBy: relatedBy, toItem: subView, attribute: .trailing, multiplier: multiplier, constant: constant)
        self.addConstraint(constraint)
        return constraint
    }
    
    @discardableResult
    func topConstraint(subView: UIView, constant: CGFloat = 0, multiplier: CGFloat = 1, relatedBy: NSLayoutConstraint.Relation = .equal) -> NSLayoutConstraint {
        let constraint = NSLayoutConstraint(item: self, attribute: .top, relatedBy: relatedBy, toItem: subView, attribute: .top, multiplier: multiplier, constant: constant)
        self.addConstraint(constraint)
        return constraint
    }
    
    @discardableResult
    func bottomConstraint(subView: UIView, constant: CGFloat = 0, multiplier: CGFloat = 1, relatedBy: NSLayoutConstraint.Relation = .equal) -> NSLayoutConstraint {
        let constraint = NSLayoutConstraint(item: self, attribute: .bottom, relatedBy: relatedBy, toItem: subView, attribute: .bottom, multiplier: multiplier, constant: constant)
        self.addConstraint(constraint)
        return constraint
    }
    
    @discardableResult
    func centerXConstraint(subView: UIView, constant: CGFloat = 0, multiplier: CGFloat = 1, relatedBy: NSLayoutConstraint.Relation = .equal) -> NSLayoutConstraint {
        let constraint = NSLayoutConstraint(item: self, attribute: .centerX, relatedBy: relatedBy, toItem: subView, attribute: .centerX, multiplier: multiplier, constant: constant)
        self.addConstraint(constraint)
        return constraint
    }
    
    @discardableResult
    func centerYConstraint(subView: UIView, constant: CGFloat = 0, multiplier: CGFloat = 1, relatedBy: NSLayoutConstraint.Relation = .equal) -> NSLayoutConstraint {
        let constraint = NSLayoutConstraint(item: self, attribute: .centerY, relatedBy: relatedBy, toItem: subView, attribute: .centerY, multiplier: multiplier, constant: constant)
        self.addConstraint(constraint)
        return constraint
    }
    
    @discardableResult
    func leadingConstraint(item: UIView, subView: UIView, constant: CGFloat = 0, multiplier: CGFloat = 1, relatedBy: NSLayoutConstraint.Relation = .equal) -> NSLayoutConstraint {
        let constraint = NSLayoutConstraint(item: item, attribute: .leading, relatedBy: relatedBy, toItem: subView, attribute: .leading, multiplier: multiplier, constant: constant)
        self.addConstraint(constraint)
        return constraint
    }
    
    @discardableResult
    func trailingConstraint(item: UIView, subView: UIView, constant: CGFloat = 0, multiplier: CGFloat = 1, relatedBy: NSLayoutConstraint.Relation = .equal) -> NSLayoutConstraint {
        let constraint = NSLayoutConstraint(item: item, attribute: .trailing, relatedBy: relatedBy, toItem: subView, attribute: .trailing, multiplier: multiplier, constant: constant)
        self.addConstraint(constraint)
        return constraint
    }
    
    @discardableResult
    func topConstraint(item: UIView, subView: UIView, constant: CGFloat = 0, multiplier: CGFloat = 1, relatedBy: NSLayoutConstraint.Relation = .equal) -> NSLayoutConstraint {
        let constraint = NSLayoutConstraint(item: item, attribute: .top, relatedBy: relatedBy, toItem: subView, attribute: .top, multiplier: multiplier, constant: constant)
        self.addConstraint(constraint)
        return constraint
    }
    
    @discardableResult
    func bottomConstraint(item: UIView, subView: UIView, constant: CGFloat = 0, multiplier: CGFloat = 1, relatedBy: NSLayoutConstraint.Relation = .equal) -> NSLayoutConstraint {
        let constraint = NSLayoutConstraint(item: item, attribute: .bottom, relatedBy: relatedBy, toItem: subView, attribute: .bottom, multiplier: multiplier, constant: constant)
        self.addConstraint(constraint)
        return constraint
    }
    
    @discardableResult
    func centerXConstraint(item: UIView, subView: UIView, constant: CGFloat = 0, multiplier: CGFloat = 1, relatedBy: NSLayoutConstraint.Relation = .equal) -> NSLayoutConstraint {
        let constraint = NSLayoutConstraint(item: item, attribute: .centerX, relatedBy: relatedBy, toItem: subView, attribute: .centerX, multiplier: multiplier, constant: constant)
        self.addConstraint(constraint)
        return constraint
    }
    
    @discardableResult
    func centerYConstraint(item: UIView, subView: UIView, constant: CGFloat = 0, multiplier: CGFloat = 1, relatedBy: NSLayoutConstraint.Relation = .equal) -> NSLayoutConstraint {
        let constraint = NSLayoutConstraint(item: item, attribute: .centerY, relatedBy: relatedBy, toItem: subView, attribute: .centerY, multiplier: multiplier, constant: constant)
        self.addConstraint(constraint)
        return constraint
    }
    
    @discardableResult
    func widthConstraint(item: UIView, subView: UIView, constant: CGFloat = 0, multiplier: CGFloat = 1, relatedBy: NSLayoutConstraint.Relation = .equal) -> NSLayoutConstraint {
        let constraint = NSLayoutConstraint(item: item, attribute: .width, relatedBy: relatedBy, toItem: subView, attribute: .width, multiplier: multiplier, constant: constant)
        self.addConstraint(constraint)
        return constraint
    }
    
    @discardableResult
    func heightConstraint(item: UIView, subView: UIView, constant: CGFloat = 0, multiplier: CGFloat = 1, relatedBy: NSLayoutConstraint.Relation = .equal) -> NSLayoutConstraint {
        let constraint = NSLayoutConstraint(item: item, attribute: .height, relatedBy: relatedBy, toItem: subView, attribute: .height, multiplier: multiplier, constant: constant)
        self.addConstraint(constraint)
        return constraint
    }
    
    @discardableResult
    func widthConstraint(subView: UIView, constant: CGFloat = 0, multiplier: CGFloat = 1, relatedBy: NSLayoutConstraint.Relation = .equal) -> NSLayoutConstraint {
        let constraint = NSLayoutConstraint(item: self, attribute: .width, relatedBy: relatedBy, toItem: subView, attribute: .width, multiplier: multiplier, constant: constant)
        self.addConstraint(constraint)
        return constraint
    }
    
    @discardableResult
    func heightConstraint(subView: UIView, constant: CGFloat = 0, multiplier: CGFloat = 1, relatedBy: NSLayoutConstraint.Relation = .equal) -> NSLayoutConstraint {
        let constraint = NSLayoutConstraint(item: self, attribute: .height, relatedBy: relatedBy, toItem: subView, attribute: .height, multiplier: multiplier, constant: constant)
        self.addConstraint(constraint)
        return constraint
    }
    
    @discardableResult
    func widthConstraint(constant: CGFloat = 0, multiplier: CGFloat = 1, relatedBy: NSLayoutConstraint.Relation = .equal) -> NSLayoutConstraint {
        let constraint = NSLayoutConstraint(item: self, attribute: .width, relatedBy: relatedBy, toItem: nil, attribute: .width, multiplier: multiplier, constant: constant)
        self.addConstraint(constraint)
        return constraint
    }
    
    @discardableResult
    func heightConstraint(constant: CGFloat = 0, multiplier: CGFloat = 1, relatedBy: NSLayoutConstraint.Relation = .equal) -> NSLayoutConstraint {
        let constraint = NSLayoutConstraint(item: self, attribute: .height, relatedBy: relatedBy, toItem: nil, attribute: .height, multiplier: multiplier, constant: constant)
        self.addConstraint(constraint)
        return constraint
    }
}

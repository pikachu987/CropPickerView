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

// Called when the button's highlighted is false.
protocol LineButtonDelegate: AnyObject {
    func lineButtonUnHighlighted()
}

// Side, Edge LineButton
public class LineButton: UIButton {
    weak var delegate: LineButtonDelegate?
    
    private var type: ButtonLineType
    
    public override var isHighlighted: Bool {
        didSet {
            if !isHighlighted {
                delegate?.lineButtonUnHighlighted()
            }
        }
    }
    
    // MARK: Init
    init(_ type: ButtonLineType) {
        self.type = type
        super.init(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
        
        setTitle(nil, for: .normal)
        translatesAutoresizingMaskIntoConstraints = false
        if type != .center {
            widthConstraint(constant: 50)
            heightConstraint(constant: 50)
            alpha = 0
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func edgeLine(_ color: UIColor?) {
        setImage(type.view(color)?.imageWithView?.withRenderingMode(.alwaysOriginal), for: .normal)
    }
}

enum ButtonLineType {
    case center
    case leftTop, rightTop, leftBottom, rightBottom, top, left, right, bottom
    
    var rotate: CGFloat {
        switch self {
        case .leftTop:
            return 0
        case .rightTop:
            return CGFloat.pi/2
        case .rightBottom:
            return CGFloat.pi
        case .leftBottom:
            return CGFloat.pi/2*3
        case .top:
            return 0
        case .left:
            return CGFloat.pi/2*3
        case .right:
            return CGFloat.pi/2
        case .bottom:
            return CGFloat.pi
        case .center:
            return 0
        }
    }
    
    var yMargin: CGFloat {
        switch self {
        case .rightBottom, .bottom:
            return 1
        default:
            return 0
        }
    }
    
    var xMargin: CGFloat {
        switch self {
        case .leftBottom:
            return 1
        default:
            return 0
        }
    }
    
    func view(_ color: UIColor?) -> UIView? {
        var view: UIView?
        if self == .leftTop || self == .rightTop || self == .leftBottom || self == .rightBottom {
            view = ButtonLineType.EdgeView(self, color: color)
        } else {
            view = ButtonLineType.SideView(self, color: color)
        }
        view?.isOpaque = false
        view?.tintColor = color
        return view
    }
    
    class LineView: UIView {
        var type: ButtonLineType
        var color: UIColor?
        init(_ type: ButtonLineType, color: UIColor?) {
            self.type = type
            self.color = color
            super.init(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
        }
        required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        func apply(_ path: UIBezierPath) {
            var pathTransform  = CGAffineTransform.identity
            pathTransform = pathTransform.translatedBy(x: 25, y: 25)
            pathTransform = pathTransform.rotated(by: type.rotate)
            pathTransform = pathTransform.translatedBy(x: -25 - type.xMargin, y: -25 - type.yMargin)
            path.apply(pathTransform)
            path.closed()
                .strokeFill(color ?? .white)
        }
    }
    
    class EdgeView: LineView {
        override func draw(_ rect: CGRect) {
            let path = UIBezierPath()
                .move(6, 6)
                .line(6, 20)
                .line(8, 20)
                .line(8, 8)
                .line(20, 8)
                .line(20, 6)
                .line(6, 6)
            apply(path)
        }
    }
    class SideView: LineView {
        override func draw(_ rect: CGRect) {
            let path = UIBezierPath()
                .move(15, 6)
                .line(35, 6)
                .line(35, 8)
                .line(15, 8)
                .line(15, 6)
            apply(path)
        }
    }
}

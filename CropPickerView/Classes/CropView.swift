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

// Crop LineView
public class CropView: UIView {
    private let margin: CGFloat = 0
    private let lineSize: CGFloat = 1
    
    var lineColor: UIColor? = .white {
        willSet {
            topLineView.backgroundColor = newValue
            bottomLineView.backgroundColor = newValue
            leftLineView.backgroundColor = newValue
            rightLineView.backgroundColor = newValue
            horizontalRightLineView.backgroundColor = newValue
            horizontalLeftLineView.backgroundColor = newValue
            verticalTopLineView.backgroundColor = newValue
            verticalBottomLineView.backgroundColor = newValue
        }
    }
    
    public let topLineView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    public let leftLineView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    public let bottomLineView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    public let rightLineView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    public let horizontalLeftLineView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    public let horizontalRightLineView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    public let verticalTopLineView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    public let verticalBottomLineView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    public let horizontalLeftView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    public let horizontalCenterView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    public let horizontalRightView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    public let verticalTopView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    public let verticalCenterView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    public let verticalBottomView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    public override func awakeFromNib() {
        super.awakeFromNib()
        
        initVars()
    }
    
    init() {
        super.init(frame: .zero)
        
        initVars()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        initVars()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    private func initVars() {
        
        addSubview(topLineView)
        addSubview(leftLineView)
        addSubview(bottomLineView)
        addSubview(rightLineView)
        addSubview(horizontalLeftLineView)
        addSubview(horizontalRightLineView)
        addSubview(verticalTopLineView)
        addSubview(verticalBottomLineView)
        addSubview(horizontalLeftView)
        addSubview(horizontalCenterView)
        addSubview(horizontalRightView)
        addSubview(verticalTopView)
        addSubview(verticalCenterView)
        addSubview(verticalBottomView)

        addConstraint(NSLayoutConstraint(item: self, attribute: .leading, relatedBy: .equal, toItem: topLineView, attribute: .leading, multiplier: 1, constant: margin).priority(950))
        addConstraint(NSLayoutConstraint(item: self, attribute: .trailing, relatedBy: .equal, toItem: topLineView, attribute: .trailing, multiplier: 1, constant: margin).priority(950))
        addConstraint(NSLayoutConstraint(item: self, attribute: .top, relatedBy: .equal, toItem: topLineView, attribute: .top, multiplier: 1, constant: margin).priority(950))
        topLineView.addConstraint(NSLayoutConstraint(item: topLineView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .height, multiplier: 1, constant: lineSize).priority(950))
        
        addConstraint(NSLayoutConstraint(item: self, attribute: .leading, relatedBy: .equal, toItem: leftLineView, attribute: .leading, multiplier: 1, constant: margin).priority(950))
        addConstraint(NSLayoutConstraint(item: self, attribute: .bottom, relatedBy: .equal, toItem: leftLineView, attribute: .bottom, multiplier: 1, constant: margin).priority(950))
        addConstraint(NSLayoutConstraint(item: self, attribute: .top, relatedBy: .equal, toItem: leftLineView, attribute: .top, multiplier: 1, constant: margin).priority(950))
        leftLineView.addConstraint(NSLayoutConstraint(item: leftLineView, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .width, multiplier: 1, constant: lineSize).priority(950))
        
        addConstraint(NSLayoutConstraint(item: self, attribute: .leading, relatedBy: .equal, toItem: bottomLineView, attribute: .leading, multiplier: 1, constant: margin).priority(950))
        addConstraint(NSLayoutConstraint(item: self, attribute: .trailing, relatedBy: .equal, toItem: bottomLineView, attribute: .trailing, multiplier: 1, constant: margin).priority(950))
        addConstraint(NSLayoutConstraint(item: self, attribute: .bottom, relatedBy: .equal, toItem: bottomLineView, attribute: .top, multiplier: 1, constant: margin).priority(950))
        bottomLineView.addConstraint(NSLayoutConstraint(item: bottomLineView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .height, multiplier: 1, constant: lineSize).priority(950))
        
        addConstraint(NSLayoutConstraint(item: self, attribute: .trailing, relatedBy: .equal, toItem: rightLineView, attribute: .trailing, multiplier: 1, constant: margin).priority(950))
        addConstraint(NSLayoutConstraint(item: self, attribute: .bottom, relatedBy: .equal, toItem: rightLineView, attribute: .bottom, multiplier: 1, constant: margin).priority(950))
        addConstraint(NSLayoutConstraint(item: self, attribute: .top, relatedBy: .equal, toItem: rightLineView, attribute: .top, multiplier: 1, constant: margin).priority(950))
        rightLineView.addConstraint(NSLayoutConstraint(item: rightLineView, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .width, multiplier: 1, constant: lineSize).priority(950))
        
        addConstraint(NSLayoutConstraint(item: horizontalLeftView, attribute: .trailing, relatedBy: .equal, toItem: horizontalLeftLineView, attribute: .leading, multiplier: 1, constant: 0).priority(950))
        addConstraint(NSLayoutConstraint(item: bottomLineView, attribute: .top, relatedBy: .equal, toItem: horizontalLeftLineView, attribute: .bottom, multiplier: 1, constant: 0).priority(950))
        addConstraint(NSLayoutConstraint(item: topLineView, attribute: .bottom, relatedBy: .equal, toItem: horizontalLeftLineView, attribute: .top, multiplier: 1, constant: 0).priority(950))
        horizontalLeftLineView.addConstraint(NSLayoutConstraint(item: horizontalLeftLineView, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .width, multiplier: 1, constant: lineSize).priority(950))
        
        addConstraint(NSLayoutConstraint(item: horizontalCenterView, attribute: .trailing, relatedBy: .equal, toItem: horizontalRightLineView, attribute: .leading, multiplier: 1, constant: 0).priority(950))
        addConstraint(NSLayoutConstraint(item: bottomLineView, attribute: .top, relatedBy: .equal, toItem: horizontalRightLineView, attribute: .bottom, multiplier: 1, constant: 0).priority(950))
        addConstraint(NSLayoutConstraint(item: topLineView, attribute: .bottom, relatedBy: .equal, toItem: horizontalRightLineView, attribute: .top, multiplier: 1, constant: 0).priority(950))
        horizontalRightLineView.addConstraint(NSLayoutConstraint(item: horizontalRightLineView, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .width, multiplier: 1, constant: lineSize).priority(950))
        
        addConstraint(NSLayoutConstraint(item: verticalTopView, attribute: .bottom, relatedBy: .equal, toItem: verticalTopLineView, attribute: .top, multiplier: 1, constant: 0).priority(950))
        addConstraint(NSLayoutConstraint(item: leftLineView, attribute: .trailing, relatedBy: .equal, toItem: verticalTopLineView, attribute: .leading, multiplier: 1, constant: 0).priority(950))
        addConstraint(NSLayoutConstraint(item: rightLineView, attribute: .leading, relatedBy: .equal, toItem: verticalTopLineView, attribute: .trailing, multiplier: 1, constant: 0).priority(950))
        verticalTopLineView.addConstraint(NSLayoutConstraint(item: verticalTopLineView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .height, multiplier: 1, constant: lineSize).priority(950))
        
        addConstraint(NSLayoutConstraint(item: verticalCenterView, attribute: .bottom, relatedBy: .equal, toItem: verticalBottomLineView, attribute: .top, multiplier: 1, constant: 0).priority(950))
        addConstraint(NSLayoutConstraint(item: leftLineView, attribute: .trailing, relatedBy: .equal, toItem: verticalBottomLineView, attribute: .leading, multiplier: 1, constant: 0).priority(950))
        addConstraint(NSLayoutConstraint(item: rightLineView, attribute: .leading, relatedBy: .equal, toItem: verticalBottomLineView, attribute: .trailing, multiplier: 1, constant: 0).priority(950))
        verticalBottomLineView.addConstraint(NSLayoutConstraint(item: verticalBottomLineView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .height, multiplier: 1, constant: lineSize).priority(950))
        
        addConstraint(NSLayoutConstraint(item: leftLineView, attribute: .trailing, relatedBy: .equal, toItem: horizontalLeftView, attribute: .leading, multiplier: 1, constant: 0).priority(950))
        addConstraint(NSLayoutConstraint(item: bottomLineView, attribute: .top, relatedBy: .equal, toItem: horizontalLeftView, attribute: .bottom, multiplier: 1, constant: 0).priority(950))
        addConstraint(NSLayoutConstraint(item: topLineView, attribute: .bottom, relatedBy: .equal, toItem: horizontalLeftView, attribute: .top, multiplier: 1, constant: 0).priority(950))
        
        addConstraint(NSLayoutConstraint(item: horizontalLeftLineView, attribute: .trailing, relatedBy: .equal, toItem: horizontalCenterView, attribute: .leading, multiplier: 1, constant: 0).priority(950))
        addConstraint(NSLayoutConstraint(item: bottomLineView, attribute: .top, relatedBy: .equal, toItem: horizontalCenterView, attribute: .bottom, multiplier: 1, constant: 0).priority(950))
        addConstraint(NSLayoutConstraint(item: topLineView, attribute: .bottom, relatedBy: .equal, toItem: horizontalCenterView, attribute: .top, multiplier: 1, constant: 0).priority(950))
        addConstraint(NSLayoutConstraint(item: horizontalLeftView, attribute: .width, relatedBy: .equal, toItem: horizontalCenterView, attribute: .width, multiplier: 1, constant: 0).priority(950))
        
        addConstraint(NSLayoutConstraint(item: horizontalRightLineView, attribute: .trailing, relatedBy: .equal, toItem: horizontalRightView, attribute: .leading, multiplier: 1, constant: 0).priority(950))
        addConstraint(NSLayoutConstraint(item: bottomLineView, attribute: .top, relatedBy: .equal, toItem: horizontalRightView, attribute: .bottom, multiplier: 1, constant: 0).priority(950))
        addConstraint(NSLayoutConstraint(item: topLineView, attribute: .bottom, relatedBy: .equal, toItem: horizontalRightView, attribute: .top, multiplier: 1, constant: 0).priority(950))
        addConstraint(NSLayoutConstraint(item: rightLineView, attribute: .leading, relatedBy: .equal, toItem: horizontalRightView, attribute: .trailing, multiplier: 1, constant: 0).priority(950))
        addConstraint(NSLayoutConstraint(item: horizontalLeftView, attribute: .width, relatedBy: .equal, toItem: horizontalRightView, attribute: .width, multiplier: 1, constant: 0).priority(950))
        
        addConstraint(NSLayoutConstraint(item: topLineView, attribute: .bottom, relatedBy: .equal, toItem: verticalTopView, attribute: .top, multiplier: 1, constant: 0).priority(950))
        addConstraint(NSLayoutConstraint(item: leftLineView, attribute: .trailing, relatedBy: .equal, toItem: verticalTopView, attribute: .leading, multiplier: 1, constant: 0).priority(950))
        addConstraint(NSLayoutConstraint(item: rightLineView, attribute: .leading, relatedBy: .equal, toItem: verticalTopView, attribute: .trailing, multiplier: 1, constant: 0).priority(950))
        
        addConstraint(NSLayoutConstraint(item: verticalTopLineView, attribute: .bottom, relatedBy: .equal, toItem: verticalCenterView, attribute: .top, multiplier: 1, constant: 0).priority(950))
        addConstraint(NSLayoutConstraint(item: leftLineView, attribute: .trailing, relatedBy: .equal, toItem: verticalCenterView, attribute: .leading, multiplier: 1, constant: 0).priority(950))
        addConstraint(NSLayoutConstraint(item: rightLineView, attribute: .leading, relatedBy: .equal, toItem: verticalCenterView, attribute: .trailing, multiplier: 1, constant: 0).priority(950))
        addConstraint(NSLayoutConstraint(item: verticalTopView, attribute: .height, relatedBy: .equal, toItem: verticalCenterView, attribute: .height, multiplier: 1, constant: 0).priority(950))
        
        addConstraint(NSLayoutConstraint(item: verticalBottomLineView, attribute: .bottom, relatedBy: .equal, toItem: verticalBottomView, attribute: .top, multiplier: 1, constant: 0).priority(950))
        addConstraint(NSLayoutConstraint(item: leftLineView, attribute: .trailing, relatedBy: .equal, toItem: verticalBottomView, attribute: .leading, multiplier: 1, constant: 0).priority(950))
        addConstraint(NSLayoutConstraint(item: rightLineView, attribute: .leading, relatedBy: .equal, toItem: verticalBottomView, attribute: .trailing, multiplier: 1, constant: 0).priority(950))
        addConstraint(NSLayoutConstraint(item: verticalTopView, attribute: .height, relatedBy: .equal, toItem: verticalBottomView, attribute: .height, multiplier: 1, constant: 0).priority(950))
        addConstraint(NSLayoutConstraint(item: bottomLineView, attribute: .top, relatedBy: .equal, toItem: verticalBottomView, attribute: .bottom, multiplier: 1, constant: 0).priority(950))
        
        isUserInteractionEnabled = false
        backgroundColor = .clear
        topLineView.alpha = 1
        leftLineView.alpha = 1
        bottomLineView.alpha = 1
        rightLineView.alpha = 1
        horizontalLeftLineView.alpha = 0
        horizontalRightLineView.alpha = 0
        verticalTopLineView.alpha = 0
        verticalBottomLineView.alpha = 0
        
        horizontalLeftView.alpha = 0
        horizontalCenterView.alpha = 0
        horizontalRightView.alpha = 0
        verticalTopView.alpha = 0
        verticalCenterView.alpha = 0
        verticalBottomView.alpha = 0
    }
    
    func line(_ isHidden: Bool, animated: Bool) {
        if animated {
            UIView.animate(withDuration: 0.3) {
                if isHidden {
                    self.horizontalRightLineView.alpha = 0
                    self.horizontalLeftLineView.alpha = 0
                    self.verticalTopLineView.alpha = 0
                    self.verticalBottomLineView.alpha = 0
                } else {
                    self.horizontalRightLineView.alpha = 1
                    self.horizontalLeftLineView.alpha = 1
                    self.verticalTopLineView.alpha = 1
                    self.verticalBottomLineView.alpha = 1
                }
            }
        } else {
            if isHidden {
                horizontalRightLineView.alpha = 0
                horizontalLeftLineView.alpha = 0
                verticalTopLineView.alpha = 0
                verticalBottomLineView.alpha = 0
            } else {
                horizontalRightLineView.alpha = 1
                horizontalLeftLineView.alpha = 1
                verticalTopLineView.alpha = 1
                verticalBottomLineView.alpha = 1
            }
        }
    }
}

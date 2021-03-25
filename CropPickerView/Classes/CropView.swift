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
            self.topLineView.backgroundColor = newValue
            self.bottomLineView.backgroundColor = newValue
            self.leftLineView.backgroundColor = newValue
            self.rightLineView.backgroundColor = newValue
            self.horizontalRightLineView.backgroundColor = newValue
            self.horizontalLeftLineView.backgroundColor = newValue
            self.verticalTopLineView.backgroundColor = newValue
            self.verticalBottomLineView.backgroundColor = newValue
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
        
        self.initVars()
    }
    
    init() {
        super.init(frame: .zero)
        
        self.initVars()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.initVars()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    private func initVars() {
        
        self.addSubview(self.topLineView)
        self.addSubview(self.leftLineView)
        self.addSubview(self.bottomLineView)
        self.addSubview(self.rightLineView)
        self.addSubview(self.horizontalLeftLineView)
        self.addSubview(self.horizontalRightLineView)
        self.addSubview(self.verticalTopLineView)
        self.addSubview(self.verticalBottomLineView)
        self.addSubview(self.horizontalLeftView)
        self.addSubview(self.horizontalCenterView)
        self.addSubview(self.horizontalRightView)
        self.addSubview(self.verticalTopView)
        self.addSubview(self.verticalCenterView)
        self.addSubview(self.verticalBottomView)

        self.addConstraint(NSLayoutConstraint(item: self, attribute: .leading, relatedBy: .equal, toItem: self.topLineView, attribute: .leading, multiplier: 1, constant: self.margin).priority(950))
        self.addConstraint(NSLayoutConstraint(item: self, attribute: .trailing, relatedBy: .equal, toItem: self.topLineView, attribute: .trailing, multiplier: 1, constant: self.margin).priority(950))
        self.addConstraint(NSLayoutConstraint(item: self, attribute: .top, relatedBy: .equal, toItem: self.topLineView, attribute: .top, multiplier: 1, constant: self.margin).priority(950))
        self.topLineView.addConstraint(NSLayoutConstraint(item: self.topLineView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .height, multiplier: 1, constant: self.lineSize).priority(950))
        
        self.addConstraint(NSLayoutConstraint(item: self, attribute: .leading, relatedBy: .equal, toItem: self.leftLineView, attribute: .leading, multiplier: 1, constant: self.margin).priority(950))
        self.addConstraint(NSLayoutConstraint(item: self, attribute: .bottom, relatedBy: .equal, toItem: self.leftLineView, attribute: .bottom, multiplier: 1, constant: self.margin).priority(950))
        self.addConstraint(NSLayoutConstraint(item: self, attribute: .top, relatedBy: .equal, toItem: self.leftLineView, attribute: .top, multiplier: 1, constant: self.margin).priority(950))
        self.leftLineView.addConstraint(NSLayoutConstraint(item: self.leftLineView, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .width, multiplier: 1, constant: self.lineSize).priority(950))
        
        self.addConstraint(NSLayoutConstraint(item: self, attribute: .leading, relatedBy: .equal, toItem: self.bottomLineView, attribute: .leading, multiplier: 1, constant: self.margin).priority(950))
        self.addConstraint(NSLayoutConstraint(item: self, attribute: .trailing, relatedBy: .equal, toItem: self.bottomLineView, attribute: .trailing, multiplier: 1, constant: self.margin).priority(950))
        self.addConstraint(NSLayoutConstraint(item: self, attribute: .bottom, relatedBy: .equal, toItem: self.bottomLineView, attribute: .top, multiplier: 1, constant: self.margin).priority(950))
        self.bottomLineView.addConstraint(NSLayoutConstraint(item: self.bottomLineView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .height, multiplier: 1, constant: self.lineSize).priority(950))
        
        self.addConstraint(NSLayoutConstraint(item: self, attribute: .trailing, relatedBy: .equal, toItem: self.rightLineView, attribute: .trailing, multiplier: 1, constant: self.margin).priority(950))
        self.addConstraint(NSLayoutConstraint(item: self, attribute: .bottom, relatedBy: .equal, toItem: self.rightLineView, attribute: .bottom, multiplier: 1, constant: self.margin).priority(950))
        self.addConstraint(NSLayoutConstraint(item: self, attribute: .top, relatedBy: .equal, toItem: self.rightLineView, attribute: .top, multiplier: 1, constant: self.margin).priority(950))
        self.rightLineView.addConstraint(NSLayoutConstraint(item: self.rightLineView, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .width, multiplier: 1, constant: self.lineSize).priority(950))
        
        self.addConstraint(NSLayoutConstraint(item: self.horizontalLeftView, attribute: .trailing, relatedBy: .equal, toItem: self.horizontalLeftLineView, attribute: .leading, multiplier: 1, constant: 0).priority(950))
        self.addConstraint(NSLayoutConstraint(item: self.bottomLineView, attribute: .top, relatedBy: .equal, toItem: self.horizontalLeftLineView, attribute: .bottom, multiplier: 1, constant: 0).priority(950))
        self.addConstraint(NSLayoutConstraint(item: self.topLineView, attribute: .bottom, relatedBy: .equal, toItem: self.horizontalLeftLineView, attribute: .top, multiplier: 1, constant: 0).priority(950))
        self.horizontalLeftLineView.addConstraint(NSLayoutConstraint(item: self.horizontalLeftLineView, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .width, multiplier: 1, constant: self.lineSize).priority(950))
        
        self.addConstraint(NSLayoutConstraint(item: self.horizontalCenterView, attribute: .trailing, relatedBy: .equal, toItem: self.horizontalRightLineView, attribute: .leading, multiplier: 1, constant: 0).priority(950))
        self.addConstraint(NSLayoutConstraint(item: self.bottomLineView, attribute: .top, relatedBy: .equal, toItem: self.horizontalRightLineView, attribute: .bottom, multiplier: 1, constant: 0).priority(950))
        self.addConstraint(NSLayoutConstraint(item: self.topLineView, attribute: .bottom, relatedBy: .equal, toItem: self.horizontalRightLineView, attribute: .top, multiplier: 1, constant: 0).priority(950))
        self.horizontalRightLineView.addConstraint(NSLayoutConstraint(item: self.horizontalRightLineView, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .width, multiplier: 1, constant: self.lineSize).priority(950))
        
        self.addConstraint(NSLayoutConstraint(item: self.verticalTopView, attribute: .bottom, relatedBy: .equal, toItem: self.verticalTopLineView, attribute: .top, multiplier: 1, constant: 0).priority(950))
        self.addConstraint(NSLayoutConstraint(item: self.leftLineView, attribute: .trailing, relatedBy: .equal, toItem: self.verticalTopLineView, attribute: .leading, multiplier: 1, constant: 0).priority(950))
        self.addConstraint(NSLayoutConstraint(item: self.rightLineView, attribute: .leading, relatedBy: .equal, toItem: self.verticalTopLineView, attribute: .trailing, multiplier: 1, constant: 0).priority(950))
        self.verticalTopLineView.addConstraint(NSLayoutConstraint(item: self.verticalTopLineView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .height, multiplier: 1, constant: self.lineSize).priority(950))
        
        self.addConstraint(NSLayoutConstraint(item: self.verticalCenterView, attribute: .bottom, relatedBy: .equal, toItem: self.verticalBottomLineView, attribute: .top, multiplier: 1, constant: 0).priority(950))
        self.addConstraint(NSLayoutConstraint(item: self.leftLineView, attribute: .trailing, relatedBy: .equal, toItem: self.verticalBottomLineView, attribute: .leading, multiplier: 1, constant: 0).priority(950))
        self.addConstraint(NSLayoutConstraint(item: self.rightLineView, attribute: .leading, relatedBy: .equal, toItem: self.verticalBottomLineView, attribute: .trailing, multiplier: 1, constant: 0).priority(950))
        self.verticalBottomLineView.addConstraint(NSLayoutConstraint(item: self.verticalBottomLineView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .height, multiplier: 1, constant: self.lineSize).priority(950))
        
        self.addConstraint(NSLayoutConstraint(item: self.leftLineView, attribute: .trailing, relatedBy: .equal, toItem: self.horizontalLeftView, attribute: .leading, multiplier: 1, constant: 0).priority(950))
        self.addConstraint(NSLayoutConstraint(item: self.bottomLineView, attribute: .top, relatedBy: .equal, toItem: self.horizontalLeftView, attribute: .bottom, multiplier: 1, constant: 0).priority(950))
        self.addConstraint(NSLayoutConstraint(item: self.topLineView, attribute: .bottom, relatedBy: .equal, toItem: self.horizontalLeftView, attribute: .top, multiplier: 1, constant: 0).priority(950))
        
        self.addConstraint(NSLayoutConstraint(item: self.horizontalLeftLineView, attribute: .trailing, relatedBy: .equal, toItem: self.horizontalCenterView, attribute: .leading, multiplier: 1, constant: 0).priority(950))
        self.addConstraint(NSLayoutConstraint(item: self.bottomLineView, attribute: .top, relatedBy: .equal, toItem: self.horizontalCenterView, attribute: .bottom, multiplier: 1, constant: 0).priority(950))
        self.addConstraint(NSLayoutConstraint(item: self.topLineView, attribute: .bottom, relatedBy: .equal, toItem: self.horizontalCenterView, attribute: .top, multiplier: 1, constant: 0).priority(950))
        self.addConstraint(NSLayoutConstraint(item: self.horizontalLeftView, attribute: .width, relatedBy: .equal, toItem: self.horizontalCenterView, attribute: .width, multiplier: 1, constant: 0).priority(950))
        
        self.addConstraint(NSLayoutConstraint(item: self.horizontalRightLineView, attribute: .trailing, relatedBy: .equal, toItem: self.horizontalRightView, attribute: .leading, multiplier: 1, constant: 0).priority(950))
        self.addConstraint(NSLayoutConstraint(item: self.bottomLineView, attribute: .top, relatedBy: .equal, toItem: self.horizontalRightView, attribute: .bottom, multiplier: 1, constant: 0).priority(950))
        self.addConstraint(NSLayoutConstraint(item: self.topLineView, attribute: .bottom, relatedBy: .equal, toItem: self.horizontalRightView, attribute: .top, multiplier: 1, constant: 0).priority(950))
        self.addConstraint(NSLayoutConstraint(item: self.rightLineView, attribute: .leading, relatedBy: .equal, toItem: self.horizontalRightView, attribute: .trailing, multiplier: 1, constant: 0).priority(950))
        self.addConstraint(NSLayoutConstraint(item: self.horizontalLeftView, attribute: .width, relatedBy: .equal, toItem: self.horizontalRightView, attribute: .width, multiplier: 1, constant: 0).priority(950))
        
        self.addConstraint(NSLayoutConstraint(item: self.topLineView, attribute: .bottom, relatedBy: .equal, toItem: self.verticalTopView, attribute: .top, multiplier: 1, constant: 0).priority(950))
        self.addConstraint(NSLayoutConstraint(item: self.leftLineView, attribute: .trailing, relatedBy: .equal, toItem: self.verticalTopView, attribute: .leading, multiplier: 1, constant: 0).priority(950))
        self.addConstraint(NSLayoutConstraint(item: self.rightLineView, attribute: .leading, relatedBy: .equal, toItem: self.verticalTopView, attribute: .trailing, multiplier: 1, constant: 0).priority(950))
        
        self.addConstraint(NSLayoutConstraint(item: self.verticalTopLineView, attribute: .bottom, relatedBy: .equal, toItem: self.verticalCenterView, attribute: .top, multiplier: 1, constant: 0).priority(950))
        self.addConstraint(NSLayoutConstraint(item: self.leftLineView, attribute: .trailing, relatedBy: .equal, toItem: self.verticalCenterView, attribute: .leading, multiplier: 1, constant: 0).priority(950))
        self.addConstraint(NSLayoutConstraint(item: self.rightLineView, attribute: .leading, relatedBy: .equal, toItem: self.verticalCenterView, attribute: .trailing, multiplier: 1, constant: 0).priority(950))
        self.addConstraint(NSLayoutConstraint(item: self.verticalTopView, attribute: .height, relatedBy: .equal, toItem: self.verticalCenterView, attribute: .height, multiplier: 1, constant: 0).priority(950))
        
        self.addConstraint(NSLayoutConstraint(item: self.verticalBottomLineView, attribute: .bottom, relatedBy: .equal, toItem: self.verticalBottomView, attribute: .top, multiplier: 1, constant: 0).priority(950))
        self.addConstraint(NSLayoutConstraint(item: self.leftLineView, attribute: .trailing, relatedBy: .equal, toItem: self.verticalBottomView, attribute: .leading, multiplier: 1, constant: 0).priority(950))
        self.addConstraint(NSLayoutConstraint(item: self.rightLineView, attribute: .leading, relatedBy: .equal, toItem: self.verticalBottomView, attribute: .trailing, multiplier: 1, constant: 0).priority(950))
        self.addConstraint(NSLayoutConstraint(item: self.verticalTopView, attribute: .height, relatedBy: .equal, toItem: self.verticalBottomView, attribute: .height, multiplier: 1, constant: 0).priority(950))
        self.addConstraint(NSLayoutConstraint(item: self.bottomLineView, attribute: .top, relatedBy: .equal, toItem: self.verticalBottomView, attribute: .bottom, multiplier: 1, constant: 0).priority(950))
        
        self.isUserInteractionEnabled = false
        self.backgroundColor = .clear
        self.topLineView.alpha = 1
        self.leftLineView.alpha = 1
        self.bottomLineView.alpha = 1
        self.rightLineView.alpha = 1
        self.horizontalLeftLineView.alpha = 0
        self.horizontalRightLineView.alpha = 0
        self.verticalTopLineView.alpha = 0
        self.verticalBottomLineView.alpha = 0
        
        self.horizontalLeftView.alpha = 0
        self.horizontalCenterView.alpha = 0
        self.horizontalRightView.alpha = 0
        self.verticalTopView.alpha = 0
        self.verticalCenterView.alpha = 0
        self.verticalBottomView.alpha = 0
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
    }
}

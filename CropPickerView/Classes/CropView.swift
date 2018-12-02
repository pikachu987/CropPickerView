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
class CropView: UIView {
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
    
    private lazy var topLineView: UIView = {
        let view = UIView()
        self.addSubview(view)
        view.translatesAutoresizingMaskIntoConstraints = false
        self.addConstraint(NSLayoutConstraint(item: self, attribute: .leading, relatedBy: .equal, toItem: view, attribute: .leading, multiplier: 1, constant: self.margin).priority(950))
        self.addConstraint(NSLayoutConstraint(item: self, attribute: .trailing, relatedBy: .equal, toItem: view, attribute: .trailing, multiplier: 1, constant: self.margin).priority(950))
        self.addConstraint(NSLayoutConstraint(item: self, attribute: .top, relatedBy: .equal, toItem: view, attribute: .top, multiplier: 1, constant: self.margin).priority(950))
        view.addConstraint(NSLayoutConstraint(item: view, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .height, multiplier: 1, constant: self.lineSize).priority(950))
        return view
    }()
    
    private lazy var leftLineView: UIView = {
        let view = UIView()
        self.addSubview(view)
        view.translatesAutoresizingMaskIntoConstraints = false
        self.addConstraint(NSLayoutConstraint(item: self, attribute: .leading, relatedBy: .equal, toItem: view, attribute: .leading, multiplier: 1, constant: self.margin).priority(950))
        self.addConstraint(NSLayoutConstraint(item: self, attribute: .bottom, relatedBy: .equal, toItem: view, attribute: .bottom, multiplier: 1, constant: self.margin).priority(950))
        self.addConstraint(NSLayoutConstraint(item: self, attribute: .top, relatedBy: .equal, toItem: view, attribute: .top, multiplier: 1, constant: self.margin).priority(950))
        view.addConstraint(NSLayoutConstraint(item: view, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .width, multiplier: 1, constant: self.lineSize).priority(950))
        return view
    }()
    
    private lazy var bottomLineView: UIView = {
        let view = UIView()
        self.addSubview(view)
        view.translatesAutoresizingMaskIntoConstraints = false
        self.addConstraint(NSLayoutConstraint(item: self, attribute: .leading, relatedBy: .equal, toItem: view, attribute: .leading, multiplier: 1, constant: self.margin).priority(950))
        self.addConstraint(NSLayoutConstraint(item: self, attribute: .trailing, relatedBy: .equal, toItem: view, attribute: .trailing, multiplier: 1, constant: self.margin).priority(950))
        self.addConstraint(NSLayoutConstraint(item: self, attribute: .bottom, relatedBy: .equal, toItem: view, attribute: .top, multiplier: 1, constant: self.margin).priority(950))
        view.addConstraint(NSLayoutConstraint(item: view, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .height, multiplier: 1, constant: self.lineSize).priority(950))
        return view
    }()
    
    private lazy var rightLineView: UIView = {
        let view = UIView()
        self.addSubview(view)
        view.translatesAutoresizingMaskIntoConstraints = false
        self.addConstraint(NSLayoutConstraint(item: self, attribute: .trailing, relatedBy: .equal, toItem: view, attribute: .trailing, multiplier: 1, constant: self.margin).priority(950))
        self.addConstraint(NSLayoutConstraint(item: self, attribute: .bottom, relatedBy: .equal, toItem: view, attribute: .bottom, multiplier: 1, constant: self.margin).priority(950))
        self.addConstraint(NSLayoutConstraint(item: self, attribute: .top, relatedBy: .equal, toItem: view, attribute: .top, multiplier: 1, constant: self.margin).priority(950))
        view.addConstraint(NSLayoutConstraint(item: view, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .width, multiplier: 1, constant: self.lineSize).priority(950))
        return view
    }()
    
    private lazy var horizontalLeftLineView: UIView = {
        let view = UIView()
        self.addSubview(view)
        view.translatesAutoresizingMaskIntoConstraints = false
        self.addConstraint(NSLayoutConstraint(item: self.horizontalLeftView, attribute: .trailing, relatedBy: .equal, toItem: view, attribute: .leading, multiplier: 1, constant: 0).priority(950))
        self.addConstraint(NSLayoutConstraint(item: self.bottomLineView, attribute: .top, relatedBy: .equal, toItem: view, attribute: .bottom, multiplier: 1, constant: 0).priority(950))
        self.addConstraint(NSLayoutConstraint(item: self.topLineView, attribute: .bottom, relatedBy: .equal, toItem: view, attribute: .top, multiplier: 1, constant: 0).priority(950))
        view.addConstraint(NSLayoutConstraint(item: view, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .width, multiplier: 1, constant: self.lineSize).priority(950))
        return view
    }()
    
    private lazy var horizontalRightLineView: UIView = {
        let view = UIView()
        self.addSubview(view)
        view.translatesAutoresizingMaskIntoConstraints = false
        self.addConstraint(NSLayoutConstraint(item: self.horizontalCenterView, attribute: .trailing, relatedBy: .equal, toItem: view, attribute: .leading, multiplier: 1, constant: 0).priority(950))
        self.addConstraint(NSLayoutConstraint(item: self.bottomLineView, attribute: .top, relatedBy: .equal, toItem: view, attribute: .bottom, multiplier: 1, constant: 0).priority(950))
        self.addConstraint(NSLayoutConstraint(item: self.topLineView, attribute: .bottom, relatedBy: .equal, toItem: view, attribute: .top, multiplier: 1, constant: 0).priority(950))
        view.addConstraint(NSLayoutConstraint(item: view, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .width, multiplier: 1, constant: self.lineSize).priority(950))
        return view
    }()
    
    private lazy var verticalTopLineView: UIView = {
        let view = UIView()
        self.addSubview(view)
        view.translatesAutoresizingMaskIntoConstraints = false
        self.addConstraint(NSLayoutConstraint(item: self.verticalTopView, attribute: .bottom, relatedBy: .equal, toItem: view, attribute: .top, multiplier: 1, constant: 0).priority(950))
        self.addConstraint(NSLayoutConstraint(item: self.leftLineView, attribute: .trailing, relatedBy: .equal, toItem: view, attribute: .leading, multiplier: 1, constant: 0).priority(950))
        self.addConstraint(NSLayoutConstraint(item: self.rightLineView, attribute: .leading, relatedBy: .equal, toItem: view, attribute: .trailing, multiplier: 1, constant: 0).priority(950))
        view.addConstraint(NSLayoutConstraint(item: view, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .height, multiplier: 1, constant: self.lineSize).priority(950))
        return view
    }()
    
    private lazy var verticalBottomLineView: UIView = {
        let view = UIView()
        self.addSubview(view)
        view.translatesAutoresizingMaskIntoConstraints = false
        self.addConstraint(NSLayoutConstraint(item: self.verticalCenterView, attribute: .bottom, relatedBy: .equal, toItem: view, attribute: .top, multiplier: 1, constant: 0).priority(950))
        self.addConstraint(NSLayoutConstraint(item: self.leftLineView, attribute: .trailing, relatedBy: .equal, toItem: view, attribute: .leading, multiplier: 1, constant: 0).priority(950))
        self.addConstraint(NSLayoutConstraint(item: self.rightLineView, attribute: .leading, relatedBy: .equal, toItem: view, attribute: .trailing, multiplier: 1, constant: 0).priority(950))
        view.addConstraint(NSLayoutConstraint(item: view, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .height, multiplier: 1, constant: self.lineSize).priority(950))
        return view
    }()
    
    private lazy var horizontalLeftView: UIView = {
        let view = UIView()
        self.addSubview(view)
        view.translatesAutoresizingMaskIntoConstraints = false
        self.addConstraint(NSLayoutConstraint(item: self.leftLineView, attribute: .trailing, relatedBy: .equal, toItem: view, attribute: .leading, multiplier: 1, constant: 0).priority(950))
        self.addConstraint(NSLayoutConstraint(item: self.bottomLineView, attribute: .top, relatedBy: .equal, toItem: view, attribute: .bottom, multiplier: 1, constant: 0).priority(950))
        self.addConstraint(NSLayoutConstraint(item: self.topLineView, attribute: .bottom, relatedBy: .equal, toItem: view, attribute: .top, multiplier: 1, constant: 0).priority(950))
        return view
    }()
    
    private lazy var horizontalCenterView: UIView = {
        let view = UIView()
        self.addSubview(view)
        view.translatesAutoresizingMaskIntoConstraints = false
        self.addConstraint(NSLayoutConstraint(item: self.horizontalLeftLineView, attribute: .trailing, relatedBy: .equal, toItem: view, attribute: .leading, multiplier: 1, constant: 0).priority(950))
        self.addConstraint(NSLayoutConstraint(item: self.bottomLineView, attribute: .top, relatedBy: .equal, toItem: view, attribute: .bottom, multiplier: 1, constant: 0).priority(950))
        self.addConstraint(NSLayoutConstraint(item: self.topLineView, attribute: .bottom, relatedBy: .equal, toItem: view, attribute: .top, multiplier: 1, constant: 0).priority(950))
        self.addConstraint(NSLayoutConstraint(item: self.horizontalLeftView, attribute: .width, relatedBy: .equal, toItem: view, attribute: .width, multiplier: 1, constant: 0).priority(950))
        return view
    }()
    
    private lazy var horizontalRightView: UIView = {
        let view = UIView()
        self.addSubview(view)
        view.translatesAutoresizingMaskIntoConstraints = false
        self.addConstraint(NSLayoutConstraint(item: self.horizontalRightLineView, attribute: .trailing, relatedBy: .equal, toItem: view, attribute: .leading, multiplier: 1, constant: 0).priority(950))
        self.addConstraint(NSLayoutConstraint(item: self.bottomLineView, attribute: .top, relatedBy: .equal, toItem: view, attribute: .bottom, multiplier: 1, constant: 0).priority(950))
        self.addConstraint(NSLayoutConstraint(item: self.topLineView, attribute: .bottom, relatedBy: .equal, toItem: view, attribute: .top, multiplier: 1, constant: 0).priority(950))
        self.addConstraint(NSLayoutConstraint(item: self.rightLineView, attribute: .leading, relatedBy: .equal, toItem: view, attribute: .trailing, multiplier: 1, constant: 0).priority(950))
        self.addConstraint(NSLayoutConstraint(item: self.horizontalLeftView, attribute: .width, relatedBy: .equal, toItem: view, attribute: .width, multiplier: 1, constant: 0).priority(950))
        return view
    }()
    
    private lazy var verticalTopView: UIView = {
        let view = UIView()
        self.addSubview(view)
        view.translatesAutoresizingMaskIntoConstraints = false
        self.addConstraint(NSLayoutConstraint(item: self.topLineView, attribute: .bottom, relatedBy: .equal, toItem: view, attribute: .top, multiplier: 1, constant: 0).priority(950))
        self.addConstraint(NSLayoutConstraint(item: self.leftLineView, attribute: .trailing, relatedBy: .equal, toItem: view, attribute: .leading, multiplier: 1, constant: 0).priority(950))
        self.addConstraint(NSLayoutConstraint(item: self.rightLineView, attribute: .leading, relatedBy: .equal, toItem: view, attribute: .trailing, multiplier: 1, constant: 0).priority(950))
        return view
    }()
    
    private lazy var verticalCenterView: UIView = {
        let view = UIView()
        self.addSubview(view)
        view.translatesAutoresizingMaskIntoConstraints = false
        self.addConstraint(NSLayoutConstraint(item: self.verticalTopLineView, attribute: .bottom, relatedBy: .equal, toItem: view, attribute: .top, multiplier: 1, constant: 0).priority(950))
        self.addConstraint(NSLayoutConstraint(item: self.leftLineView, attribute: .trailing, relatedBy: .equal, toItem: view, attribute: .leading, multiplier: 1, constant: 0).priority(950))
        self.addConstraint(NSLayoutConstraint(item: self.rightLineView, attribute: .leading, relatedBy: .equal, toItem: view, attribute: .trailing, multiplier: 1, constant: 0).priority(950))
        self.addConstraint(NSLayoutConstraint(item: self.verticalTopView, attribute: .height, relatedBy: .equal, toItem: view, attribute: .height, multiplier: 1, constant: 0).priority(950))
        return view
    }()
    
    private lazy var verticalBottomView: UIView = {
        let view = UIView()
        self.addSubview(view)
        view.translatesAutoresizingMaskIntoConstraints = false
        self.addConstraint(NSLayoutConstraint(item: self.verticalBottomLineView, attribute: .bottom, relatedBy: .equal, toItem: view, attribute: .top, multiplier: 1, constant: 0).priority(950))
        self.addConstraint(NSLayoutConstraint(item: self.leftLineView, attribute: .trailing, relatedBy: .equal, toItem: view, attribute: .leading, multiplier: 1, constant: 0).priority(950))
        self.addConstraint(NSLayoutConstraint(item: self.rightLineView, attribute: .leading, relatedBy: .equal, toItem: view, attribute: .trailing, multiplier: 1, constant: 0).priority(950))
        self.addConstraint(NSLayoutConstraint(item: self.verticalTopView, attribute: .height, relatedBy: .equal, toItem: view, attribute: .height, multiplier: 1, constant: 0).priority(950))
        self.addConstraint(NSLayoutConstraint(item: self.bottomLineView, attribute: .top, relatedBy: .equal, toItem: view, attribute: .bottom, multiplier: 1, constant: 0).priority(950))
        return view
    }()
    
    override func awakeFromNib() {
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

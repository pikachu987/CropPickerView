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

final class TransparentView: UIView {
    private let white = UIColor(white: 255/255, alpha: 1)
    private let gray = UIColor(white: 192/255, alpha: 1)

    override init(frame: CGRect) {
        super.init(frame: frame)

        backgroundColor = UIColor(white: 255/255, alpha: 1)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func draw(_ rect: CGRect) {
        let backgroundPath = UIBezierPath()
        UIColor.white.set()
        backgroundPath.fill()
        backgroundPath.close()

        let horizontalCount = Int(ceil(rect.width / 16))
        let verticalCount = Int(ceil(rect.height / 16))

        for v in 0..<verticalCount {
            for h in 0..<horizontalCount {
                if (h + v) % 2 == 0 {
                    self.gray.set()
                } else {
                    self.white.set()
                }
                let path = UIBezierPath()
                path.move(to: CGPoint(x: 16 * h, y: 16 * v))
                path.addLine(to: CGPoint(x: (16 * h) + 16, y: 16 * v))
                path.addLine(to: CGPoint(x: (16 * h) + 16, y: (16 * v) + 16))
                path.addLine(to: CGPoint(x: 16 * h, y: (16 * v) + 16))
                path.fill()
                path.close()
            }
        }
    }
}

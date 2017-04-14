//
//  PhotosIndicator.swift
//  SalamTime
//
//  Created by Alexander on 13.04.17.
//
//

import UIKit

private class CircleIndicator: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        let maskLayer = CAShapeLayer()
        maskLayer.frame = bounds
        maskLayer.path = CGPath(ellipseIn: bounds, transform: nil)
        self.layer.mask = maskLayer
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class PhotosIndicator: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        if views.count == 0 {
            setup()
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // subclass and override default values
//    open let scaling: [CGFloat] = [0, 0.5714, 1, 1, 1, 0.5714, 0]
//    open let distances: [CGFloat] = [9.5, 13, 14.5, 14.5, 13, 9.5]
    
    open let scaling: [CGFloat] = [0, 0.5714, 1, 0.5714, 0]
    open let distances: [CGFloat] = [19.5, 23, 23, 19.5]
    open let diametr: CGFloat = 17
    
    var count: Int = 0
    var position: CGFloat = 0 {
        didSet {
            print(position)
            layout()
        }
    }
    
    var selectedColor: UIColor = UIColor.green
    var normalColor: UIColor = UIColor(red:0.26, green:0.24, blue:0.24, alpha:1.00)
    
    
    // MARK: - Private
    fileprivate var views: [UIView] = []
    fileprivate lazy var positions: [CGFloat] = {
        let halfDistances: CGFloat = self.distances.reduce(0, +) / 2.0
        var values: [CGFloat] = [-halfDistances]
        for d in self.distances {
            values.append(values.last! + d)
        }
        return values
    }()
    
    fileprivate func setup() {
        let maxDisplayCount = scaling.count - 1
        for _ in 0..<maxDisplayCount {
            let indicator = CircleIndicator(frame: CGRect(x: 0, y: 0, width: diametr, height: diametr))
            indicator.backgroundColor = normalColor
            views.append(indicator)
            addSubview(indicator)
        }
        layout()
    }
    fileprivate func layout2() {
        let midX = bounds.midX
        let midY = bounds.midY
        
        let startPos: CGFloat = position - CGFloat((views.count) / 2 - 1)
        let percent = position - floor(position)
        for (i, v) in views.enumerated() {
            let currPos = CGFloat(i) + startPos
            if currPos < 0 || currPos > CGFloat(count) {
                v.isHidden = true
                continue
            }
            v.isHidden = false
            
            let fromPos = positions[i]
            let toPos = positions[i+1]
            let x = fromPos + (toPos - fromPos) * percent + midX
            
            let fromScale = scaling[i]
            let toScale = scaling[i+1]
            let scale = fromScale + (toScale - fromScale) * percent
            
            v.transform = CGAffineTransform(scaleX: scale, y: scale)
            v.center = CGPoint(x: x, y: midY)
        }
    }
    
    fileprivate func layout() {
        let midX = bounds.midX
        let midY = bounds.midY
        
        if position == 0 {
            print("")
        }
        let half = ceil(CGFloat(views.count) / 2)
        let percent = position - floor(position)
        for (i, v) in views.enumerated() {
            let iPos = CGFloat(i) + percent
            let presentIndex = Int(position - half) + i
            if presentIndex < 0 || presentIndex > count {
                v.isHidden = true
                continue
            }
            
            v.isHidden = false
            
            let fromPos = positions[i+1]
            let toPos = positions[i]
            let x = fromPos + (toPos - fromPos) * percent + midX
            
            let fromScale = scaling[i+1]
            let toScale = scaling[i]
            let scale = fromScale + (toScale - fromScale) * percent
            
            let centerDist = abs(CGFloat(presentIndex) - position)
            if centerDist < 1 {
                v.backgroundColor = UIColor.colorBetweenHUE(color1: selectedColor, color2: normalColor, position: centerDist)
            } else {
                v.backgroundColor = normalColor
            }
            
            v.transform = CGAffineTransform(scaleX: scale, y: scale)
            v.center = CGPoint(x: x, y: midY)
        }
    }
}



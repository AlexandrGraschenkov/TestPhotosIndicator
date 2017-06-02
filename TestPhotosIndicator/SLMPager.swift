//
//  PhotoIndicator2.swift
//  TestPhotosIndicator
//
//  Created by Alexander on 02.06.17.
//  Copyright © 2017 Alex is the best. All rights reserved.
//

import UIKit

class SLMPager: UIView {
    
    fileprivate(set) var selectedColor: UIColor = UIColor(red: 0.8, green: 0.2, blue: 0.2, alpha: 1.0)
    fileprivate(set) var normalColor: UIColor = UIColor(red:0.26, green:0.24, blue:0.24, alpha:1.00)
    
    func updateColors(normal: UIColor, selected: UIColor) {
        normalColor = normal
        selectedColor = selected
        layout()
    }
    
    let scaling: [CGFloat] = [0, 0.6714, 1, 0.6714, 0]
    let distances: [CGFloat] = [-42.5, -23, 0, 23, 42.5]
    let dismissDist: CGFloat = 16
    let diametr: CGFloat = 15
    
    var count: Int = 0 {
        didSet {
            if oldValue == count { return }
            let circlesCount = min(distances.count, count)
            while circles.count < circlesCount {
                let indicator = CircleIndicator(frame: CGRect(x: 0, y: 0, width: diametr, height: diametr))
                indicator.backgroundColor = normalColor
                circles.append(indicator)
                addSubview(indicator)
            }
            while circles.count > circlesCount {
                circles.last?.removeFromSuperview()
                circles.removeLast()
            }
            layout()
        }
    }
    var position: CGFloat = 0 {
        didSet {
            layout()
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        layout()
    }
    
    // MARK: - private
    fileprivate var contentSize: CGSize = CGSize.zero
    fileprivate var circles: [CircleIndicator] = []
    
    fileprivate func layout() {
        let halfCircles = CGFloat(circles.count-1) / 2.0
        var reuseOffset = ceil(max(0, position - halfCircles))
        reuseOffset = min(CGFloat(count - circles.count), reuseOffset)
        
        for (idx, elem) in circles.enumerated() {
            displayCircle(circle: elem, centerOffset: CGFloat(idx) - position + reuseOffset)
        }
    }
    
    fileprivate func interpolate(pos: CGFloat, arr: [CGFloat]) -> CGFloat {
        if pos < 0 {
            return arr[0]
        }
        if pos >= CGFloat(arr.count-1) {
            return arr.last!
        }
        let idx = ceil(pos)
        let prevIdx = max(0, idx-1)
        return (arr[Int(idx)]-arr[Int(prevIdx)]) * (pos - prevIdx) + arr[Int(prevIdx)]
    }
    
    fileprivate func displayCircle(circle: CircleIndicator, centerOffset: CGFloat) {
        let midScaling: CGFloat = CGFloat(scaling.count - 1) / 2
        let scale: CGFloat = interpolate(pos: centerOffset + midScaling, arr: scaling)
        
        let midDistances: CGFloat = CGFloat(distances.count - 1) / 2
        var xOffset = bounds.width / 2.0
        var dCenterOffset = centerOffset
        if midDistances < dCenterOffset {
            let count = ceil(dCenterOffset - midDistances)
            dCenterOffset -= count
            xOffset += count * dismissDist
        } else if -midDistances > dCenterOffset {
            let count = ceil(dCenterOffset + midDistances)
            dCenterOffset += count
            xOffset -= count * dismissDist
        }
        xOffset += interpolate(pos: dCenterOffset + midDistances, arr: distances)
        
        circle.center = CGPoint(x: xOffset, y: bounds.height/2)
        circle.transform = CGAffineTransform(scaleX: scale, y: scale)
        
        let centerAbsOffset = abs(centerOffset)
        if centerAbsOffset < 1 {
//            circle.backgroundColor = colorForOffset(offset: centerAbsOffset)
            circle.backgroundColor = UIColor.colorBetweenHUE(color1: selectedColor, color2: normalColor, position: centerAbsOffset)
        } else {
            circle.backgroundColor = normalColor
        }
    }
}

//
//  ViewController.swift
//  TestPhotosIndicator
//
//  Created by Alexander on 13.04.17.
//  Copyright © 2017 Alex is the best. All rights reserved.
//

import UIKit

public extension UIColor {
    static func colorBetweenHUE(color1: UIColor, color2: UIColor, position: CGFloat) -> UIColor {
        var (h1, s1, b1, a1): (CGFloat, CGFloat, CGFloat, CGFloat) = (0.0, 0.0, 0.0, 0.0)
        color1.getHue(&h1, saturation: &s1, brightness: &b1, alpha: &a1)
        
        var (h2, s2, b2, a2): (CGFloat, CGFloat, CGFloat, CGFloat) = (0.0, 0.0, 0.0, 0.0)
        color2.getHue(&h2, saturation: &s2, brightness: &b2, alpha: &a2)
        
        let hue: CGFloat = h1 + ((h2 - h1) * position)
        let saturation: CGFloat = s1 + ((s2 - s1) * position)
        let brightness: CGFloat = b1 + ((b2 - b1) * position)
        let alpha: CGFloat = a1 + ((a2 - a1) * position)
        
        return UIColor(hue: hue, saturation: saturation, brightness: brightness, alpha: alpha)
    }
}

class ViewController: UIViewController {

    @IBOutlet weak var scroll: UIScrollView!
    var indicator: PhotosIndicator!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        scroll.contentSize = CGSize(width: 1000, height: 10)
        scroll.backgroundColor = UIColor.lightGray
        
        indicator = PhotosIndicator(frame: CGRect(x: 100, y: 300, width: 130, height: 30))
        indicator.count = 5
        indicator.backgroundColor = UIColor.yellow
        view.addSubview(indicator)
    }

}

extension ViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let count = CGFloat(indicator.count)
        let val = scrollView.contentOffset.x / (scrollView.contentSize.width - scrollView.bounds.width)
        indicator.position = val * (count)
    }
}

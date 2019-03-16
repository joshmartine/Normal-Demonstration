//
//  VerticalSlider.swift
//  MTLL iOS
//
//  Created by Josh Martine on 10/10/17.
//  Copyright © 2017 Josh Martine. All rights reserved.
//

import UIKit

class VerticalSlider: UIView {

    let slider = UISlider()
    
    @IBInspectable var minimumValue: Float = -1 {
        didSet {
            update()
        }
    }
    
    @IBInspectable var maximumValue: Float = 1 {
        didSet {
            update()
        }
    }
    
    @IBInspectable var value: Float {
        get {
            return slider.value
        }
        set {
            slider.setValue(newValue, animated: true)
        }
    }
    
    @IBInspectable var thumbTintColor: UIColor? {
        didSet {
            update()
        }
    }
    
    @IBInspectable var minimumTrackTintColor: UIColor? {
        didSet {
            update()
        }
    }
    
    @IBInspectable var maximumTrackTintColor: UIColor? {
        didSet {
            update()
        }
    }
    
    @IBInspectable var isContinuous: Bool = true {
        didSet {
            update()
        }
    }
    
    override var intrinsicContentSize: CGSize {
        get {
            return CGSize(width: slider.intrinsicContentSize.height, height: slider.intrinsicContentSize.width)
        }
    }
    
    required override init(frame: CGRect) {
        super.init(frame: frame)
        
        update()
        addSubview(slider)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        update()
        addSubview(slider)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        slider.bounds.size.width = bounds.height
        slider.center.x = bounds.midX
        slider.center.y = bounds.midY
    }
    
    private func update() {
        slider.transform = CGAffineTransform(rotationAngle: CGFloat(Double.pi / 2))
        
        slider.minimumValue = minimumValue
        slider.maximumValue = maximumValue
        slider.value = value
        slider.thumbTintColor = thumbTintColor
        slider.minimumTrackTintColor = minimumTrackTintColor
        slider.maximumTrackTintColor = maximumTrackTintColor
        slider.isContinuous = isContinuous
    }

}

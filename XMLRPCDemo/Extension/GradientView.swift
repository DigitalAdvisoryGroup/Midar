//
//  GradientView.swift
//  XMLRPCDemo
//
//  Created by Kuldip Mac on 25/08/20.
//  Copyright © 2020 Nyusoft. All rights reserved.
//

import Foundation


import UIKit

extension UIView {
    fileprivate func fillGradient(_ topColor: UIColor? = nil, bottomColor: UIColor? = nil) {
        let _topColor = topColor ?? UIColor(named: "71bf44") // 66BC58
        let _bottomColor = bottomColor ?? UIColor(named: "0f9644") // 009453
        
        guard let context = UIGraphicsGetCurrentContext() else {
            return print("No context")
        }
        
        let colors: [CGColor] = [_topColor!.cgColor, _bottomColor!.cgColor]
        let space = CGColorSpaceCreateDeviceRGB()
        
        let gradient = CGGradient(colorsSpace: space, colors: colors as CFArray, locations: nil)
        
        let y = bounds.size.height / 1.4
        context.drawLinearGradient(gradient!, start: CGPoint(x: 0.5, y: 0), end: CGPoint(x: 0.5, y: y), options: .drawsAfterEndLocation)
    }
    
    fileprivate func fillLinearGradient(_ topColor: UIColor, bottomColor: UIColor) {
        guard let context = UIGraphicsGetCurrentContext() else {
            return print("No context")
        }
        
        let colors: [CGColor] = [topColor.cgColor, bottomColor.cgColor]
        let space = CGColorSpaceCreateDeviceRGB()
        
        let gradient = CGGradient(colorsSpace: space, colors: colors as CFArray, locations: nil)
        
        let x = bounds.size.width / 1.4
        context.drawLinearGradient(gradient!, start: CGPoint(x: 0, y: 0), end: CGPoint(x: x, y: 0), options: .drawsAfterEndLocation)
    }
}

class GradientView: UIView {
    override func draw(_ rect: CGRect) {
        fillGradient()
    }
}

@IBDesignable class GradientButton: UIButton {
    @IBInspectable var borderColor: UIColor = .white
    @IBInspectable var isRounded: Bool = false
    @IBInspectable var radius: CGFloat = 12
    @IBInspectable var topBottomInset: CGFloat = 12
    
    @IBInspectable var topColor: UIColor = UIColor(named: "ed6723")!
    @IBInspectable var bottomColor: UIColor = UIColor(named: "f47a3c")!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        backgroundColor = .clear
        tintColor = .white
        contentEdgeInsets = .init(top: topBottomInset, left: 0, bottom: topBottomInset, right: 0)
        
        titleLabel?.font = .standardMediumFont(into: 1.2)
        layer.borderColor = borderColor.cgColor
        layer.borderWidth = 1.0
    }
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        if isRounded {
            let path = UIBezierPath(roundedRect: rect, cornerRadius: radius)
            path.addClip()
            path.fill()
        }
        fillLinearGradient(topColor, bottomColor: bottomColor)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let shadowPath = UIBezierPath(roundedRect: bounds, cornerRadius: radius)
        
        layer.masksToBounds = false
        layer.shadowColor = topColor.cgColor
        
        layer.shadowOffset = CGSize(width: 2, height: 2)
        layer.shadowOpacity = 0.5
        layer.shadowRadius = 4.0
        layer.shadowPath = shadowPath.cgPath
    }
    
    func setFont(_ font: UIFont? = nil) {
        let fontSize = Screen.width / (UIDevice.isPhone ? 18 : 28)
        
        if titleLabel?.font.pointSize == fontSize { return }
        
        self.titleLabel?.font = font ?? UIFont.standardBoldFont(ofSize: fontSize)
    }
}

@IBDesignable
class RoundedButton: UIButton {
    @IBInspectable var borderRadius: CGFloat = 12
    @IBInspectable var insets: CGFloat = 12
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        layer.cornerRadius = borderRadius
        
        if insets > 0 {
            contentEdgeInsets = .init(top: insets, left: insets * 4, bottom: insets, right: insets * 4)
        }
        titleLabel?.font = .standardFont()
    }
}

@IBDesignable
class BorderedButton: UIButton {
    @IBInspectable var cornerRadius: CGFloat = 8
    @IBInspectable var borderWidth: CGFloat = 1
    @IBInspectable var borderColor: UIColor = UIColor(hex: "009E51")!
    @IBInspectable var margin: CGFloat = 10
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        backgroundColor = .clear
        layer.cornerRadius = cornerRadius
        layer.borderWidth = borderWidth
        layer.borderColor = borderColor.cgColor
        
        contentEdgeInsets = .init(top: 4, left: margin, bottom: 4, right: margin)
    }
}

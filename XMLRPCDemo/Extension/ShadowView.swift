//
//  ShadowView.swift
//  XMLRPCDemo
//
//  Created by Kuldip Mac on 25/08/20.
//  Copyright © 2020 Nyusoft. All rights reserved.
//

import Foundation


import UIKit

@IBDesignable class ShadowView: UIView {

    @IBInspectable var cornerRadius: CGFloat = 8
    
    @IBInspectable var shadowOffsetWidth: CGFloat = 0
    @IBInspectable var shadowOffsetHeight: CGFloat = 0
    @IBInspectable var shadowColor: UIColor = .lightGray//UIColor("EEEFF3")
    @IBInspectable var shadowOpacity: Float = 0.5
    
    @IBInspectable var borderColor: UIColor?
    @IBInspectable var clips: Bool = false
    @IBInspectable var applyShadow: Bool = true
    
    override func layoutSubviews() {
        super.layoutSubviews()

        layer.cornerRadius = cornerRadius
        
        if applyShadow {
            let shadowPath = UIBezierPath(roundedRect: bounds, cornerRadius: cornerRadius)
            
            layer.masksToBounds = false
            layer.shadowColor = shadowColor.cgColor
            
            layer.shadowOffset = CGSize(width: shadowOffsetWidth, height: shadowOffsetHeight)
            layer.shadowOpacity = shadowOpacity
            layer.shadowRadius = 4.0
            layer.shadowPath = shadowPath.cgPath
        }
        
        if clips {
//            clipsToBounds = true
            let size = CGSize(width: cornerRadius, height: cornerRadius)
            let path = UIBezierPath(roundedRect: bounds, byRoundingCorners: [.topLeft, .topRight, .bottomLeft, .bottomRight], cornerRadii: size)
            let maskLayer = CAShapeLayer()
            maskLayer.path = path.cgPath
            
            layer.mask = maskLayer
        }
        layer.rasterizationScale = UIScreen.main.scale
        layer.shouldRasterize = true
        
        if let bColor = borderColor {
            layer.borderColor = bColor.cgColor
            layer.borderWidth = 1.0
        }
    }
}

extension UIView {
    func clip(_ corners: UIRectCorner, with radius: CGFloat) {
        let size = CGSize(width: radius, height: radius)
        let path = UIBezierPath(roundedRect: bounds, byRoundingCorners: corners, cornerRadii: size)
        let maskLayer = CAShapeLayer()
        maskLayer.path = path.cgPath
        
        layer.mask = maskLayer
    }
}


@IBDesignable class ShadowCellView: UIView {
    
    @IBInspectable var cornerRadius: CGFloat = 8
    
    @IBInspectable var shadowOffsetWidth: CGFloat = 0
    @IBInspectable var shadowOffsetHeight: CGFloat = 2
    @IBInspectable var shadowColor: UIColor = UIColor(hexString:"#EEEFF3")!//UIColor("EEEFF3")// ?? //UIColor(hex: "EEEFF3")!
    @IBInspectable var shadowOpacity: Float = 0.5
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        layer.cornerRadius = cornerRadius
        let shadowPath = UIBezierPath(roundedRect: bounds, cornerRadius: cornerRadius)
        
        layer.masksToBounds = false
        layer.shadowColor = shadowColor.cgColor
        layer.shadowOffset = CGSize(width: shadowOffsetWidth, height: shadowOffsetHeight)
        layer.shadowOpacity = shadowOpacity
        layer.shadowPath = shadowPath.cgPath
    }
    
}


extension UIView {
    
    @IBInspectable
    var cornerRadius1: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue
        }
    }
    /// To make circle
    @IBInspectable var isCircular: Bool {
        set {
            if newValue == true{
                let radiusValue = self.frame.size.height / 2
                layer.cornerRadius = radiusValue
            }
        }
        get {
            if self.cornerRadius1 == self.frame.size.height / 2{
                return true
            }
            return false
        }
    }
    
    @IBInspectable
    var borderWidth1: CGFloat {
        get {
            return layer.borderWidth
        }
        set {
            layer.borderWidth = newValue
        }
    }
    
    @IBInspectable
    var borderColor1: UIColor? {
        get {
            if let color = layer.borderColor {
                return UIColor(cgColor: color)
            }
            return nil
        }
        set {
            if let color = newValue {
                layer.borderColor = color.cgColor
            } else {
                layer.borderColor = nil
            }
        }
    }
    /*
    @IBInspectable
    var shadowRadius: CGFloat {
        get {
            return layer.shadowRadius
        }
        set {
            layer.shadowRadius = newValue
        }
    }
    
    @IBInspectable
    var shadowOpacity: Float {
        get {
            return layer.shadowOpacity
        }
        set {
            layer.shadowOpacity = newValue
        }
    }
    
    @IBInspectable
    var shadowOffset: CGSize {
        get {
            return layer.shadowOffset
        }
        set {
            layer.shadowOffset = newValue
        }
    }
    
    @IBInspectable
    var shadowColor: UIColor? {
        get {
            if let color = layer.shadowColor {
                return UIColor(cgColor: color)
            }
            return nil
        }
        set {
            if let color = newValue {
                layer.shadowColor = color.cgColor
            } else {
                layer.shadowColor = nil
            }
        }
    }
    */
    //FIND The parent view from UIVIEW
    var parentViewController: UIViewController? {
        var parentResponder: UIResponder? = self
        while parentResponder != nil {
            parentResponder = parentResponder!.next
            if let viewController = parentResponder as? UIViewController {
                return viewController
            }
        }
        return nil
    }
    
    //Add Bootom Border And Remove
    enum ViewBorder: String {
        case left, right, top, bottom
    }

    
        func add(border: ViewBorder, color: UIColor, width: CGFloat) {
            let borderLayer = CALayer()
            borderLayer.backgroundColor = color.cgColor
            borderLayer.name = border.rawValue
            switch border {
            case .left:
                borderLayer.frame = CGRect(x: 0, y: 0, width: width, height: self.frame.size.height)
            case .right:
                borderLayer.frame = CGRect(x: self.frame.size.width - width, y: 0, width: width, height: self.frame.size.height)
            case .top:
                borderLayer.frame = CGRect(x: 0, y: 0, width: self.frame.size.width, height: width)
            case .bottom:
                borderLayer.frame = CGRect(x: 0, y: self.frame.size.height - 2, width: self.frame.size.width, height: 2)
            }
            self.layer.addSublayer(borderLayer)
        }
        
        func remove(border: ViewBorder) {
            guard let sublayers = self.layer.sublayers else { return }
            var layerForRemove: CALayer?
            for layer in sublayers {
                if layer.name == border.rawValue {
                    layerForRemove = layer
                }
            }
            if let layer = layerForRemove {
                layer.removeFromSuperlayer()
            }
        }
        // OUTPUT 1
        func dropShadow(scale: Bool = true) {
            layer.masksToBounds = false
            layer.shadowColor = UIColor.black.cgColor
            layer.shadowOpacity = 0.5
            layer.shadowOffset = CGSize(width: -1, height: 1)
            layer.shadowRadius = 1
            
            layer.shadowPath = UIBezierPath(rect: bounds).cgPath
            layer.shouldRasterize = true
            layer.rasterizationScale = scale ? UIScreen.main.scale : 1
        }
        
        // OUTPUT 2
        func dropShadow(color: UIColor, opacity: Float = 0.5, offSet: CGSize, radius: CGFloat = 1, scale: Bool = true) {
            layer.masksToBounds = false
            layer.shadowColor = color.cgColor
            layer.shadowOpacity = opacity
            layer.shadowOffset = offSet
            layer.shadowRadius = radius
            
            layer.shadowPath = UIBezierPath(rect: self.bounds).cgPath
            layer.shouldRasterize = true
            layer.rasterizationScale = scale ? UIScreen.main.scale : 1
        }
}

extension UIColor {
    
    func redMaroonColor() -> UIColor {
        return UIColor.init(hexString: "CB252B")!
    }
    
    convenience init(red: Int, green: Int, blue: Int) {
        assert(red >= 0 && red <= 255, "Invalid red component")
        assert(green >= 0 && green <= 255, "Invalid green component")
        assert(blue >= 0 && blue <= 255, "Invalid blue component")
        
        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
    }
    
    convenience init(rgb: Int) {
        self.init(
            red: (rgb >> 16) & 0xFF,
            green: (rgb >> 8) & 0xFF,
            blue: rgb & 0xFF
        )
    }
    
    public convenience init?(redMaroonColor: String) {
        self.init(hexString: "CB252B")!
        
    }
    
    public convenience init?(hexString: String) {
        var cString: String = hexString.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines).uppercased()
        
        if (cString.hasPrefix("#")) {
            if let range = cString.range(of: cString) {
                cString = cString.substring(from: cString.index(range.lowerBound, offsetBy: 1))
            }
        }
        
        if ((cString.count) != 6) {
            self.init(white: 0.2, alpha: 1)
            return
        }
        
        var rgbValue: UInt32 = 0
        Scanner(string: cString).scanHexInt32(&rgbValue)
        
        self.init(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
    
    var hexString: String? {
        var red: CGFloat = 0
        var green: CGFloat = 0
        var blue: CGFloat = 0
        var alpha: CGFloat = 0
        
        let multiplier = CGFloat(255.999999)
        
        guard self.getRed(&red, green: &green, blue: &blue, alpha: &alpha) else {
            return nil
        }
        
        if alpha == 1.0 {
            return String(
                format: "#%02lX%02lX%02lX",
                Int(red * multiplier),
                Int(green * multiplier),
                Int(blue * multiplier)
            )
        }
        else {
            return String(
                format: "#%02lX%02lX%02lX%02lX",
                Int(red * multiplier),
                Int(green * multiplier),
                Int(blue * multiplier),
                Int(alpha * multiplier)
            )
        }
    }
}
class CheckBox: UIButton {
    // Images
    let checkedImage = UIImage(named: "ic_check_box")! as UIImage
    let uncheckedImage = UIImage(named: "ic_check_box_outline_blank")! as UIImage
    
    // Bool property
    var isChecked: Bool = false {
        didSet {
            if isChecked == true {
                self.setImage(checkedImage, for: UIControl.State.normal)
            } else {
                self.setImage(uncheckedImage, for: UIControl.State.normal)
            }
        }
    }
        
    override func awakeFromNib() {
        self.addTarget(self, action:#selector(buttonClicked(sender:)), for: UIControl.Event.touchUpInside)
        self.isChecked = false
    }
        
    @objc func buttonClicked(sender: UIButton) {
        if sender == self {
            isChecked = !isChecked
        }
    }
}

//
//  IconTextField.swift
//  XMLRPCDemo
//
//  Created by Kuldip Mac on 25/08/20.
//  Copyright © 2020 Nyusoft. All rights reserved.
//

import Foundation

import SkyFloatingLabelTextField

class IconTextField: SkyFloatingLabelTextFieldWithIcon {
    @IBInspectable var closeKeyboardOnReturn: Bool = true {
        didSet {
            self.returnKeyType = closeKeyboardOnReturn ? .done : .default
            self.setupControlChangeMethods()
        }
    }
    
    private var imagePadding: CGFloat { return 16 }
    
    override func titleLabelRectForBounds(_ bounds: CGRect, editing: Bool) -> CGRect {
        let size = titleLabel.intrinsicContentSize
        let padding: CGFloat = 10
        if editing {
            return CGRect(x: imagePadding, y: -(frame.height / 4.4), width: size.width + padding, height: size.height)
        }
        return CGRect(x: (imagePadding * 2 + iconWidth), y: size.height, width: size.width + padding, height: size.height)
    }
    
    override func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        var rect = super.placeholderRect(forBounds: bounds)
        rect.origin.y = bounds.height / 4.8
        return rect
    }
    
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        var rect = super.editingRect(forBounds: bounds)
        rect.origin.y = bounds.height / 4
        return rect
    }
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        var rect = super.textRect(forBounds: bounds)
        rect.origin.y = bounds.height / 4
        return rect
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        iconMarginBottom = frame.height / 4.0
        iconImageView.frame.origin.x = imagePadding
        borderLayer?.frame = bounds
    }
    weak var borderLayer: CALayer?
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupTheme()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupTheme()
    }
    
    private func setupTheme() {
        font = .standardFont(by: 1)
        titleFont = .standardFont(by: 1)
        
        tintColor = UIColor(hex: "197197")
        textColor = UIColor(hex: "777778")
       // titleColor = UIColor(hex: "99999A")
       // selectedTitleColor = UIColor(hex: "99999A")
        
        adjustsFontSizeToFitWidth = false
        titleFormatter = { (text: String) -> String in
            return text
        }
        
        let bLayer = CALayer()
        bLayer.frame = bounds
        bLayer.borderColor = UIColor(hex: "197197")?.cgColor
        bLayer.borderWidth = 1
        borderLayer = bLayer
        layer.addSublayer(bLayer)
        
        lineHeight = 0
        selectedLineHeight = 0
        
        titleLabel.textAlignment = .center
        titleLabel.backgroundColor = .white
        bringSubviewToFront(titleLabel)

        iconType = .image
        iconWidth = UIDevice.isPhone ? 20 : 28
        iconMarginLeft = imagePadding * 2
    
        titleFadeInDuration = 0.4
        titleFadeOutDuration = 0.5
        
        returnKeyType = closeKeyboardOnReturn ? .done : .default
        setupControlChangeMethods()
    }
    
    private func setupControlChangeMethods() {
        if closeKeyboardOnReturn {
            addTarget(self, action: #selector(returnKeyPressed(_:)), for: .primaryActionTriggered)
        } else {
            removeTarget(self, action: #selector(returnKeyPressed(_:)), for: .primaryActionTriggered)
        }
    }
    
    deinit {
        removeTarget(self, action: #selector(returnKeyPressed(_:)), for: .primaryActionTriggered)
    }
    
    @objc private func returnKeyPressed(_ textField: Any?) {
        resignFirstResponder()
    }
}


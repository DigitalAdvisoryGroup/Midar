//
//  Font.swift
//  XMLRPCDemo
//
//  Created by Kuldip Mac on 25/08/20.
//  Copyright © 2020 Nyusoft. All rights reserved.
//

import Foundation


import UIKit

extension UIFont {
    static let standardFontSize: CGFloat = {
        let fontSize: CGFloat
        if UIDevice.isPhone {
            fontSize = Screen.width / (Screen.isXSmall ? 26 : 28)
        } else {
            fontSize = Screen.width / 38
        }
        return fontSize
    }()
//    ["Poppins-Bold", "Poppins-SemiBold", "Poppins-Regular"]
    static func standardFont(ofType type: UIFont.TextStyle) -> UIFont {
        let font = UIFont(name: "Poppins-Regular", size: 14)!
        return UIFontMetrics(forTextStyle: type).scaledFont(for: font)
    }
    
    static func standardFont(ofSize size: CGFloat? = nil, by increment: CGFloat? = nil, into multiplier: CGFloat? = nil) -> UIFont {
        let fs = ((size ?? standardFontSize) + (increment ?? 0)) * (multiplier ?? 1)
        return UIFont(name: "Poppins-Regular", size: fs)!
    }
    
    static func standardBoldFont(ofSize size: CGFloat? = nil, by increment: CGFloat? = nil, into multiplier: CGFloat? = nil) -> UIFont {
        let fs = ((size ?? standardFontSize) + (increment ?? 0)) * (multiplier ?? 1)
        return UIFont(name: "Poppins-Bold", size: fs)!
    }
    
    static func standardMediumFont(ofSize size: CGFloat? = nil, by increment: CGFloat? = nil, into multiplier: CGFloat? = nil) -> UIFont {
        let fs = ((size ?? standardFontSize) + (increment ?? 0)) * (multiplier ?? 1)
        return UIFont(name: "Poppins-SemiBold", size: fs)!
    }
}

extension UIColor {
    public convenience init?(hex: String) {
        let r, g, b, a: CGFloat

        if hex.hasPrefix("#") {
            let start = hex.index(hex.startIndex, offsetBy: 1)
            let hexColor = String(hex[start...])

            if hexColor.count == 8 {
                let scanner = Scanner(string: hexColor)
                var hexNumber: UInt64 = 0

                if scanner.scanHexInt64(&hexNumber) {
                    r = CGFloat((hexNumber & 0xff000000) >> 24) / 255
                    g = CGFloat((hexNumber & 0x00ff0000) >> 16) / 255
                    b = CGFloat((hexNumber & 0x0000ff00) >> 8) / 255
                    a = CGFloat(hexNumber & 0x000000ff) / 255

                    self.init(red: r, green: g, blue: b, alpha: a)
                    return
                }
            }
        }

        return nil
    }
}

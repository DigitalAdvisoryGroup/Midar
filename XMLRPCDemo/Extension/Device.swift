//
//  Device.swift
//  XMLRPCDemo
//
//  Created by Kuldip Mac on 25/08/20.
//  Copyright © 2020 Nyusoft. All rights reserved.
//

import Foundation

import UIKit

extension UIDevice {
    static let isPhone = UIDevice.current.userInterfaceIdiom == .phone
    static let isPad = UIDevice.current.userInterfaceIdiom == .pad
}

class Screen {
    enum Size {
        case xSmall, small, medium, large
    }
    
    static let isXSmall = height >= 568 && height < 667
    static let size: Size = {
        if UIDevice.isPhone {
            if height >= 568 && height < 667 { return .xSmall }
            if height >= 667 && height < 736 { return .small }
            if height >= 736 && height < 812 { return .medium }
            if height >= 812 { return .large }
        } else {
            if height >= 1024 && width >= 768 && height < 1112 && width < 834.0 { return .small }
            if height >= 1112.0 && width >= 834.0 && height < 1194.0 { return .medium }
            if height >= 1366.0 && width >= 1024.0 { return .large }
        }
        return .medium
    }()
    
    static let width = UIScreen.main.bounds.width
    static let height = UIScreen.main.bounds.height
    
    private init() {}
}


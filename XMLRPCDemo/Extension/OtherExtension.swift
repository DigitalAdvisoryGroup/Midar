//
//  OtherExtension.swift
//  XMLRPCDemo
//
//  Created by Kuldip Mac on 25/08/20.
//  Copyright © 2020 Nyusoft. All rights reserved.
//

import Foundation
import UIKit
extension UIDevice {
    static var isSimulator: Bool {
        return ProcessInfo.processInfo.environment["SIMULATOR_DEVICE_NAME"] != nil
    }
}

// MARK: - UIApplication Utility Methods
//Top VIEW Controller
extension UIApplication {
    class func topViewController(controller: UIViewController? = UIApplication.shared.keyWindow?.rootViewController) -> UIViewController? {
        if let navigationController = controller as? UINavigationController {
            return topViewController(controller: navigationController.visibleViewController)
        }
        if let tabController = controller as? UITabBarController {
            if let selected = tabController.selectedViewController {
                return topViewController(controller: selected)
            }
        }
        if let presented = controller?.presentedViewController {
            return topViewController(controller: presented)
        }
        return controller
    }
}

extension NSAttributedString{
    func appendAttributeString(_ keyStrings : [String], keyFont : UIFont = UIFont.boldSystemFont(ofSize: 12), keyColor : UIColor = UIColor.darkGray, valueStrings : [String], valueFont : UIFont = UIFont.systemFont(ofSize: 15), valueColor : UIColor = .black) -> NSAttributedString{
        let combination = NSMutableAttributedString()
        
        let keyAttributes = [NSAttributedString.Key.foregroundColor: keyColor, NSAttributedString.Key.font: keyFont]
        let valueAttributes = [NSAttributedString.Key.foregroundColor: valueColor, NSAttributedString.Key.font: valueFont]
        
        for key in keyStrings{
            for value in valueStrings{
                let partOne = NSMutableAttributedString(string: key, attributes: keyAttributes)
                let partTwo = NSMutableAttributedString(string: value, attributes: valueAttributes)
                combination.append(partOne)
                combination.append(partTwo)
            }
        }
        return combination
    }
}
extension NSMutableAttributedString {
    public func setAsLink(textToFind:String, linkURL:String) -> Bool {
        
        let foundRange = self.mutableString.range(of: textToFind)
        if foundRange.location != NSNotFound {
            
           self.addAttribute(.link, value: linkURL, range: foundRange)
            
            return true
        }
        return false
    }
}

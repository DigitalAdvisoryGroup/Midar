//
//  GifImages.swift
//  Midar
//
//  Created by Kuldip Mac on 01/11/20.
//  Copyright © 2020 Nyusoft. All rights reserved.
//

import Foundation
import UIKit
import ImageIO
// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l < r
  case (nil, _?):
    return true
  default:
    return false
  }
}




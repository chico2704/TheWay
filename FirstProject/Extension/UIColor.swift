//
//  UIColor.swift
//  FirstProject
//
//  Created by ROGER on 25/06/2018.
//  Copyright © 2018 hexcon. All rights reserved.
//

import Foundation
import UIKit

extension UIColor {
    
    convenience init(red: Int, green: Int, blue: Int, a: CGFloat = 1.0) {
        self.init(
            red: CGFloat(red) / 255.0,
            green: CGFloat(green) / 255.0,
            blue: CGFloat(blue) / 255.0,
            alpha: a
        )
    }
    
    // Create a UIColor from a hex value (E.g 0x000000)
    convenience init(hex: Int, a: CGFloat = 1.0) {
        self.init(
            red: (hex >> 16) & 0xFF,
            green: (hex >> 8) & 0xFF,
            blue: hex & 0xFF,
            a: a
        )
    }
    
    // MARK: - Achromatic Color
    // title, name #474747
    static let titleBlack = UIColor(red: 71, green: 71, blue: 71)
    // content, little detail #6e6e6e
    static let contentGray = UIColor(red: 110, green: 110, blue: 110)
    // icon, placeholder, separator #b8b8b8
    static let placeHoderColor = UIColor(red: 184, green: 184, blue: 184)
    // searchBar, tableView_grouped background #f1f1f1
    static let backgroundGray = UIColor(red: 244, green: 244, blue: 244)
    
    // MARK: - Chromatic Color
    // main #34c8e6
    static let mainColor = UIColor(red: 52, green: 200, blue: 230)
    
}

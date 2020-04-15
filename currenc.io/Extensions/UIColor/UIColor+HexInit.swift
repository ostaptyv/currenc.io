//
//  UIColor+HexInit.swift
//  currenc.io
//
//  Created by Ostap on 03.04.2020.
//  Copyright © 2020 Ostap Tyvonovych. All rights reserved.
//

import UIKit

extension UIColor {
    public convenience init?(hex: String, alpha: CGFloat = 1) {
        let r, g, b: CGFloat
        var hex = hex
        
        if hex.hasPrefix("#") {
            hex.removeFirst()
        }
        
        guard hex.count == 6 else { return nil }
        
        let scanner = Scanner(string: hex)
        var hexNumber: UInt64 = 0
        
        guard scanner.scanHexInt64(&hexNumber) else { return nil }
        
        r = CGFloat((hexNumber & 0xff0000) >> 16) / 255
        g = CGFloat((hexNumber & 0x00ff00) >> 8) / 255
        b = CGFloat(hexNumber & 0x0000ff) / 255
        
        self.init(red: r, green: g, blue: b, alpha: alpha)
    }
}

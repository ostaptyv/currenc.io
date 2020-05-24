//
//  AxisValue.swift
//  currenc.io
//
//  Created by Ostap on 21.05.2020.
//  Copyright © 2020 Ostap Tyvonovych. All rights reserved.
//

protocol AxisValue: Numeric & Comparable & Divideable {
    var double: Double { get }
}

extension Int: AxisValue {
    var double: Double {
        return Double(self)
    }
}
extension Double: AxisValue {
    var double: Double {
        return self
    }
}

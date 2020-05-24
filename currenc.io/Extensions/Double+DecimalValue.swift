//
//  Double+DecimalValue.swift
//  currenc.io
//
//  Created by Ostap on 30.04.2020.
//  Copyright © 2020 Ostap Tyvonovych. All rights reserved.
//

import Foundation

extension Double {
    init(_ decimalValue: Decimal) {
        self.init(NSDecimalNumber(decimal: decimalValue).doubleValue)
    }
}

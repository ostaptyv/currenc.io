//
//  Divideable.swift
//  currenc.io
//
//  Created by Ostap on 21.05.2020.
//  Copyright © 2020 Ostap Tyvonovych. All rights reserved.
//

protocol Divideable {
    static func / (lhs: Self, rhs: Self) -> Self
}

extension Int: Divideable {}
extension Double: Divideable {}

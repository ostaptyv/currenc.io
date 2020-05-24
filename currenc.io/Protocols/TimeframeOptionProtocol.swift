//
//  TimeframeOptionProtocol.swift
//  currenc.io
//
//  Created by Ostap on 22.04.2020.
//  Copyright © 2020 Ostap Tyvonovych. All rights reserved.
//

protocol TimeframeOptionProtocol: CaseIterable, RawRepresentable where RawValue == String {
    static var defaultTimeframeOption: Self { get }
}

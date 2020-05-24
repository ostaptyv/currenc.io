//
//  CandlestickDataModel.swift
//  currenc.io
//
//  Created by Ostap on 16.04.2020.
//  Copyright © 2020 Ostap Tyvonovych. All rights reserved.
//

import Foundation

struct CandlestickDataModel: Decodable {
    let open: [Double]?
    let close: [Double]?
    
    let high: [Double]?
    let low: [Double]?
    
    let volume: [Double]?
    
    let status: Status
    let timeframe: [Int]?
    
    enum Status: String, Decodable {
        case ok = "ok"
        case noData = "no_data"
    }

    enum CodingKeys: String, CodingKey {
        case open = "o"
        case close = "c"
        case high = "h"
        case low = "l"
        case volume = "v"
        case status = "s"
        case timeframe = "t"
    }
}

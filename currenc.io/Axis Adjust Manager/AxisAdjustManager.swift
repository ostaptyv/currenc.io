//
//  AxisAdjustManager.swift
//  currenc.io
//
//  Created by Ostap on 07.05.2020.
//  Copyright © 2020 Ostap Tyvonovych. All rights reserved.
//

struct AxisAdjustManager<Value: AxisValue> {
    private(set) var currentValue: Value
    private(set) var range: ClosedRange<Value>
    
    let origin: Value
    let distance: Value
    let magnitude: Double
    
    private var limit: Value {
        return origin + distance
    }
    
    mutating func updateCurrentValue(_ newCurrentValue: Value) -> ClosedRange<Value> {
        mainIfClose: if newCurrentValue < limit {
            if newCurrentValue < origin {
                break mainIfClose
            }
            range = origin...limit
            
        } else {
            if (newCurrentValue / currentValue).double >= magnitude {
                range = newCurrentValue...(newCurrentValue + distance)
            } else {
                range = range.lowerBound...newCurrentValue
            }
        }
        
        currentValue = newCurrentValue
        
        return range
    }
    
    init(initialValue: Value, origin: Value = Value.zero, distance: Value, magnitude: Double) throws {
        self.currentValue = initialValue
        self.origin = origin
        self.distance = distance
        self.range = origin...origin
        
        guard (0.0...).contains(magnitude) && magnitude != 0.0 else {
            throw "Index out of range"
        }
        
        self.magnitude = magnitude
    }
}

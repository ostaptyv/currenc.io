//
//  CPTScatterPlot+Subscriber.swift
//  currenc.io
//
//  Created by Ostap on 16.04.2020.
//  Copyright © 2020 Ostap Tyvonovych. All rights reserved.
//

import Foundation
import Combine
import CorePlot

@available(iOS 13.0, *)
extension CPTScatterPlot {
    
    class DataSourceSubscriber: NSObject, Subscriber, CPTScatterPlotDataSource {
        typealias Input = Double
        typealias Failure = Never
        
        let automaticallyAdjustsAxises: Bool
        
        private(set) var plot: CPTScatterPlot?
        private(set) var plotSpace: CPTXYPlotSpace?
        private var axisAdjustManager: AxisAdjustManager<Input>?
        
        let numberOfRecords: UInt
        private var storage: [Input]
        
        private var currentIndex: UInt = 0
        private(set) var animationDuration: CGFloat

        // MARK: - Subscriber protocol requirements
        
        func receive(subscription: Subscription) {
            plot!.dataSource = self

            subscription.request(numberOfRecords > 0 ? .unlimited : .none)
        }
        
        func receive(_ input: CPTScatterPlot.DataSourceSubscriber.Input) -> Subscribers.Demand {
            manageStorage(input: input)
            plot!.insertData(at: UInt(storage.count - 1),  numberOfRecords: UInt(1))
            
            adjustAxises(input: input)
            
            animateTransition()
            currentIndex += 1
            print(storage)
            return .unlimited
        }
        
        func receive(completion: Subscribers.Completion<CPTScatterPlot.DataSourceSubscriber.Failure>) {
            plot = nil // nil out references when subscription finishes to prevent retail cycles
            plotSpace = nil
        }
        
        // MARK: - Scatter plot data source
        
        func numberOfRecords(for plot: CPTPlot) -> UInt {
            return UInt(storage.count)
        }
        
        func double(for plot: CPTPlot, field fieldEnum: UInt, record index: UInt) -> Double {
            let plotField = CPTScatterPlotField(rawValue: Int(fieldEnum))! // in fact bridging step from ObjC enum to Swift enum
            
            switch plotField {
            case .X:
                return Input(currentIndex)
            case .Y:
                return storage[Int(index)]
            default:
                print("Unknown CPTScatterPlotField case (rawValue: \(fieldEnum)) passed to call \(#function),  \(NSString(#file).lastPathComponent):\(#line)")
                return Input.zero
            }
        }
        
        // MARK: - Private methods
        
        private func manageStorage(input: Input) {
            storage.append(input)
            
            if (storage.count > numberOfRecords + .bufferStoreNumber) {
                storage.removeFirst()
                
                plot!.deleteData(inIndexRange: NSRange(location: 0, length: 1))
            }
        }
        
        private func adjustAxises(input: Input) {
            guard automaticallyAdjustsAxises else { return }
            
            if axisAdjustManager == nil {
                do {
                    axisAdjustManager = try AxisAdjustManager(initialValue: input, distance: 500.0, magnitude: 10.0)
                } catch {
                    print(error)
                }
            }
            
            let range = axisAdjustManager!.updateCurrentValue(input)
            
            let location = Decimal(range.lowerBound)
            let length = Decimal(range.upperBound - range.lowerBound)
            plotSpace?.yRange = CPTPlotRange(locationDecimal: location, lengthDecimal: length)
        }
        
        private func animateTransition() {
            guard currentIndex > numberOfRecords else { return }
            
            let length = Decimal(numberOfRecords)
            let location = Decimal(currentIndex) - length
            
            let oldRange = CPTPlotRange(locationDecimal: location - 1, lengthDecimal: length)
            let newRange = CPTPlotRange(locationDecimal: location,     lengthDecimal: length)
            
            CPTAnimation.animate(plotSpace!,
                                 property: #keyPath(CPTXYPlotSpace.xRange),
                                 from: oldRange,
                                 to: newRange,
                                 duration: animationDuration)
        }
        
        // MARK: - Initializers
        
        init(plot: CPTScatterPlot, numberOfRecords: UInt, plotSpace: CPTXYPlotSpace, animationDuration: CGFloat = .defaultAnimationDuration, automaticallyAdjustsAxises: Bool = true) {
            self.plot = plot
            self.numberOfRecords = numberOfRecords
            self.storage = [Input]()
            
            self.plotSpace = plotSpace
            self.animationDuration = animationDuration
            
            self.automaticallyAdjustsAxises = automaticallyAdjustsAxises
        }
    }
    
    func dataSourceSubscriber(numberOfRecords: UInt, plotSpace: CPTXYPlotSpace, animationDuration: CGFloat = .defaultAnimationDuration, automaticallyAdjustsAxises: Bool = true) -> DataSourceSubscriber {
        return DataSourceSubscriber(plot: self, numberOfRecords: numberOfRecords, plotSpace: plotSpace, animationDuration: animationDuration, automaticallyAdjustsAxises: automaticallyAdjustsAxises)
    }
}

// MARK: - Constants

fileprivate extension UInt {
    static let bufferStoreNumber: UInt = 2 // it's needed because when performing plot animation and deleting data from plot's cache there's a gap in a tail of the plot; set value of this constant to 0 to see the gap
}
fileprivate extension CGFloat {
    static let defaultAnimationDuration: CGFloat = 0.2
}
fileprivate extension Decimal {
    static let maximumYRangeBufferSize: Decimal = 500
}

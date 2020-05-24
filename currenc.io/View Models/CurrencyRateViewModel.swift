//
//  CurrencyRateViewModel.swift
//  currenc.io
//
//  Created by Ostap on 15.04.2020.
//  Copyright © 2020 Ostap Tyvonovych. All rights reserved.
//

import Foundation
import Combine

final class CurrencyRateViewModel: Setuppable {
    
    private let currencyDownloader = CurrencyDataDownloader()
    
    enum TimeframeOption: String, TimeframeOptionProtocol {
        static let defaultTimeframeOption = second1
        
        case second1 = "1s"
        case seconds5 = "5s"
        case seconds15 = "15s"
        case seconds30 = "30s"
        case seconds60 = "60s"
        case day = "Day"
        case week = "Week"
        case month = "Month"
        
        fileprivate func timeframeResolution() -> CurrencyDataDownloader.TimeframeResolution? {
            let newRawValue: String
            
            switch self {
            case .second1, .seconds5, .seconds15, .seconds30, .seconds60:
                newRawValue = String(self.rawValue.dropLast())
            case .day, .week, .month:
                newRawValue = String(self.rawValue.first ?? "\0")
            }
            
            return CurrencyDataDownloader.TimeframeResolution(rawValue: newRawValue)
        }
    }
    
    var cancellableSet = Set<AnyCancellable>()
    
    private(set) var highPricePublisher: AnyPublisher<Double, Never>!
    private(set) var lowPricePublisher: AnyPublisher<Double, Never>!
    private(set) var openPricePublisher: AnyPublisher<Double, Never>!
    private(set) var closePricePublisher: AnyPublisher<Double, Never>!
    
    private(set) var volumePublisher: AnyPublisher<Double, Never>!    
    private(set) var percentagePublisher: AnyPublisher<Double, Never>!
    private(set) var isIncreasingPublisher: AnyPublisher<Bool, Never>!
    
    let timeframeOptionSubject = PassthroughSubject<TimeframeOption, Never>()
    
    func setupInstance() {
        currencyDownloader.setupInstance()

        highPricePublisher = self.currencyDownloader.modelDataSubject
            .map { (model: CandlestickDataModel) in
                return model.high?.last ?? Double.zero
            }
            .replaceError(with: Double.zero)
            .eraseToAnyPublisher()
            
        lowPricePublisher = self.currencyDownloader.modelDataSubject
            .map { (model: CandlestickDataModel) in
                return model.low?.last ?? Double.zero
            }
            .replaceError(with: Double.zero)
            .eraseToAnyPublisher()
            
        openPricePublisher = self.currencyDownloader.modelDataSubject
            .map { (model: CandlestickDataModel) in
                return model.open?.last ?? Double.zero
            }
            .replaceError(with: Double.zero)
            .eraseToAnyPublisher()
            
        closePricePublisher = self.currencyDownloader.modelDataSubject
            .map { (model: CandlestickDataModel) in
                return model.close?.last ?? Double.zero
            }
            .replaceError(with: Double.zero)
            .eraseToAnyPublisher()
            
        volumePublisher = self.currencyDownloader.modelDataSubject
            .map { (model: CandlestickDataModel) in
                return model.volume?.last ?? Double.zero
            }
            .replaceError(with: Double.zero)
            .eraseToAnyPublisher()
        
        percentagePublisher = self.currencyDownloader.modelDataSubject
            .map { (model: CandlestickDataModel) in
                var result = Double.zero
                
                if model.status == .ok {
                    result = (model.close!.last! / model.open!.last! - 1.0) * 100.0 // * 100%
                }
                
                return result
            }
            .replaceError(with: Double.zero)
            .eraseToAnyPublisher()
        
        isIncreasingPublisher = self.percentagePublisher
            .map { (percentageRate) in
                return percentageRate >= Double.zero
            }
            .replaceError(with: false)
            .eraseToAnyPublisher()
        
        timeframeOptionSubject
            .map { timeframeOption in
                return timeframeOption.timeframeResolution()!
            }
            .subscribe(currencyDownloader.timeframeResolutionSubject)
            .store(in: &cancellableSet)
    }
}

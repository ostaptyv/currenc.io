//
//  CurrencyDataDownloader.swift
//  currenc.io
//
//  Created by Ostap on 22.04.2020.
//  Copyright © 2020 Ostap Tyvonovych. All rights reserved.
//

import Foundation
import Combine

class CurrencyDataDownloader: Setuppable {
    
    private var cancellableSet = Set<AnyCancellable>()
    
    private let baseUrl = "https://finnhub.io/"
    private let path = "/api/v1/crypto/candle"
    
    private let urlArgumentsDictionary = [
        "token": "bq2q9avrh5rfg81l7ch0",
        "symbol": "OANDA:GBP_USD"//"BINANCE:BTCUSDT"//
    ]
    
//    OANDA:GBP_USD
//    FOREX:401484392
//    FXCM:GBP/USD
//    FXPRO:2
//    IC MARKETS:2
    
//    BINANCE:BTCUSDT
    
    enum TimeframeResolution: String {
        case second1 = "1"
        case seconds5 = "5"
        case seconds15 = "15"
        case seconds30 = "30"
        case seconds60 = "60"
        case day = "D"
        case week = "W"
        case month = "M"
    }
    let timeframeResolutionSubject = PassthroughSubject<TimeframeResolution, Never>() // depending on received value, may change request's argument 'resolution'

    private let count = 1
    private let timeframePeriod = 1
    private static let requestFrequency = 1.0
    
    // Periodically performs network reguests
    private let timerPublisher = Timer.publish(every: CurrencyDataDownloader.requestFrequency, on: .current, in: .default)
        .autoconnect()
        .map { date in
            return Int(date.timeIntervalSince1970)
        }
    
    private var urlPublisher: AnyPublisher<URL, Never>! // composes URLs
    private var dataTaskPublisher: AnyPublisher<URLSession.DataTaskPublisher.Output, URLError>! // executes network requests
    private var modelDataPublisher: AnyPublisher<CandlestickDataModel, Error>! // decodes data and broadcasts it to a subject
    
    // Subject which broadcasts gotten models to the subscribers (public API)
    private(set) var modelDataSubject = PassthroughSubject<CandlestickDataModel, Error>()
    
    // MARK: - Setup instance
    
    func setupInstance() {
        urlPublisher = self.timerPublisher.combineLatest(timeframeResolutionSubject)
        .map { (unixTime, timeframeResolution) -> URL in
            let timeArgumentsDictionary = [
                "resolution": timeframeResolution.rawValue,
                "from": String(unixTime - self.count * self.timeframePeriod),
                "to": String(unixTime)
            ]
                
            let queryItems = timeArgumentsDictionary.merging(self.urlArgumentsDictionary) { (_, new) in
                return new
            }
            .map { dictionaryPair in
                return URLQueryItem(name: dictionaryPair.key, value: dictionaryPair.value)
            }
                
            var urlComponents = URLComponents(string: self.baseUrl)!
            urlComponents.queryItems = queryItems
            urlComponents.path = self.path
                
            return urlComponents.url!
        }
        .eraseToAnyPublisher()
            
        dataTaskPublisher = self.urlPublisher.map { url in
            return URLSession.shared.dataTaskPublisher(for: url)
        }
        .setFailureType(to: URLError.self)
        .switchToLatest()
        .eraseToAnyPublisher()
        
        modelDataPublisher = self.dataTaskPublisher.map { (tuple: URLSession.DataTaskPublisher.Output) -> Data in
            return tuple.data
        }
        .decode(type: CandlestickDataModel.self, decoder: JSONDecoder())
        .eraseToAnyPublisher()
        
        modelDataPublisher.subscribe(modelDataSubject).store(in: &cancellableSet)
    }
}

//
//  CoinManager.swift
//  ByteCoin
//
//  Created by Angela Yu on 11/09/2019.
//  Copyright © 2019 The App Brewery. All rights reserved.
//

import Foundation
protocol CoinManagerDelegate{
    func didFailWithError(_ error: Error)
    func didUpdateCurrency(_ coinManager: CoinManager, currency:CurrencyModel )
}
struct CoinManager {
    var delegate: CoinManagerDelegate?
    let baseURL = "https://rest.coinapi.io/v1/exchangerate/BTC"
    let apiKey = "3DA73354-6026-4CD9-AD53-5480C375ACBB"
    
    let currencyArray = ["AUD", "BRL","CAD","CNY","EUR","GBP","HKD","IDR","ILS","INR","JPY","MXN","NOK","NZD","PLN","RON","RUB","SEK","SGD","USD","ZAR","TRY"]
    
    func getCoinPrice(for currency: String){
        let urlString = "\(baseURL)/\(currency)?apikey=\(apiKey)"
        performRequest(with: urlString)
        
    }
    
    func performRequest(with urlString: String){
        if let url = URL(string: urlString){
            let session = URLSession(configuration: .default)
            
            let task = session.dataTask(with: url) { (data , response , error) in
                if error != nil {
                    self.delegate?.didFailWithError(error!)
                    return
                }
                if let safeData = data {
                    if let currency = self.parseJSON(safeData) {
                        self.delegate?.didUpdateCurrency(self, currency: currency)
                    }
                }
                
                
            }
            task.resume()
            
        }
        
        
    }
    func parseJSON(_ currencyData: Data) -> CurrencyModel?{
        let decoder = JSONDecoder()
        do{
            let decodedData = try decoder.decode(CurrencyData.self, from: currencyData)
            let rate = decodedData.rate
            
            let currency = CurrencyModel(rate: rate)
            return currency
        } catch {
            delegate?.didFailWithError(error)
            return nil
        }
        
    }
}

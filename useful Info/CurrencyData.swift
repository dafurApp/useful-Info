//
//  CurrencyData.swift
//  useful Info
//
//  Created by Daniel Furrer on 09.12.18.
//  Copyright © 2018 Daniel Furrer. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON


class CurrencyData{
    
    weak var delegate : CurrencyDataDelegate?
    
    static let shared = CurrencyData()
    
    var exchRateToCHF = 0.0
    var currencies = [Currency]()
    var datum : String = ""
    var baseCurrency : String = ""
    var symbol = [String]()
    var rates = [Double]()
    
    private init() {
        let symbols = ["EUR","CHF","USD","SEK","GBP"]
        
        for symbol in symbols {
            
            let currSymbol = Currency(symbol: symbol)
            currencies.append(currSymbol)
        }
    }
    
    func getPrices() {
        var listOfSymbols = ""
        for currency in currencies {
            listOfSymbols += currency.symbol
            if currency.symbol != currencies.last?.symbol {
                listOfSymbols += ","
            }
        }
        
        //let EXCHANGE_URL = "http://data.fixer.io/api/latest"
        //let APP_ID = "e3e1e47406e0a466f668530c2e56f82a"
 
        Alamofire.request("http://data.fixer.io/api/latest?access_key=e3e1e47406e0a466f668530c2e56f82a").responseJSON  {response in
            
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                //print("JSON: \(json)")
                let datum = json["date"].stringValue
                print("Date: \(datum)")
                //let arrayRates =  json["rates"].dictionary
                //print("Currencies: \(arrayRates)")
                
                /*
                for (key,subJson):(String, JSON) in arrayRates! {
                    print(key)
                    let wert = arrayRates![key]?.doubleValue
                    print(wert as Any)
                    UserDefaults.standard.set(wert, forKey: key )
                    for currency in self.currencies {
                        if key == currency.symbol {
                            currency.rate = wert!
                            }
                        }
                }
                */
            case .failure(let error):
                print(error)
            }
            
            self.translateToCHF()
            self.delegate?.newPrices?()
        }
        
    }
    
    func translateToCHF() {
        
            for currency in self.currencies {
                if  currency.symbol == "CHF" {
                self.exchRateToCHF = 1 / currency.rate
                   print("CHF-Kurs \(1 / currency.rate)")
                currency.factorCHF = exchRateToCHF
                }else{
                    print("CHF-Kurs nicht gefunden")
                }
            }
        }
    
}



class Currency {
    var symbol = ""
    var image = UIImage()
    var rate = 0.0
    var factorCHF = 1.0
    var amount = 0.0
    init(symbol: String) {
        self.symbol = symbol
        if let image = UIImage(named: symbol) {
            self.image = image
        }
        
    }
    
    func rateAsString() -> String {
        if rate == 0.0 {
            return "Loading..."
        }
        let formatter = NumberFormatter()
        formatter.locale = Locale(identifier: "de_DE")
        formatter.numberStyle = .currency
        if let fancyRate = formatter.string(from: NSNumber(floatLiteral: rate)){
            return fancyRate
        } else {
            return "ERROR"
        }
    }
}

@objc protocol CurrencyDataDelegate : class {
    @objc optional func newPrices()
    
}

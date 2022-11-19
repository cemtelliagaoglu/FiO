//
//  Manager.swift
//  FiO
//
//  Created by admin on 30.07.2022.
//
import Foundation

protocol CurrencyDelegate{
    func updateCurrency(_ value:Double)
}

class CurrencyManager{
    
    var currencies = [
        "TRY", "EUR", "USD", "CHF","GBP","AED", "AFN", "ALL", "AMD", "ANG", "AOA", "ARS", "AUD", "AWG", "AZN",
        "BAM", "BBD","BDT", "BGN", "BHD","BIF", "BMD", "BND", "BOB", "BRL", "BSD", "BTC", "BTN", "BWP", "BYN",
        "BYR", "BZD", "CAD", "CDF", "CLF", "CLP", "CNY", "COP", "CRC", "CUC", "CUP", "CVE", "CZK", "DJF", "DKK",
        "DOP", "DZD", "EGP", "ERN", "ETB", "FJD", "FKP",  "GEL", "GGP", "GHS", "GIP", "GMD", "GNF", "GTQ","GYD",
        "HKD", "HNL", "HRK", "HTG", "HUF", "IDR", "ILS", "IMP", "INR", "IQD", "IRR", "ISK", "JEP", "JMD", "JOD",
        "JPY", "KES", "KGS", "KHR", "KMF", "KPW", "KRW", "KWD", "KYD", "KZT", "LAK", "LBP", "LKR", "LRD", "LSL",
        "LTL", "LVL", "LYD", "MAD", "MDL", "MGA", "MKD", "MMK", "MNT", "MOP", "MRO", "MUR", "MVR", "MWK", "MXN",
        "MYR", "MZN", "NAD", "NGN", "NIO", "NOK", "NPR", "NZD", "OMR", "PAB", "PEN", "PGK", "PHP", "PKR", "PLN",
        "PYG", "QAR", "RON", "RSD", "RUB", "RWF", "SAR", "SBD", "SCR", "SDG", "SEK", "SGD", "SHP", "SLL", "SOS",
        "SRD", "STD", "SVC", "SYP", "SZL", "THB", "TJS", "TMT", "TND", "TOP", "TTD", "TWD", "TZS", "UAH", "UGX",
        "UYU", "UZS", "VEF", "VND", "VUV", "WST", "XAF", "XAG", "XAU", "XCD", "XDR", "XOF", "XPF", "YER", "ZAR",
        "ZMK", "ZMW", "ZWL"
    ]
 
    
    var currencyDelegate:CurrencyDelegate?
    
    
    func performRequest(from source:String, to currencies: String, for amount: Double){
        //You can get a free apiKey from the link below in order to use the app
        //https://apilayer.com/marketplace/currency_data-api#pricing
        
        let apiKey = ""  // Write your apiKey here
        let urlString = "https://api.apilayer.com/currency_data/live?source=\(source)&currencies=\(currencies)&apikey=\(apiKey)"

        if let url = URL(string: urlString){
            let request = URLRequest(url: url)
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: request) { data, response, err in
                if err != nil{
                    print(err!)
                }
                if let safeData = data{
                    if source == currencies{
                        self.currencyDelegate?.updateCurrency(1)
                    } else if source != currencies{
                        if let parsedData = self.parse(safeData){
                            guard let value = parsedData.quotes[source + currencies] else {
                                fatalError("Found nil while unwrapping Double?")}
                            self.currencyDelegate?.updateCurrency(value * amount)
                        }
                    }
                }
            }
            task.resume()
        }
    }
    
    
    func parse(_ data:Data) -> CurrencyModel?{
        let decoder = JSONDecoder()
        do{
            let decodedData = try decoder.decode(CurrencyModel.self, from: data)
            return decodedData
        }catch{
            print(error)
        }
        return nil
    }
    
}

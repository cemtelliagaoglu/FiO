//
//  WeatherModel.swift
//  FiO
//
//  Created by admin on 1.08.2022.
//

import Foundation

struct WeatherModel: Codable{
    let name: String
    let main:Main
    let weather: [Weather]
    let sys: Sys
    
    var isNight: Bool{
        let currentTime = Date()
        let sunsetTime = Date(timeIntervalSince1970: self.sys.sunset)
        let sunriseTime = Date(timeIntervalSince1970: self.sys.sunrise)
        
        if currentTime < sunriseTime || currentTime >= sunsetTime{
            return true
        }else{
            return false
        }
    }
    
    var weatherSymbol: String{
        
        switch weather[0].id{
        case 200...232:
            return "cloud.bolt"
        case 300...321:
            return "cloud.drizzle"
        case 500...531:
            return "cloud.rain"
        case 600...622:
            return "cloud.snow"
        case 701...781:
            return "cloud.fog"
        case 800:
            return isNight ? "moon" : "sun.max"
        case 801...804:
            return  isNight ? "cloud.moon" : "cloud.sun"
        default:
            return "cloud"
        }
    }
}


struct Main:Codable{
    let temp:Double
    let temp_min: Double
    let temp_max: Double
}

struct Weather:Codable{
    let id:Int
    let description: String
}

struct Sys:Codable{
    let sunrise: Double
    let sunset: Double
}


//
//  WeatherManager.swift
//  FiO
//
//  Created by admin on 1.08.2022.
//

import Foundation
import CoreLocation

protocol WeatherManagerDelegate{
    func updateWeather(_ weather: WeatherModel)
}

class WeatherManager{
    
    var delegate: WeatherManagerDelegate?
    //You can get a free apiKey from the link below in order to use the app
    // https://openweathermap.org/price
    
    let apiKey = "" // Write your apiKey here
    
    func fetchWeather(latitude: CLLocationDegrees, longitude: CLLocationDegrees){
        let weatherURL = "https://api.openweathermap.org/data/2.5/weather?units=metric&appid=\(apiKey)"
        let urlString = "\(weatherURL)&lat=\(latitude)&lon=\(longitude)"
        performRequest(with: urlString)
    }
    
    func fetchWeather(cityName:String){
        let weatherURL = "https://api.openweathermap.org/data/2.5/weather?units=metric&appid=\(apiKey)"
        let urlString = "\(weatherURL)&q=\(cityName)"
        performRequest(with: urlString)
    }
    
    
    func performRequest(with urlString: String){
        
        // 1- Create the URL
        if let url = URL(string: urlString){
        // 2- Create the URLSession
        let session = URLSession(configuration: .default)
        // 3- Give the session a task
        let task = session.dataTask(with: url) { data, response, error in
            if error != nil{
                print(error!)
                return
            }
            if let safeData = data{
                if let weather = self.parseJSON(safeData){
                    self.delegate?.updateWeather(weather)
                }
            }
        }
        // 4- Start the task
        task.resume()
        }
    }
    
    func parseJSON(_ weatherData:Data) -> WeatherModel?{
        let decoder = JSONDecoder()
        do{
        let parsedData = try decoder.decode(WeatherModel.self, from: weatherData)
            return parsedData
            
        }catch{
            print(error)
            return nil
        }
    }
    
}

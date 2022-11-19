//
//  WeatherViewController.swift
//  FiO
//
//  Created by admin on 30.07.2022.
//

import UIKit
import CoreLocation

class WeatherViewController: UIViewController,UITextFieldDelegate,CLLocationManagerDelegate{
    
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var weatherImage: UIImageView!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var cityNameLabel: UILabel!
    @IBOutlet weak var sunriseLabel: UILabel!
    @IBOutlet weak var sunsetLabel: UILabel!
    @IBOutlet weak var minTempLabel: UILabel!
    @IBOutlet weak var maxTempLabel: UILabel!
    
    let weatherManager = WeatherManager()
    let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        weatherManager.delegate = self
        searchTextField.delegate = self
        locationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.startUpdatingLocation()
        }
    }
    
    @IBAction func searchButtonPressed(_ sender: Any) {
        searchTextField.endEditing(true)
    }
    
    //MARK: - CoreLocation Methods
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last{
            // Stop updating otherwise it won't
            locationManager.stopUpdatingLocation()
            let lat = location.coordinate.latitude
            let lon = location.coordinate.longitude
            weatherManager.fetchWeather(latitude: lat, longitude: lon)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("GPS Error, \(error)")
    }
    
    @IBAction func locationButtonPressed(_ sender: UIButton) {
        
        if let currentLocation = locationManager.location?.coordinate{
            weatherManager.fetchWeather(latitude: currentLocation.latitude, longitude: currentLocation.longitude)
        }
    }
    //MARK: - TextField Delegate Methods
    

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        searchTextField.endEditing(true)
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField, reason: UITextField.DidEndEditingReason) {
        if let city = searchTextField.text{
            searchTextField.text = ""
            weatherManager.fetchWeather(cityName: city)
        }
    }
    
}

//MARK: - WeatherManagerDelegate

extension WeatherViewController: WeatherManagerDelegate{
    
    func updateWeather(_ weather: WeatherModel) {
        DispatchQueue.main.async {
            
            let sunriseString = self.convertTimeIntervalToString(time: weather.sys.sunrise)
            let sunsetString = self.convertTimeIntervalToString(time: weather.sys.sunset)
            
            self.sunriseLabel.text = sunriseString
            self.sunsetLabel.text = sunsetString
            self.view.backgroundColor = weather.isNight ? UIColor(named: "NightColor")! : UIColor(named: "DayColor")!
            self.temperatureLabel.text = String(format: "%.1f", weather.main.temp)
            self.cityNameLabel.text = weather.name
            self.minTempLabel.text = "\(String(format: "%.1f", weather.main.temp_min)) °C"
            self.maxTempLabel.text = "\(String(format: "%.1f", weather.main.temp_max)) °C"
            self.weatherImage.image = UIImage(systemName: weather.weatherSymbol)
        }
    }
    
    func convertTimeIntervalToString(time: Double)-> String{
        let timeAsDate = Date(timeIntervalSince1970: time)
        let dateFormatter = DateFormatter()
        dateFormatter.timeStyle = .short
        return dateFormatter.string(from: timeAsDate)
    }
}

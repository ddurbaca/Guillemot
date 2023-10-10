//
//  WeatherAlertViewModel.swift
//  WeatherAlert
//
//  Created by Dan Durbaca on 09.10.2023.
//

import Foundation

protocol WeatherAlertViewModelProtocol {
    func didUpdateWeatherAlerts()
}
class WeatherAlertViewModel: NSObject {
    var delegate: WeatherAlertViewModelProtocol?
    
    fileprivate(set) var weatherAlerts: [WeatherAlertModel] = []
    
    private var weatherAlertService = WeatherAlertService()

    func updateWeatherAlerts() {
        weatherAlertService.fetchWeatherAlerts(completion: { (weatherAlertResult, error) in
            if let error = error {
                print(error)
            } else {
                if let wAlertResult = weatherAlertResult {
                    self.weatherAlerts = wAlertResult.search
                    self.delegate?.didUpdateWeatherAlerts()
                }
            }
        })
    }
}

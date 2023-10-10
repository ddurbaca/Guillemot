//
//  WeatherAlertService.swift
//  WeatherAlert
//
//  Created by Dan Durbaca on 09.10.2023.
//

import Foundation

struct WeatherAlertService {
    private let base_url = "https://api.weather.gov/alerts/active?status=actual&message_type=alert"
    
    func fetchWeatherAlerts(completion: @escaping (WeatherAlertSearchModel?, Error?) -> ()) {
        let task = URLSession.shared.dataTask(with: URL(string: base_url)!){ data, response, error in

            guard let jsonData = data else { return }

            do {
                let studentData = try JSONDecoder().decode(WeatherAlertSearchModel.self, from: jsonData)
                completion(studentData, nil)

            }catch let error  {
                print(error)
                completion(nil, error)
            }
        }
        task.resume()
    }
}

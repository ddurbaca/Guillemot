//
//  WeatherAlertModel.swift
//  WeatherAlert
//
//  Created by Dan Durbaca on 09.10.2023.
//

import Foundation

struct WeatherAlertSearchModel: Codable {
    let search: [WeatherAlertModel]
    
    enum CodingKeys: String, CodingKey {
        case search = "features"
    }
}

struct WeatherAlertModel: Codable {
    let properties: WeatherAlertPropertiesModel
    
    enum CodingKeys: String, CodingKey {
        case properties = "properties"
    }
}

struct WeatherAlertPropertiesModel: Codable {
    let event_name, start_date, source: String
    let end_date: String?
    
    enum CodingKeys: String, CodingKey {
        case event_name = "event"
        case start_date = "effective"
        case end_date = "ends"
        case source = "senderName"
    }
}
/*
extension DataRequest {
    fileprivate func decodableResponseSerializer<T: Decodable>() -> DataResponseSerializer<T> {
        return DataResponseSerializer { _, response, data, error in
            guard error == nil else { return .failure(error!) }
            
            guard let data = data else {
                return .failure(AFError.responseSerializationFailed(reason: .inputDataNil))
            }
            
            return Result { try JSONDecoder().decode(T.self, from: data) }
        }
    }
    
    @discardableResult
    fileprivate func responseDecodable<T: Decodable>(queue: DispatchQueue? = nil, completionHandler: @escaping (DataResponse<T>) -> Void) -> Self {
        return response(queue: queue, responseSerializer: decodableResponseSerializer(), completionHandler: completionHandler)
    }
    
    @discardableResult
    func responseMovie(queue: DispatchQueue? = nil, completionHandler: @escaping (DataResponse<MovieSearchModel>) -> Void) -> Self {
        return responseDecodable(queue: queue, completionHandler: completionHandler)
    }
}*/

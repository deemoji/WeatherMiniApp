//
//  WeatherService.swift
//  
//
//  Created by Дмитрий Мартьянов on 08.09.2024.
//

import CoreLocation
import Alamofire

class WeatherService {
    private let locationManager = LocationManager()
    
    private let apiKey = "974d14499838696fce5ac43d76eafad5"
    private let baseUrl = "https://api.openweathermap.org/data/2.5/weather"

    func fetchWeather(for coordinate: CLLocationCoordinate2D, completion: @escaping (Result<WeatherResponce, Error>) -> Void) {
        let url = URL(string: "\(baseUrl)?lat=\(coordinate.latitude)&lon=\(coordinate.longitude)&appid=\(apiKey)&units=metric&lang=ru")!

        AF.request(url).responseDecodable(of: WeatherResponce.self) { responce in
            switch responce.result {
            case .success(let responce):
                completion(.success(responce))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}

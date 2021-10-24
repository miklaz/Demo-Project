//
//  NetworkService.swift
//  Demo-Project
//
//  Created by Михаил Зайцев on 21.10.2021.
//


import Foundation
import Alamofire
import SwiftyJSON

class NetworkService {
    
    static let session: Alamofire.Session = {
        let config = URLSessionConfiguration.default
        config.timeoutIntervalForRequest = 20
        let session = Alamofire.Session(configuration: config)
        return session
    }()
    // схема, базовый URL и ключ
    private let scheme = "https://"
    private let host = "api.openweathermap.org"
    private let appId = "7f8b21490ed838ad2a629d864825100a"
    
    // метод для загрузки данных о погоде
    func forecast(for city: String, completion: ((Swift.Result<[Weather], Error>) -> Void)? = nil) {
        // путь для получения погоды за 5 дней
        let path = "/data/2.5/forecast"
        // параметры для запроса
        let params = [
            "q": city,
            "units": "metric",
            "appId": appId
        ]
        // делаем запрос
        NetworkService.session.request(scheme + host + path, method: .get, parameters: params).responseJSON { response in
            switch response.result {
            case let .success(data):
                let json = JSON(data)
                
                if let errorMessage = json["message"].string {
                    let error = BackendError.cityNotFound(message: errorMessage)
                    completion?(.failure(error))
                    return
                }
                
                let weatherJSONs = json["list"].arrayValue
                let weathers = weatherJSONs.map { Weather(from: $0, city: city) }
                completion?(.success(weathers))
                
            case let .failure(error):
                completion?(.failure(error))
            }
        }
    }


}




//
//  WeatherDataSource.swift
//  DmForeCast
//
//  Created by Walter yun on 2021/06/02.
//

import Foundation
import CoreLocation

class WeatherDataSource {
    static let shared = WeatherDataSource()
    private init() {
        
        NotificationCenter.default.addObserver(forName: LocationManager.currentLocationDidUpdate, object: nil, queue: .main) { (noti) in
            
            //User Info에 저장되어있는 Location을 삭제
            if let location = noti.userInfo?["location"] as? CLLocation {
                self.fetch(location: location) {
                    NotificationCenter.default.post(name: Self.weatherInfoDidUpdate, object: nil)
                }
            }
        }
    }
    
    static let weatherInfoDidUpdate = Notification.Name(rawValue: "weatherInfoDidUpdate")
    
    
    var summary: CurrentWeather?
    var forecastList = [ForecastData]()
    
    //Api사용할때 저장할 DispatchQueue
    let apiQueue = DispatchQueue(label: "ApiQueue", attributes: .concurrent)
    
    let group = DispatchGroup()
    
    func fetch(location: CLLocation, completion: @escaping () -> ()){
        group.enter()
        apiQueue.async {
            self.fetchCurrentWeather(location: location) { (result) in
                switch result {
                case . success(let data):
                    self.summary = data
                default:
                    self.summary = nil
                }
                
                self.group.leave()
            }
        }
        
        group.enter()
        apiQueue.async {
            self.fetchForecast(location: location) { (result) in
                switch result {
                case . success(let data):
                    self.forecastList = data.list.map {
                        let dt = Date(timeIntervalSince1970: TimeInterval($0.dt))
                        let icon = $0.weather.first?.icon ?? ""
                        let weather = $0.weather.first?.description ?? "알 수 없음"
                        let temperature = $0.main.temp
                        
                        return ForecastData(date: dt, icon: icon, weather: weather, temperature: temperature)
                    }
                default:
                    self.forecastList = []
                }
                
                self.group.leave()
            }
        }
        
        group .notify(queue: .main){
        completion()
        }
    }
}

extension WeatherDataSource {
   private func fetch<ParsingType: Codable>(urlStr: String, completion: @escaping (Result<ParsingType, Error>) -> ()) {
        //URL 인스턴스
        guard let url = URL(string: urlStr) else {
            //fatalError 호출되면 크레쉬 발생 (배포시에 절대 사용하면 안됨) 공부용도
            //fatalError("URL 생성 실패")
            completion(.failure(ApiError.invalidUrl(urlStr)))
            return
        }
        
        //네트워크 요청 url세션 이용
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let error = error {
                //fatalError
                //fatalError(error.localizedDescription)
                completion(.failure(error))
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse else {
                //fatalError("invalid response")
                completion(.failure(ApiError.invalidResponse))
                return
            }
            
            //상태 코드가 200인지 확인
            guard httpResponse.statusCode == 200 else {
                //200이 아니라면 fatalError 출력
                //fatalError("failed code \(httpResponse.statusCode)")
                completion(.failure(ApiError.failed(httpResponse.statusCode)))
                return
                 
            }
            
            guard let data = data else {
                //fatalError("empty data")
                completion(.failure(ApiError.emptyData))
                return
            }
            
            do {
                let decoder = JSONDecoder()
                let data = try decoder.decode(ParsingType.self, from: data)
                
                completion(.success(data))
            } catch {
               // print(error)
               // fatalError(error.localizedDescription)
                completion(.failure(error))
            }
        }
        //task를 반드시 만들고 반드시 resume 호출
        task.resume()
    }
    
   private func fetchCurrentWeather(cityName: String, completion: @escaping (Result<CurrentWeather, Error>) -> ()) {
        let urlStr = "https://api.openweathermap.org/data/2.5/weather?q=\(cityName)&appid=\(apikey)&units=metric&lang=kr"
        
        fetch(urlStr: urlStr, completion: completion)
    }

    private func fetchCurrentWeather(cityId: Int, completion: @escaping (Result<CurrentWeather, Error>) -> ()) {
        let urlStr = "https://api.openweathermap.org/data/2.5/weather?id=\(cityId)&appid=\(apikey)&units=metric&lang=kr"
        
        fetch(urlStr: urlStr, completion: completion)
    }

    private func fetchCurrentWeather(location: CLLocation, completion: @escaping (Result<CurrentWeather, Error>) -> ()) {
        let urlStr = "https://api.openweathermap.org/data/2.5/weather?lat=\(location.coordinate.latitude)&lon=\(location.coordinate.longitude)&appid=\(apikey)&units=metric&lang=kr"
        
        fetch(urlStr: urlStr, completion: completion)
    }
}

extension WeatherDataSource {
   private func fetchForecast(cityName: String, completion: @escaping (Result<Forecast, Error>) -> ()) {
        let urlStr = "https://api.openweathermap.org/data/2.5/forecast?q=\(cityName)&appid=\(apikey)&units=metric&lang=kr"
        
        fetch(urlStr: urlStr, completion: completion)
    }

   private func fetchForecast(cityId: Int, completion: @escaping (Result<Forecast, Error>) -> ()) {
        let urlStr = "https://api.openweathermap.org/data/2.5/forecast?id=\(cityId)&appid=\(apikey)&units=metric&lang=kr"
        
        fetch(urlStr: urlStr, completion: completion)
    }

  private func fetchForecast(location: CLLocation, completion: @escaping (Result<Forecast, Error>) -> ()) {
        let urlStr = "https://api.openweathermap.org/data/2.5/forecast?lat=\(location.coordinate.latitude)&lon=\(location.coordinate.longitude)&appid=\(apikey)&units=metric&lang=kr"
        
        fetch(urlStr: urlStr, completion: completion)
    }
}

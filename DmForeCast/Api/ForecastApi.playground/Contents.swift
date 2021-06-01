import UIKit
import CoreLocation

struct Forecast: Codable {
    let cod: String
    let message: Int
    let cnt: Int
    
    struct ListItem: Codable {
        let dt: Int
        
        struct Main: Codable {
            let temp: Double
        }
        
        let main: Main
        
        struct Weather: Codable {
            let description: String
            let icon: String
        }
        
        let weather: [Weather]
    }
    
    let list: [ListItem]
}

enum ApiError: Error {
    case unknown
    case invalidUrl(String)
    case invalidResponse
    case failed(Int)
    case emptyData
}

func fetch<ParsingType: Codable>(urlStr: String, completion: @escaping (Result<ParsingType, Error>) -> ()) {
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

func fetchForecast(cityName: String, completion: @escaping (Result<Forecast, Error>) -> ()) {
    let urlStr = "https://api.openweathermap.org/data/2.5/forecast?q=\(cityName)&appid=2845c7954a2dc87a05d9e9ca813820dd&units=metric&lang=kr"
    
    fetch(urlStr: urlStr, completion: completion)
}

func fetchForecast(cityId: Int, completion: @escaping (Result<Forecast, Error>) -> ()) {
    let urlStr = "https://api.openweathermap.org/data/2.5/forecast?id=\(cityId)&appid=2845c7954a2dc87a05d9e9ca813820dd&units=metric&lang=kr"
    
    fetch(urlStr: urlStr, completion: completion)
}

func fetchForecast(location: CLLocation, completion: @escaping (Result<Forecast, Error>) -> ()) {
    let urlStr = "https://api.openweathermap.org/data/2.5/forecast?lat=\(location.coordinate.latitude)&lon=\(location.coordinate.longitude)&appid=2845c7954a2dc87a05d9e9ca813820dd&units=metric&lang=kr"
    
    fetch(urlStr: urlStr, completion: completion)
}

let location = CLLocation(latitude: 37.498206, longitude: 127.02761)
fetchForecast(location: location) { (result) in
    switch result {
    case .success(let weather):
        dump(weather)
    case .failure(let error):
        print(error)
        }
    }




//fetchForecast(cityName: "seoul") { _ in}
//
//
//fetchForecast(cityId: 1835847) { (result) in
//    switch result {
//    case .success(let weather):
//        dump(weather)
//    case .failure(let error):
//        print(error)
//    }
//}


import UIKit
import CoreLocation

//JSON 과 동일한 구조체 만들기 (Codable 프로토콜 채용)
struct CurrentWeather: Codable {
    let dt: Int
    
    struct Weather: Codable {
        let id: Int
        let main: String
        let description: String
        let icon: String
    }
    
    
    let weather: [Weather]
    
    struct Main: Codable {
        let temp: Double
        let temp_min: Double
        let temp_max: Double
    }
    
    let main: Main
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

func fetchCurrentWeather(cityName: String, completion: @escaping (Result<CurrentWeather, Error>) -> ()) {
    let urlStr = "https://api.openweathermap.org/data/2.5/weather?q=\(cityName)&appid=2845c7954a2dc87a05d9e9ca813820dd&units=metric&lang=kr"
    
    fetch(urlStr: urlStr, completion: completion)
}

func fetchCurrentWeather(cityId: Int, completion: @escaping (Result<CurrentWeather, Error>) -> ()) {
    let urlStr = "https://api.openweathermap.org/data/2.5/weather?id=\(cityId)&appid=2845c7954a2dc87a05d9e9ca813820dd&units=metric&lang=kr"
    
    fetch(urlStr: urlStr, completion: completion)
}

func fetchCurrentWeather(location: CLLocation, completion: @escaping (Result<CurrentWeather, Error>) -> ()) {
    let urlStr = "https://api.openweathermap.org/data/2.5/weather?lat=\(location.coordinate.latitude)&lon=\(location.coordinate.longitude)&appid=2845c7954a2dc87a05d9e9ca813820dd&units=metric&lang=kr"
    
    fetch(urlStr: urlStr, completion: completion)
}

let location = CLLocation(latitude: 37.498206, longitude: 127.02761)
fetchCurrentWeather(location: location) { (result) in
    switch result {
    case .success(let weather):
        dump(weather)
    case .failure(let error):
        print(error)
        }
    }


//fetchCurrentWeather(cityName: "seoul") { _ in}
//
//
//fetchCurrentWeather(cityId: 1835847) { (result) in
//    switch result {
//    case .success(let weather):
//        dump(weather)
//    case .failure(let error):
//        print(error)
//    }
//}


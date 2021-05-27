import UIKit

//JSON 과 동일한 구조체 만들기
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
        let temp_min: Int
        let temp_max: Int
    }
    
    let main: Main
}

func fetchCurrentWeather(cityName: String){
    let urlStr = "https://api.openweathermap.org/data/2.5/weather?q=\(cityName)&appid=2845c7954a2dc87a05d9e9ca813820dd&units=metric&lang=kr"
    
    //URL 인스턴스
    guard let url = URL(string: urlStr) else {
        //fatalError 호출되면 크레쉬 발생 (배포시에 절대 사용하면 안됨) 공부용도
        fatalError("URL 생성 실패")
    }
    
    //네트워크 요청 url세션 이용
    let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
        if let error = error {
            //fatalError
            fatalError(error.localizedDescription)
            return
        }
        
        guard let httpResponse = response as? HTTPURLResponse else {
            fatalError("invalid response")
        }
        
        guard httpResponse.statusCode == 200 else {
            fatalError("failed code \(httpResponse.statusCode)")
             
        }
        
        guard let data = data else {
            fatalError("empty data")
        }
        
        do {
            let decoder = JSONDecoder()
            let weather = try decoder.decode(CurrentWeather.self, from: data)
            
            weather.weather.first?.description
            
            weather.main.temp
        } catch {
            print(error)
            fatalError(error.localizedDescription)
        }
    }
    //task를 만들고 반드시 resume 호출
    task.resume()
    
}

fetchCurrentWeather(cityName: "seoul")



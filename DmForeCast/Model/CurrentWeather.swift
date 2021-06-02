//
//  CurrentWeather.swift
//  DmForeCast
//
//  Created by Walter yun on 2021/06/02.
//

import Foundation

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

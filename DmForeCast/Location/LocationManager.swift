//
//  LocationManager.swift
//  DmForeCast
//
//  Created by Walter yun on 2021/06/04.
//

import Foundation
import CoreLocation

class LocationManager: NSObject {
    static let shared = LocationManager()
    private override init() {
        manager = CLLocationManager()
        manager.desiredAccuracy = kCLLocationAccuracyThreeKilometers
        
        super.init()
        
        manager.delegate = self
    }
    
    let manager:CLLocationManager
    
    //외부에서 호출하는 메소드
    func updateLocation() {
        let status: CLAuthorizationStatus
        
        if #available(iOS 14.0, *) {
            status = manager.authorizationStatus
        } else {
            //현재 허가 상태 확인
            status = CLLocationManager.authorizationStatus()
        }
        
        switch status {
        case .notDetermined:
            requestAuthorization()
        case .authorizedAlways, .authorizedWhenInUse:
            requestAuthorization()
        //위치 정보를 사용할수 없음
        case .denied, .restricted:
            print("not available")
        default:
            print("unknown")
        }
    }
}

extension LocationManager: CLLocationManagerDelegate {
   private func requestAuthorization() {
        //권한 요청
        manager.requestWhenInUseAuthorization()
    
    }
    
   private func requestCurrentLocation() {
    //위치 정보를 지속적,반복적으로 받아야 한다면 startUpdatingLocation
    // manager.startUpdatingLocation()
        //위치를 한번, 일회성으로 요청 할때
        manager.requestLocation()
    }
    
    //iOS 14 이상 버전부터 실행되는 메소드
    @available(iOS 14.0, *)
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        switch manager.authorizationStatus {
        case .authorizedAlways, .authorizedWhenInUse:
            requestCurrentLocation()
        case .notDetermined, .denied, .restricted:
            print("not available")
        default:
            print("unknown")
            
        }
    }
    //iOS 14 이전 버전에서 실행되는 메소드
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .authorizedAlways, .authorizedWhenInUse:
            requestCurrentLocation()
        case .notDetermined, .denied, .restricted:
            print("not available")
        default:
            print("unknown")
        
        }
    }
    
    //새로운 위치 정보가 전달되면 반복적으로 호출 didUpdateLocations
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        print(locations.last)
    }
    
    //위치에 에러가 있을 시 호출되는 메소드 didFailWithError
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
}

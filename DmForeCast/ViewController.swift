//
//  ViewController.swift
//  DmForeCast
//
//  Created by Walter yun on 2021/05/19.
//

import UIKit
import CoreLocation

class ViewController: UIViewController {

    @IBOutlet weak var loader: UIActivityIndicatorView!
    
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var listTableView: UITableView!
    
    //공백
    var topInset = CGFloat(0.0)
    
    //view의 위치 배치가 완료된 다음 호출
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        //셀을 아래로 출력
        if topInset == 0.0 {
            //첫번째 셀에 해당하는 index 만들기
            let firstIndexPath = IndexPath(row: 0, section: 0)
            //셀을 가져올때는 테이블뷰에 요청
            if let cell = listTableView.cellForRow(at: firstIndexPath){
                topInset = listTableView.frame.height - cell.frame.height
                
                var inset = listTableView.contentInset
                inset.top = topInset
                listTableView.contentInset = inset
            }
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //시작시점 TableView를 숨기고 loader를 출력 (0.0은 화면을 숨김)
        listTableView.alpha = 0.0
        //loader를 화면에 표시
        loader.alpha = 1.0
        
        
        //backgroundColor 설정 (clear Color로 설정)
        listTableView.backgroundColor = .clear
        //separator 설정 x 
        listTableView.separatorStyle = .none
        //스크롤바 설정 x
        listTableView.showsVerticalScrollIndicator = false
       
//        //고정된 임시 좌표를 이용해 api를 불러오기
//        let location = CLLocation(latitude: 37.498206, longitude: 127.02761)
//        WeatherDataSource.shared.fetch(location: location) {
//            self.listTableView.reloadData()
//        }
        
        
        LocationManager.shared.updateLocation()
        
        NotificationCenter.default.addObserver(forName: WeatherDataSource.weatherInfoDidUpdate, object: nil, queue: .main) { (noti) in
            self.listTableView.reloadData()
            //Label에 Location 값을 저장
            self.locationLabel.text = LocationManager.shared.currentLocationTitle
            
            UIView.animate(withDuration: 3.0) {
                self.listTableView.alpha = 1.0
                self.loader.alpha = 0.0
            }
        }
        
    }


}

//DataSource 데이터 출력 뷰 컨트롤러
extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //section 파라피터로 분기
        switch section  {
        //1번째 섹션은 현재 날씨를 출력
        case 0:
            //셀을 1개만 표시 리턴 1
            return 1
        //2번째 섹션은 예보 데이터 출력
        case 1:
            //예보의 숫자만큼 리턴
            return WeatherDataSource.shared.forecastList.count
        default:
            return 0
            
        }
    }
    
    //테이블 뷰
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //SummaryTableViewCell 출력
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "SummaryTableViewCell", for: indexPath) as! SummaryTableViewCell
            
            //첫번째 셀에 날씨 표시
            if let weather = WeatherDataSource.shared.summary?.weather.first, let main = WeatherDataSource.shared.summary?.main {
                //이미지뷰 출력weather.icon
                cell.weatherImageView.image = UIImage(named: weather.icon)
                //레이블에 출력
                cell.statusLabel.text = weather.description
                //최고기온,최소기온 출력
                cell.minMaxLabel.text = "최고\(main.temp_max.temperatureString)  최소 \(main.temp_min.temperatureString)"
                //현재 온도 출력
                cell.currentTemperatureLabel.text = "\(main.temp.temperatureString)"
                
            }
            
            //셀을 리턴
            return cell
        }
        
        
        //ForecastTableViewCell 리턴
        let cell = tableView.dequeueReusableCell(withIdentifier: "ForecastTableViewCell", for: indexPath) as! ForecastTableViewCell
        
        let target = WeatherDataSource.shared.forecastList[indexPath.row]
        cell.dataLabel.text = target.date.dateString
        cell.timeLabel.text = target.date.timeString
        cell.weatherImage.image = UIImage(named: target.icon)
        cell.statusLabel.text = target.weather
        cell.temperatureLabel.text = target.temperature.temperatureString
        
        //cell 리턴
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
}

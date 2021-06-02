//
//  ViewController.swift
//  DmForeCast
//
//  Created by Walter yun on 2021/05/19.
//

import UIKit
import CoreLocation

class ViewController: UIViewController {

    
    @IBOutlet weak var listTableView: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        let location = CLLocation(latitude: 37.498206, longitude: 127.02761)
        WeatherDataSource.shared.fetch(location: location) {
            self.listTableView.reloadData()
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
            //예보의 숫자만큼 리턴 (나중에 수정)
            return 0
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
        
        //cell 리턴
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
}

//
//  ViewController.swift
//  DmForeCast
//
//  Created by Walter yun on 2021/05/19.
//

import UIKit

class ViewController: UIViewController {

    
    @IBOutlet weak var listTableView: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
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
            let cell = tableView.dequeueReusableCell(withIdentifier: "SummaryTableViewCell", for: indexPath)
            as! SummaryTableViewCell
            
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

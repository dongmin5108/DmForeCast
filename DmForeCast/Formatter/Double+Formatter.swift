//
//  Double+Formatter.swift
//  DmForeCast
//
//  Created by Walter yun on 2021/06/02.
//

import Foundation

//외부에서 접근 할수 없도록 fileprivate
fileprivate let temperatureFormatter: MeasurementFormatter = {
    //클로저를 사용하여 초기화
    let f = MeasurementFormatter()
    //지역 확인 lacale "ko_kr"을 제거하면 아이폰에서 설정된 위치를 반영
    f.locale = Locale(identifier: "ko_kr")
    //소수점이 0 이면 출력하지 않고 한자리만 출력
    f.numberFormatter.maximumFractionDigits = 1
    //기호문자열을 표지하지 않도록 수정
    f.unitOptions = .temperatureWithoutUnit
    //리턴
    return f
}()
//Double 타입 확장
extension Double {
    //Double을 기호 문자열로 바꾸는 속성
    var temperatureString: String {
        //섭시로 단위를 수정 .celsius
        let temp = Measurement<UnitTemperature>(value: self, unit: .celsius)
        
        return temperatureFormatter.string(from: temp)
    }
}

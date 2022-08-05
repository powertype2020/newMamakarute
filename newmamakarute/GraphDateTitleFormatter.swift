//
//  GraphDateTitleFormatter.swift
//  newmamakarute
//
//  Created by 武久　直幹 on 2022/08/04.
//

import Foundation
import Charts

class GraphDateTitleFormatter: AxisValueFormatter {
    
    var dateList: [Date] = []
    func stringForValue(_ value: Double, axis: AxisBase?) -> String {
        let index = Int(value)
        guard dateList.count > index else { return "" }
        let targetDate = dateList[index]
        let formatter = DateFormatter()
        let dateFormatString = "M/d"
        formatter.dateFormat = dateFormatString
        return formatter.string(from: targetDate)
    }
    
    
    
}

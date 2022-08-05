//
//  GraphVC.swift
//  newmamakarute
//
//  Created by 武久　直幹 on 2022/08/03.
//

import Foundation
import UIKit
import RealmSwift
import Charts

class GraphVC: UIViewController {
    
    @IBOutlet weak var graphView: LineChartView!
    
    
    @IBOutlet weak var startTextField: UITextField!
    
    
    @IBOutlet weak var endTextField: UITextField!
    
    
    var recordList: [DailyCondition] = []
    
    var datePicker: UIDatePicker {
        let datePicker: UIDatePicker = UIDatePicker()
        datePicker.datePickerMode = .date
        datePicker.timeZone = .current
        datePicker.preferredDatePickerStyle = .wheels
        datePicker.locale = Locale(identifier: "ja-JP")
        return datePicker
    }
    
    var dateFormatter: DateFormatter {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .long
        dateFormatter.timeZone = .current
        dateFormatter.locale = Locale(identifier: "ja-JP")
        return dateFormatter
    }

    
    
    override func viewWillAppear(_ animated: Bool) {
        setRecord()
        updateGraph()
        configureGraph()
        configureTextField()
    }
    
    
    
    func setRecord() {
        let realm = try! Realm()
        var result = Array(realm.objects(DailyCondition.self))
        result.sort(by: { $0.date < $1.date })
        recordList = result
        if let startDateText = startTextField.text,
           let endDateText = endTextField.text,
           let startDate = dateFormatter.date(from: startDateText),
           let endDate = dateFormatter.date(from: endDateText) {
            var filteredRecord = Array(realm.objects(DailyCondition.self).filter("date BETWEEN { %@, %@ }", startDate, endDate))
            filteredRecord.sort(by: { $0.date < $1.date })
            recordList = filteredRecord
        }
    }
    func updateGraph() {
        var entry = [ChartDataEntry]()
        recordList.enumerated().forEach({ index, record in
            let data = ChartDataEntry(x: Double(index), y: record.height)
            entry.append(data)
        })
        let dataSet = LineChartDataSet(entries: entry, label: "身長")
        graphView.data = LineChartData(dataSet: dataSet)
        graphView.data?.notifyDataChanged()
        graphView.notifyDataSetChanged()
    }
    
    func configureGraph() {
        graphView.xAxis.labelPosition = .bottom
        let titleFormatter = GraphDateTitleFormatter()
        let dateList = recordList.map({ $0.date })
        titleFormatter.dateList = dateList
        graphView.xAxis.valueFormatter = titleFormatter
    }
    
    @objc func didTapDone() {
        setRecord()
        updateGraph()
        view.endEditing(true)
    }
    
    @objc func didChangeStartDate(picker: UIDatePicker) {
        startTextField.text = dateFormatter.string(from: picker.date)
    }
    
    @objc func didChangeEndDate(picker: UIDatePicker) {
        endTextField.text = dateFormatter.string(from: picker.date)
    }
    
    func configureTextField() {
        let startDatePicker = datePicker
        let endDatePicker = datePicker
        let today = Date()
        let pastMonth = Calendar.current.date(byAdding: .month, value: -1, to: today)!
        startDatePicker.date = pastMonth
        endDatePicker.date = today
        startTextField.inputView = startDatePicker
        endTextField.inputView = endDatePicker
        startTextField.text = dateFormatter.string(from: pastMonth)
        endTextField.text = dateFormatter.string(from: today)
        let toolBarRect = CGRect(x: 0, y: 0, width: view.frame.size.width, height: 35)
        let toolBar = UIToolbar(frame: toolBarRect)
        let doneItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(didTapDone))
        toolBar.setItems([doneItem], animated: true)
        startTextField.inputAccessoryView = toolBar
        endTextField.inputAccessoryView = toolBar
        startDatePicker.addTarget(self, action: #selector(didChangeStartDate), for: .valueChanged)
        endDatePicker.addTarget(self, action: #selector(didChangeEndDate), for: .valueChanged)
    }
    
    
}

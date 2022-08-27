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
    
    @IBOutlet weak var selectGraph: UISegmentedControl!
    
    @IBAction func selectGraph(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            var entry = [ChartDataEntry]()
            recordList.enumerated().forEach({ index, record in
                let data = ChartDataEntry(x: Double(index), y: record.height)
                entry.append(data)
            })
            let dataSet = LineChartDataSet(entries: entry, label: "身長")
            graphView.data = LineChartData(dataSet: dataSet)
            graphView.data?.notifyDataChanged()
            graphView.notifyDataSetChanged()
        case 1:
            var entry = [ChartDataEntry]()
            recordList.enumerated().forEach({ index, record in
                let data = ChartDataEntry(x: Double(index), y: record.weight)
                entry.append(data)
            })
            let dataSet = LineChartDataSet(entries: entry, label: "体重")
            graphView.data = LineChartData(dataSet: dataSet)
            graphView.data?.notifyDataChanged()
            graphView.notifyDataSetChanged()
        case 2:
            var entry = [ChartDataEntry]()
            recordList.enumerated().forEach({ index, record in
                let data = ChartDataEntry(x: Double(index), y: record.temperature)
                entry.append(data)
            })
            let dataSet = LineChartDataSet(entries: entry, label: "体温")
            graphView.data = LineChartData(dataSet: dataSet)
            graphView.data?.notifyDataChanged()
            graphView.notifyDataSetChanged()
            
        default:
            print("失敗しました")
        }
        
    }
    
    var child: ChildProfile?
    var childData: ChildProfile?
    
    var recordList: [DailyCondition] = []
    
    let delegate : AppDelegate = UIApplication.shared.delegate as! AppDelegate
    
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

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setRecord()
        updateGraph()
        configureGraph()
        configureTextField()
    }
    
    func getRecord() {
        let realm = try? Realm()
        let result = realm? .objects(ChildProfile.self).first
        child = result
    }
    
    
    func setRecord() {
        let realm = try? Realm()
         guard let id = mainChildData?.id,
               let result = realm?.objects(ChildProfile.self).filter("id == %@", id).first else { return }
               var resultCondition = Array(result.dailyCondition)
               resultCondition.sort(by: { $0.date < $1.date })
        recordList = resultCondition
        if let startDateText = startTextField.text,
           let endDateText = endTextField.text,
           let startDate = dateFormatter.date(from: startDateText),
           let endDate = dateFormatter.date(from: endDateText) {
           let resultCondition = result.dailyCondition
           var filterRecord = Array(resultCondition.filter("date BETWEEN { %@, %@ }", startDate, endDate))
            filterRecord.sort(by: { $0.date < $1.date })
            recordList = filterRecord
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
        graphView.rightAxis.enabled = false
        
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

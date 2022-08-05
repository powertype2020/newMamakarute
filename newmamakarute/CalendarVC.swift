//
//  CalendarVC.swift
//  newmamakarute
//
//  Created by 武久　直幹 on 2022/08/03.
//

import Foundation
import UIKit
import FSCalendar
import RealmSwift

class CalendarVC: UIViewController {

         var editBarButtonItem: UIBarButtonItem!
         var addBarButtonItem: UIBarButtonItem!

         var recordList: [DailyCondition] = []
         var childList: [ChildProfile] = []
         var childList2: [ChildProfile2] = []
         var childList3: [ChildProfile3] = []
         var childList4: [ChildProfile4] = []
         var childList5: [ChildProfile5] = []
    
         @IBOutlet weak var calendarView: FSCalendar!

    @IBOutlet weak var addButton: UIButton!

    @IBAction func addButton(_ sender: UIButton) {
            transitionToEditorView()
         }
    
     
    @IBOutlet weak var childNameLabel: UILabel!
    

         @IBOutlet weak var childIconImageView: UIImageView!



         override func viewDidLoad() {
             super.viewDidLoad()
             self.title = "calendar"
             
             navigationController?.navigationBar.barTintColor = .systemPink
             navigationController?.navigationBar.tintColor = .white
             navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.white]


             configureCalendar()


             let realm = try! Realm()
             let result = realm.objects(ChildProfile.self).value(forKey: "id")
             let result2 = realm.objects(DailyCondition.self).value(forKey: "id")
             

             childNameLabel.text = String(describing: result)

             print("\(String(describing: result))")
             print("\(String(describing: result2))")

             self.title = "カレンダー画面"
                     self.view.backgroundColor = .white


             editBarButtonItem = UIBarButtonItem(title: "編集", style: .done, target: self, action: #selector(editBarButtonTapped(_:)))
             addBarButtonItem = UIBarButtonItem(title: "追加", style: .done, target: self, action: #selector(addBarButtonTapped(_:)))

             self.navigationItem.rightBarButtonItems = [editBarButtonItem]
             self.navigationItem.leftBarButtonItems = [addBarButtonItem]
             calendarView.dataSource = self
             calendarView.delegate = self
             

             
         }

         override func viewWillAppear(_ animated: Bool) {
             super.viewWillAppear(animated)
             getRecord()
             calendarView.reloadData()
         }

         func configureCalendar() {
             // ヘッダーの日付フォーマット変更
             calendarView.appearance.headerDateFormat = "yyyy年MM月dd日"

             // 曜日と今日の色指定
             calendarView.appearance.todayColor = .systemPink
             calendarView.appearance.headerTitleColor = .systemPink
             calendarView.appearance.weekdayTextColor = .black
             // 曜日表示内容を変更
             calendarView.calendarWeekdayView.weekdayLabels[0].text = "日"
             calendarView.calendarWeekdayView.weekdayLabels[1].text = "月"
             calendarView.calendarWeekdayView.weekdayLabels[2].text = "火"
             calendarView.calendarWeekdayView.weekdayLabels[3].text = "水"
             calendarView.calendarWeekdayView.weekdayLabels[4].text = "木"
             calendarView.calendarWeekdayView.weekdayLabels[5].text = "金"
             calendarView.calendarWeekdayView.weekdayLabels[6].text = "土"

             calendarView.calendarWeekdayView.weekdayLabels[0].textColor = .red
             calendarView.calendarWeekdayView.weekdayLabels[6].textColor = .blue

         }

         func transitionToEditorView(with record: DailyCondition? = nil) {
             let storyboard = UIStoryboard(name: "EditorVC", bundle: nil)
             guard let editorViewcontroller = storyboard.instantiateInitialViewController() as? EditorVC else { return }
             if let record = record {
                 editorViewcontroller.record = record
             }
             editorViewcontroller.delegate
             present(editorViewcontroller, animated: true)
         }

         func transitionToSignUpView() {
         let storyboard = UIStoryboard(name: "SignUpVC", bundle: nil)
         guard let signUpViewController = storyboard.instantiateInitialViewController() as? SignUpVC else { return }
         present(signUpViewController, animated: true)
         }

    @objc func editBarButtonTapped(_ sender: UIBarButtonItem) {
        transitionToSignUpView()
    
         }

         @objc func addBarButtonTapped(_ sender: UIBarButtonItem) {
             self.performSegue(withIdentifier: "showMenu", sender: nil)
             
         }

         func getRecord() {
             let realm = try! Realm()
             recordList = Array(realm.objects(DailyCondition.self))
             childList = Array(realm.objects(ChildProfile.self))
         }

     }

     extension CalendarVC: FSCalendarDataSource {
         func calendar(_ calendar: FSCalendar, numberOfEventsFor date: Date) -> Int {
             let dateList = recordList.map({ $0.date })
             let isEqualDate = dateList.contains(date.zeroclock)
             return isEqualDate ? 1 : 0
         }
     }

     extension CalendarVC: FSCalendarDelegate {
         func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
             calendar.deselect(date)
             guard let record = recordList.first(where: { $0.date.zeroclock == date.zeroclock }) else { return }
             transitionToEditorView(with: record)
         }
     }

extension CalendarVC: EditorViewContorollerDelegate {
    func recordUpdate() {
        getRecord()
        calendarView.reloadData()
    }
}

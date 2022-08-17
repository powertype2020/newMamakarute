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

var mainChildData: ChildProfile?

class CalendarVC: UIViewController, UITabBarDelegate {
    
    
         var delegate:AppDelegate = UIApplication.shared.delegate as! AppDelegate
         var editBarButtonItem: UIBarButtonItem!
         var addBarButtonItem: UIBarButtonItem!
         var recordList: [DailyCondition] = []
         var changeName = ""
         var getChildName = ""
         var child: ChildProfile?
         var unwrapChild = ChildProfile.self
    
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

             
             getRecord()
             configureCalendar()
             configure()
             
             self.title = "カレンダー画面"
             self.view.backgroundColor = .white
             
             let screenW:CGFloat = view.frame.size.width
                     let screenH:CGFloat = view.frame.size.height
                     childIconImageView.image = UIImage(named: "noImage")
                     childIconImageView.frame = CGRect(x:0, y:0, width:128, height:128)
                     childIconImageView.center = CGPoint(x:screenW/2, y:screenH/2)
                     self.view.addSubview(childIconImageView)

             editBarButtonItem = UIBarButtonItem(title: "追加", style: .done, target: self, action: #selector(editBarButtonTapped(_:)))
             addBarButtonItem = UIBarButtonItem(image: UIImage(named: "childMenu")!, style: .done, target: self, action: #selector(addBarButtonTapped(_:)))

             self.navigationItem.rightBarButtonItems = [editBarButtonItem]
             self.navigationItem.leftBarButtonItems = [addBarButtonItem]
             
             print(Realm.Configuration.defaultConfiguration.fileURL!)
             
         }

         override func viewWillAppear(_ animated: Bool) {
             super.viewWillAppear(animated)
             print("👀\(mainChildData)")
             recordUpdate()
         }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        presentingViewController?.endAppearanceTransition()
        recordUpdate()
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
    }
    
    override func didReceiveMemoryWarning() {
            super.didReceiveMemoryWarning()
        }
    
    func didSelectTab(tabBarController: MainTabBarVC) {
            print("first!")
        }
    
    func getRecord() {
        let realm = try? Realm()
        let result = realm? .objects(ChildProfile.self).first
        let resultName = result!.name
        mainChildData = result
        childNameLabel.text = resultName
        recordList = Array(result!.dailyCondition)
    }
    
    
    
    func transitionToSignUpView() {
    let storyboard = UIStoryboard(name: "SignUpVC", bundle: nil)
    guard let signUpViewController = storyboard.instantiateInitialViewController() as? SignUpVC else { return }
    present(signUpViewController, animated: true)
    }
    
    func transitionToEditorView(with record: DailyCondition? = nil) {
        let storyboard = UIStoryboard(name: "EditorVC", bundle: nil)
        guard let editorViewcontroller = storyboard.instantiateInitialViewController() as? EditorVC else { return }
        if let record = record {
            editorViewcontroller.record = record
        }
        present(editorViewcontroller, animated: true)
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

    @objc func editBarButtonTapped(_ sender: UIBarButtonItem) {
        transitionToSignUpView()
    
         }

         @objc func addBarButtonTapped(_ sender: UIBarButtonItem) {
             let nextView = storyboard?.instantiateViewController(identifier: "ChildMenuVC") as! ChildMenuVC
                 nextView.delegate = self
                 nextView.presentationController?.delegate = self
                 present(nextView, animated: false, completion: nil)
             
         }
}
    extension CalendarVC: ChildMenuVCDelegate {
         func willClose(with child: ChildProfile) {
             mainChildData = child
         }
     }
    
    

     extension CalendarVC: FSCalendarDataSource {
         func calendar(_ calendar: FSCalendar, numberOfEventsFor date: Date) -> Int {
             let dateList = recordList.map({ $0.date.zeroclock })
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
        dataReload()
        calendarView.reloadData()
    }
}

extension CalendarVC: UIAdaptivePresentationControllerDelegate {
  func presentationControllerDidDismiss(_ presentationController: UIPresentationController) {
      dataReload()
  }
}

private extension CalendarVC {
    func configure() {
        calendarView.dataSource = self
        calendarView.delegate = self
    }
    
    func dataReload() {
       let realm = try? Realm()
        guard let id = mainChildData?.id,
              let result = realm?.objects(ChildProfile.self).filter("id == %@", id).first else { return }
        let resultName = result.name
        let resultCondition = result.dailyCondition
        childNameLabel.text = resultName
        recordList = Array(resultCondition)
        calendarView.reloadData()
    }
}

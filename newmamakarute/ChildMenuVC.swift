//
//  ChildMenuVC.swift
//  newmamakarute
//
//  Created by 武久　直幹 on 2022/08/03.
//

import Foundation
import UIKit
import RealmSwift
import AuthenticationServices


class ChildMenuVC: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    public weak var CalendarVC: CalendarVC!
    
    @IBOutlet weak var childNameTableView: UITableView!
    
     @IBOutlet weak var menuView: UIView!
     
    
    var getNumber: Int = 0

     override func viewDidLoad() {
         super.viewDidLoad()
         
         childNameTableView.dataSource = self
         childNameTableView.delegate = self
     }

     override func viewWillAppear(_ animated: Bool) {
         super.viewWillAppear(animated)
         // メニュー画面の位置
         let menuPosition = self.menuView.layer.position
         // 初期位置設定
         self.menuView.layer.position.x = -self.menuView.frame.width
         // 表示アニメーション
         UIView.animate(
             withDuration: 0.1, delay: 0, options: .curveEaseOut, animations: {
                 self.menuView.layer.position.x = menuPosition.x
             }, completion: { bool in })
     }

     // メニュー外をタップした場合に非表示にする
     override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
         super.touchesEnded(touches, with: event)
         for touch in touches {
             if touch.view?.tag == 1 {
                 UIView.animate( withDuration: 0.2, delay: 0, options: .curveEaseIn, animations: {
                     self.menuView.layer.position.x = -self.menuView.frame.width
                 }, completion: { bool in self.dismiss(animated: true, completion: nil)

                 }
                 )
             }
         }
     }

     override func didReceiveMemoryWarning() {
         super.didReceiveMemoryWarning()
     }
    
    func changeChildName() {
        
        
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let realm = try! Realm()
        let childs = realm.objects(ChildProfile.self).value(forKey: "name")
        let childsName = childs as Any
        return (childsName as AnyObject).count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let realm = try! Realm()
        let childList = realm.objects(ChildProfile.self)
        let childs = childList.self.value(forKey: "name")
        let childsName = childs as! Array<Any>
        cell.textLabel!.text = childsName[indexPath.row] as? String
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let calendarVC = newmamakarute.CalendarVC()
        getNumber = indexPath.row
        let realm = try! Realm()
        let resultName = realm.objects(ChildProfile.self).value(forKey: "name")
        let childsName: [String] = resultName as! [String]
        let childName = childsName[getNumber]
        calendarVC.changeName = childName
        dismiss(animated: true, completion: nil)
    }
    }
extension ChildMenuVC {
    override func dismiss(animated flag: Bool, completion: (() -> Void)? = nil) {
        super.dismiss(animated: flag, completion: completion)
        guard let presentationController = presentationController else {
            return
        }
        presentationController.delegate?.presentationControllerDidDismiss?(presentationController)
    }
}

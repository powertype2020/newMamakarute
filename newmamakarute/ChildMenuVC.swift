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


protocol ChildMenuVCDelegate {
     func willClose(with child: ChildProfile)
 }

class ChildMenuVC: UIViewController, UITableViewDataSource, UITableViewDelegate, UIAdaptivePresentationControllerDelegate {
    
    
    public weak var CalendarVC: CalendarVC!
    
    @IBOutlet weak var childNameTableView: UITableView!
    
     @IBOutlet weak var menuView: UIView!
     
    
    private var childList: [ChildProfile] = []
    
    var getNumber: Int = 0
    
    var delegate: ChildMenuVCDelegate?

     override func viewDidLoad() {
         super.viewDidLoad()
         dataReload()
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
    
    func dataReload() {
       let realm = try? Realm()
        guard let result = realm?.objects(ChildProfile.self) else { return }
        childList = Array(result)
    }
    
    func transitionToCalendarVC(with child: ChildProfile) {
        delegate?.willClose(with: child)
        dismiss(animated: true, completion: nil)
    }
    

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return childList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        let childs = childList[indexPath.row]
        cell.textLabel?.text = childs.name
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let calendarVC = storyboard?.instantiateViewController(identifier: "CalendarVC") as! CalendarVC
        calendarVC.presentationController?.delegate = self
        let child = childList[indexPath.row]
        print(child)
        transitionToCalendarVC(with: child)
        childNameTableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let editAction = UIContextualAction(style: .normal, title: "Edit") { (action, view, completionHandler) in
          print("Editがタップされた")
          completionHandler(true)
        }
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { (action, view, completionHandler) in
          let alert = UIAlertController(title: "データを消しますか？", message: "今までの記録が消えてしまいます", preferredStyle: .alert)
          let delete = UIAlertAction(title: "削除", style: .default, handler: { (action) -> Void in
                    print("Delete button tapped")
          let alert = UIAlertController(title: "本当に消しますか？", message: "データを戻すことはできません", preferredStyle: .alert)
          let delete = UIAlertAction(title: "削除", style: .default, handler: { (action) -> Void in
                        print("Delete button tapped final")
                    })
                    
          let cancel = UIAlertAction(title: "キャンセル", style: .cancel, handler: { (action) -> Void in
                        print("Cancel button tapped")
                  self.dismiss(animated: true, completion: nil)
                    })
              alert.addAction(delete)
              alert.addAction(cancel)
              self.present(alert, animated: true, completion: nil)                })
                
          let cancel = UIAlertAction(title: "キャンセル", style: .cancel, handler: { (action) -> Void in
                    print("Cancel button tapped")
              self.dismiss(animated: true, completion: nil)
                })
            
            alert.addAction(delete)
            alert.addAction(cancel)
            self.present(alert, animated: true, completion: nil)
            
          print("Deleteがタップされた")
            
          completionHandler(true)
        }
        return UISwipeActionsConfiguration(actions: [deleteAction, editAction])
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

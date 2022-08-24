//
//  SignUpVC.swift
//  newmamakarute
//
//  Created by 武久　直幹 on 2022/08/03.
//

import Foundation
import UIKit
 import RealmSwift

 class SignUpVC: UIViewController, UIImagePickerControllerDelegate & UINavigationControllerDelegate {

     

     @IBOutlet weak var inputIconImageView: UIImageView!


     @IBOutlet weak var inputChildNameTextField: UITextField!

     @IBOutlet weak var signUpButton: UIButton!


     @IBAction func signUpButton(_ sender: UIButton) {
         saveRecord()

     }


     var record = ChildProfile()
     
     override func viewDidLoad() {
         super.viewDidLoad()

         let sampleImage = UIImage(named: "noimage")
         inputIconImageView.image = sampleImage

         let realm = try! Realm()
         let firstRecord = realm.objects(ChildProfile.self).first
         print("👀firstRecord: \(String(describing: firstRecord))")

         configureChildNameTextField()

     }

     @objc func imageViewTapped(_ sender: UITapGestureRecognizer) {
         // カメラロールが利用可能か
                 if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
                     // 写真を選ぶビュー
                     let pickerView = UIImagePickerController()
                     // 写真の選択元をカメラロールにする
                     // 「.camera」にすればカメラを起動できる
                     pickerView.sourceType = .photoLibrary
                     // デリゲート
                     pickerView.delegate = self
                     // ビューに表示
                     self.present(pickerView, animated: true)
                 }

     }

     // 写真を選んだ後に呼ばれる処理
     func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
         // 選択した写真を取得する
         let image = info[.originalImage] as! UIImage
         // ビューに表示する
         inputIconImageView.image = image
         // 写真を選ぶビューを引っ込める
         self.dismiss(animated: true)
     }

     func saveRecord() {
         let realm = try! Realm()
         try! realm.write {
             if let nameText = inputChildNameTextField.text,
                let childName = String?(nameText) {
                 record.name = childName
             }
             if let inputIconData = inputIconImageView.image?.pngData(),
                let dateImage = Data?(inputIconData) {
                 record.icon = dateImage
             }

             realm.add(record)
         }

         dismiss(animated: true)

         }

     @objc func didTapDone() {
         view.endEditing(true)
     }

     func configureChildNameTextField() {
         let toolBarRect = CGRect(x: 0, y: 0, width: view.frame.size.width, height: 35)
         let toolBar = UIToolbar(frame: toolBarRect)
         let doneItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(didTapDone))
         toolBar.setItems([doneItem], animated: true)
         inputChildNameTextField.inputAccessoryView = toolBar

     }

 }

extension Array {
    subscript (element index: Index) -> Element? {
        // 配列にない要素があればnilを返す
        indices.contains(index) ? self[index] : nil
    }
}

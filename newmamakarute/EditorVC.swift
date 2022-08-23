//
//  EditorVC.swift
//  newmamakarute
//
//  Created by 武久　直幹 on 2022/08/03.
//

import Foundation
import UIKit
import RealmSwift

protocol EditorViewContorollerDelegate {
    func recordUpdate()
}

 class EditorVC: UIViewController, UITextViewDelegate, UIImagePickerControllerDelegate & UINavigationControllerDelegate{

     @IBOutlet weak var inputHeightTextField: UITextField!

     @IBOutlet weak var inputWeightTextField: UITextField!

     @IBOutlet weak var inputTemperatureTextField: UITextField!

     @IBOutlet weak var inputMemoTextView: UITextView!
     @IBOutlet weak var inputMemoTextViewHeight: NSLayoutConstraint!

     @IBOutlet weak var inputDateTextField: UITextField!

     @IBOutlet weak var saveButton: UIButton!

     @IBOutlet weak var inputImage: UIImageView!
     
     @IBOutlet weak var deleteButton: UIButton!
     
     @IBOutlet weak var backButton: UIButton!
     
     @IBAction func deleteButton(_ sender: UIButton) {
         deleteRecord()
     }
     
     @IBAction func backButton(_ sender: UIButton) {
         dismiss(animated: true, completion: nil)
     }
     
     @IBAction func saveButton(_ sender: UIButton) {
         saveRecord()
     }
     
     var childCondition: ChildProfile?
     var dayRecord: DailyCondition?
     var record = DailyCondition()
     
     
     var delegate: EditorViewContorollerDelegate?

     var datePicker: UIDatePicker {
         let datePicker: UIDatePicker = UIDatePicker()
         datePicker.datePickerMode = .date
         datePicker.timeZone = .current
         datePicker.preferredDatePickerStyle = .wheels
         datePicker.locale = Locale(identifier: "ja-JP")
         datePicker.date = record.date
         datePicker.addTarget(self, action: #selector(didChangeDate), for: .valueChanged)
         return datePicker
     }

     var dateFormatter: DateFormatter {
         let dateFormatter = DateFormatter()
         dateFormatter.dateStyle = .long
         dateFormatter.timeZone = .current
         dateFormatter.locale = Locale(identifier: "ja-JP")
         return dateFormatter
     }

     var isObseving = false
     


     override func viewDidLoad() {
         super.viewDidLoad()
         configureHeightTextField()
         configureDateTextField()
         inputMemoTextView.delegate = self
         inputImage.isUserInteractionEnabled = true
         inputImage.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(imageViewTapped(_:))))

         
         let sampleImage = UIImage(named: "noimage")
         inputImage.image = sampleImage

         print("👀record: \(record)")
     }

     override func viewWillAppear(_ animated: Bool) {
         super.viewWillAppear(animated)
         if(!isObseving) {
             let notification = NotificationCenter.default
             notification.addObserver(self, selector: #selector(self.keyboardWillShow(_:))
                                                  , name: UIResponder.keyboardWillShowNotification, object: nil)
             notification.addObserver(self, selector: #selector(self.keyboardWillHide(_:))
                                                  , name: UIResponder.keyboardWillHideNotification, object: nil)
             isObseving = true
         }
     }

     override func viewWillDisappear(_ animated: Bool) {
         super.viewWillDisappear(animated)
         if(isObseving) {
             let notification = NotificationCenter.default
             notification.removeObserver(self)
             notification.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
             notification.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
             isObseving = false
         }
     }

     @objc private func keyboardWillShow(_ notification: Notification) {

         // キーボードの分だけViewを上にずらす
         if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
             if self.view.frame.origin.y == 0 {
                         self.view.frame.origin.y -= keyboardSize.height
                     } else {
                         let suggestionHeight = self.view.frame.origin.y + keyboardSize.height
                         self.view.frame.origin.y -= suggestionHeight
                     }
         }
         guard let keyboardHeight = notification.keyboardHeight,
               let keyboardAnimationDuration = notification.keybaordAnimationDuration,
               let KeyboardAnimationCurve = notification.keyboardAnimationCurve
         else { return }

         UIView.animate(withDuration: keyboardAnimationDuration,
                        delay: 0,
                        options: UIView.AnimationOptions(rawValue: KeyboardAnimationCurve)) {
             // ちょっとTextViewを広げる
             self.inputMemoTextViewHeight.constant = 125
         }
     }

     @objc private func keyboardWillHide(_ notification: Notification) {
         // キーボードを閉じたときにViewを元の位置に戻す
         if self.view.frame.origin.y != 0 {
                     self.view.frame.origin.y = 0
                 }

         guard let keyboardAnimationDuration = notification.keybaordAnimationDuration,
               let KeyboardAnimationCurve = notification.keyboardAnimationCurve
         else { return }




         UIView.animate(withDuration: keyboardAnimationDuration,
                        delay: 0,
                        options: UIView.AnimationOptions(rawValue: KeyboardAnimationCurve)) {
             // Text Viewを元のサイズに戻す
             self.inputMemoTextViewHeight.constant = 81
         }
     }

     func textViewDidChange(_ textView: UITextView) {
         let maxHeight = 80.0
         if(inputMemoTextView.frame.size.height.native < maxHeight) {
             let size:CGSize = inputMemoTextView.sizeThatFits(inputMemoTextView.frame.size)
             inputMemoTextViewHeight.constant = size.height
         }
     }

     @objc func didTapDone() {
         view.endEditing(true)
     }

     func configureHeightTextField() {
         let toolBarRect = CGRect(x: 0, y: 0, width: view.frame.size.width, height: 35)
         let toolBar = UIToolbar(frame: toolBarRect)
         let doneItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(didTapDone))
         toolBar.setItems([doneItem], animated: true)
         inputHeightTextField.inputAccessoryView = toolBar
         inputWeightTextField.inputAccessoryView = toolBar
         inputTemperatureTextField.inputAccessoryView = toolBar
         inputMemoTextView.inputAccessoryView = toolBar
         inputDateTextField.inputAccessoryView = toolBar
         inputHeightTextField.text = String(record.height)
         inputWeightTextField.text = String(record.weight)
         inputTemperatureTextField.text = String(record.temperature)
         inputDateTextField.text = dateFormatter.string(from: record.date)
     }

     func configureDateTextField() {
         inputDateTextField.inputView = datePicker
         inputDateTextField.text = dateFormatter.string(from: Date())
     }

     @objc func didChangeDate(picker: UIDatePicker) {
         inputDateTextField.text = dateFormatter.string(from: picker.date)
     }

     // func convertImageToBase64(_ image: UIImage) -> String? {
        // guard let inputImage = image.jpegData(compressionQuality: 1.0) else { return nil }
        // return inputImage.base64EncodedString()
    // }
     
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
         inputImage.image = image
         // 写真を選ぶビューを引っ込める
         self.dismiss(animated: true)
     }



     func saveRecord() {
         let realm = try? Realm()
         try? realm?.write {
                 if let dateText = inputDateTextField.text,
                    let date = dateFormatter.date(from: dateText) {
                     record.date = date
                 }
                 if let heightText = inputHeightTextField.text,
                    let height = Double(heightText) {
                     record.height = height
                 }
                 if let weightText = inputWeightTextField.text,
                    let weight = Double(weightText) {
                     record.weight = weight
                 }
                 if let temperatureText = inputTemperatureTextField.text,
                    let temperature = Double(temperatureText) {
                     record.temperature = temperature
                 }
                 if let memoText = inputMemoTextView.text,
                    let memo = String?(memoText) {
                     record.memo = memo
                 }
                 if let inputImageData = inputImage.image?.pngData(),
                    let dateImage = Data?(inputImageData) {
                     record.dateImage = dateImage
                 }
             mainChildData?.dailyCondition.append(record)
             }
             delegate?.recordUpdate()
             dismiss(animated: true)

         }
     
     func deleteRecord() {
         let realm = try? Realm()
         dayRecord = record
         guard let id = dayRecord?.id,
               let result = realm?.objects(DailyCondition.self).filter("id == %@", id).first else { return }
         let alert = UIAlertController(title: "データを消しますか？", message: "今までの記録が消えてしまいます", preferredStyle: .alert)
         let delete = UIAlertAction(title: "削除", style: .default, handler: { (action) -> Void in
                 print("Delete button tapped")
             try? realm?.write {
            realm?.delete(result)
         }
             self.dismiss(animated: true, completion: nil)
 })
         let cancel = UIAlertAction(title: "キャンセル", style: .cancel, handler: { (action) -> Void in
                       print("Cancel button tapped")
                 self.dismiss(animated: false, completion: nil)
                   })
             alert.addAction(delete)
             alert.addAction(cancel)
             self.present(alert, animated: false, completion: nil)
     }
 }
 extension Notification {

     // キーボードの高さ
     var keyboardHeight: CGFloat? {
         return (self.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue.height
     }

     // キーボードのアニメーション時間
     var keybaordAnimationDuration: TimeInterval? {
         return self.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? TimeInterval
     }

     // キーボードのアニメーション曲線
     var keyboardAnimationCurve: UInt? {
         return self.userInfo?[UIResponder.keyboardAnimationCurveUserInfoKey] as? UInt
     }



 }

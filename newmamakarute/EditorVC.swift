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
     var dateList: [DailyCondition] = []
     var getTextViewHeight: CGFloat = 0.0
     var dateImage: UIImage!
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
         changeDateImage()
         configureHeightTextField()
         configureDateTextField()
         setImage()
         inputMemoTextView.delegate = self
         inputImage.isUserInteractionEnabled = true
         inputImage.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(imageViewTapped(_:))))
         print("👀record: \(record)")
     }

     override func viewWillAppear(_ animated: Bool) {
         super.viewWillAppear(animated)
         
         NotificationCenter.default.addObserver(self,
                                                    selector: #selector(keyboardWillShow),
                                                    name: UIResponder.keyboardWillShowNotification,
                                                    object: nil)
             NotificationCenter.default.addObserver(self,
                                                    selector: #selector(keyboardWillHide),
                                                    name: UIResponder.keyboardWillHideNotification,
                                                    object: nil)
         
     }

     override func viewWillDisappear(_ animated: Bool) {
         super.viewWillDisappear(animated)
         
     }
     
     @objc private func keyboardWillShow(_ notification: Notification) {
         guard let textView = inputMemoTextView else { return }
         let rect = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue
         guard let keyboardHeight = rect?.size.height else { return }
         let mainBoundsSize = UIScreen.main.bounds.size
         let textViewHeight = textView.frame.height

         let textViewPositionY = textView.frame.origin.y + textViewHeight + 50.0
         let keyboardPositionY = mainBoundsSize.height - keyboardHeight
         
         if keyboardPositionY <= textViewPositionY {
             let duration: TimeInterval? =
                 notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double
             UIView.animate(withDuration: duration!) {
                 self.view.transform = CGAffineTransform(translationX: 0, y: keyboardPositionY - textViewPositionY)
             }
         }
     }

     @objc private func keyboardWillHide(_ notification: Notification) {
         let duration: TimeInterval? = notification.userInfo?[UIResponder.keyboardAnimationCurveUserInfoKey] as? Double
         UIView.animate(withDuration: duration!) {
             self.view.transform = CGAffineTransform.identity
         }
     }
     
     // textFieldがタップされた際に呼ばれる
     func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
         inputMemoTextView = textView
         return true
     }
     
     // リターンがタップされた時にキーボードを閉じる
     func textViewShouldReturn(_ textView: UITextView) -> Bool {
         textView.resignFirstResponder()
         return true
     }
     
     // 画面をタップした時にキーボードを閉じる
     override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
         self.view.endEditing(true)
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
         inputMemoTextView.text = String(record.memo)
         inputDateTextField.text = dateFormatter.string(from: record.date)
         inputImage.image = dateImage
     }
     
     func setImage() {
         if dateImage == nil {
             inputImage.image = UIImage(named: "noImage")
         } else {
             print("画像あり")
         }
     }
     
     func changeDateImage() {
         if (record.dateImage) != nil {
             let changeDateImage = UIImage(data: (record.dateImage)!)
             dateImage = changeDateImage
         } else {
             print("画像がありません")
         }
         
     }
     func configureDateTextField() {
         inputDateTextField.inputView = datePicker
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
                    let memo: String = String?(memoText) {
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
     
     func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
             if let pickerImage = info[.originalImage] as? UIImage {
                 // 10%に圧縮した画像
                 let resizedImage          = pickerImage.editorResizeImage(withPercentage: 0.1)!
                 // imageViewに挿入
                 inputImage.image = resizedImage
             }
             dismiss(animated: true, completion: nil)
         }

         func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
             dismiss(animated: true, completion: nil)
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


extension UIImage {
    // percentage:圧縮率
    func editorResizeImage(withPercentage percentage: CGFloat) -> UIImage? {
        // 圧縮後のサイズ情報
        let canvas = CGSize(width: size.width * percentage, height: size.height * percentage)
        // 圧縮画像を返す
        return UIGraphicsImageRenderer(size: canvas, format: imageRendererFormat).image {
            _ in draw(in: CGRect(origin: .zero, size: canvas))
        }
    }
}

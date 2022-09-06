//
//  SignUpVC.swift
//  newmamakarute
//
//  Created by 武久　直幹 on 2022/08/03.
//

import Foundation
import UIKit
 import RealmSwift

 class SignUpVC: UIViewController, UITextFieldDelegate {

     

     @IBOutlet weak var inputIconImageView: UIImageView!


     @IBOutlet weak var inputChildNameTextField: UITextField!

     @IBOutlet weak var signUpButton: UIButton!


     @IBAction func signUpButton(_ sender: UIButton) {
         saveRecord()
     }
     
     let imagePicker = UIImagePickerController()
     
     var record = ChildProfile()
     
     override func viewDidLoad() {
         super.viewDidLoad()
         
         inputChildNameTextField.text = ""
         signUpButton.isEnabled = false

         imagePicker.delegate   = self
         imagePicker.sourceType = .photoLibrary
         inputIconImageView.isUserInteractionEnabled = true
         inputIconImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(imageViewTapped(_:))))

         inputChildNameTextField.delegate = self
         configureChildNameTextField()

     }
     
     func textField(_ textField: UITextField,
                        shouldChangeCharactersIn range: NSRange,
                        replacementString string: String) -> Bool
         {
             DispatchQueue.main.asyncAfter(deadline: .now() + 0.01) {
                 self.signUpButton.isEnabled = !(textField.text?.isEmpty ?? true)
             }
             return true
         }

     
     override func viewWillAppear(_ animated: Bool) {
         super.viewWillAppear(animated)
         
         let notification = NotificationCenter.default
                 notification.addObserver(self, selector: #selector(self.keyboardWillShow(_:)),
                                          name: UIResponder.keyboardWillShowNotification,
                                          object: nil)
                 notification.addObserver(self, selector: #selector(self.keyboardWillHide(_:)),
                                          name: UIResponder.keyboardWillHideNotification,
                                          object: nil)
         
     }
     
     @objc func keyboardWillShow(_ notification: Notification) {
             // 編集中のtextFieldを取得
             guard let textField = inputChildNameTextField else { return }
             // キーボード、画面全体、textFieldのsizeを取得
             let rect = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue
             guard let keyboardHeight = rect?.size.height else { return }
             let mainBoundsSize = UIScreen.main.bounds.size
             let textFieldHeight = textField.frame.height

             let textFieldPositionY = textField.frame.origin.y + textFieldHeight + 70.0
             let keyboardPositionY = mainBoundsSize.height - keyboardHeight
             
             if keyboardPositionY <= textFieldPositionY {
                 let duration: TimeInterval? =
                     notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double
                 UIView.animate(withDuration: duration!) {
                     self.view.transform = CGAffineTransform(translationX: 0, y: keyboardPositionY - textFieldPositionY)
                 }
             }
         }
     
     @objc func keyboardWillHide(_ notification: Notification) {
             let duration: TimeInterval? = notification.userInfo?[UIResponder.keyboardAnimationCurveUserInfoKey] as? Double
             UIView.animate(withDuration: duration!) {
                 self.view.transform = CGAffineTransform.identity
             }
         }

         // textFieldがタップされた際に呼ばれる
         func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
             // 編集中のtextFieldを保持する
             inputChildNameTextField = textField
             return true
         }
         
         // リターンがタップされた時にキーボードを閉じる
         func textFieldShouldReturn(_ textField: UITextField) -> Bool {
             textField.resignFirstResponder()
             return true
         }
         
         // 画面をタップした時にキーボードを閉じる
         override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
             self.view.endEditing(true)
         }
     
     
     @objc func imageViewTapped(_ sender: UITapGestureRecognizer) {
                     self.present(imagePicker, animated: true,completion: nil)
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

extension SignUpVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let pickerImage = info[.originalImage] as? UIImage {
            // 10%に圧縮した画像
            let resizedImage          = pickerImage.resizeImage(withPercentage: 0.1)!
            // imageViewに挿入
            inputIconImageView.image = resizedImage
        }
        dismiss(animated: true, completion: nil)
    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }

}

extension UIImage {
    // percentage:圧縮率
    func resizeImage(withPercentage percentage: CGFloat) -> UIImage? {
        // 圧縮後のサイズ情報
        let canvas = CGSize(width: size.width * percentage, height: size.height * percentage)
        // 圧縮画像を返す
        return UIGraphicsImageRenderer(size: canvas, format: imageRendererFormat).image {
            _ in draw(in: CGRect(origin: .zero, size: canvas))
        }
    }
}

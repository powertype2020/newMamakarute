//
//  SignUpVC.swift
//  newmamakarute
//
//  Created by 武久　直幹 on 2022/08/03.
//

import Foundation
import UIKit
 import RealmSwift

 class SignUpVC: UIViewController {

     

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
         
         imagePicker.delegate   = self
         imagePicker.sourceType = .photoLibrary
         inputIconImageView.isUserInteractionEnabled = true
         inputIconImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(imageViewTapped(_:))))

         configureChildNameTextField()

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

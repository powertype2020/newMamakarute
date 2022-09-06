//
//  ChangeChildDataVC.swift
//  newmamakarute
//
//  Created by 武久　直幹 on 2022/08/16.
//

import Foundation
import UIKit
import RealmSwift


class ChangeChildDataVC: UIViewController, UIAdaptivePresentationControllerDelegate, UITextFieldDelegate {
    
    var changeChildData: ChildProfile?
    
    var changeIcon: UIImage!
    
    var record = ChildProfile()
    
    let imagePicker = UIImagePickerController()
    
    @IBOutlet weak var changeChildName: UITextField!
    
    @IBOutlet weak var changeChildImage: UIImageView!
    
    @IBOutlet weak var changeButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        changeData()
        
        changeButton.isEnabled = false
        configureChildNameTextField()
        changeChildName.text = changeChildData?.name
        changeChildImage.image = changeIcon
        imagePicker.delegate   = self
        imagePicker.sourceType = .photoLibrary
        changeChildImage.isUserInteractionEnabled = true
        changeChildImage.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(imageViewTapped(_:))))
        changeChildName.delegate = self
    }
    
    func textField(_ textField: UITextField,
                       shouldChangeCharactersIn range: NSRange,
                       replacementString string: String) -> Bool
        {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.01) {
                self.changeButton.isEnabled = !(textField.text?.isEmpty ?? true)
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
            guard let textField = changeChildName else { return }
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

        // キーボード非表示通知の際の処理
        @objc func keyboardWillHide(_ notification: Notification) {
            let duration: TimeInterval? = notification.userInfo?[UIResponder.keyboardAnimationCurveUserInfoKey] as? Double
            UIView.animate(withDuration: duration!) {
                self.view.transform = CGAffineTransform.identity
            }
        }
    
    @objc func didTapDone() {
        view.endEditing(true)
    }

    func configureChildNameTextField() {
        let toolBarRect = CGRect(x: 0, y: 0, width: view.frame.size.width, height: 35)
        let toolBar = UIToolbar(frame: toolBarRect)
        let doneItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(didTapDone))
        toolBar.setItems([doneItem], animated: true)
        changeChildName.inputAccessoryView = toolBar
    }
        // textFieldがタップされた際に呼ばれる
        func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
            // 編集中のtextFieldを保持する
            changeChildName = textField
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
    
    func changeData() {
        if (changeChildData?.icon) != nil {
            let dataIcon = UIImage(data: (changeChildData?.icon)!)
            changeIcon = dataIcon
        } else {
            print("画像がありません")
        }
        
    }
    
    
    @IBAction func changeButton(_ sender: UIButton) {
        let alert = UIAlertController(title: "編集しますか？", message: "データを書き換えることになります", preferredStyle: .alert)
        let delete = UIAlertAction(title: "編集", style: .default, handler: { (action) -> Void in
                      
                      self.changeRealmData()
                      print("change button tapped final")
                self.dismiss(animated: true, completion: nil)
                  })
        let cancel = UIAlertAction(title: "キャンセル", style: .cancel, handler: { (action) -> Void in
                      print("Cancel button tapped")
                self.dismiss(animated: false, completion: nil)
                  })
            alert.addAction(delete)
            alert.addAction(cancel)
            self.present(alert, animated: false, completion: nil)
      print("Editがタップされた")
    }
    
    func changeRealmData() {
        let realm = try? Realm()
        try? realm?.write {
            if let nameText = changeChildName.text,
               let childName = String?(nameText) {
                record.name = childName
            }
            if let inputIconData = changeChildImage.image?.pngData(),
               let dateImage = Data?(inputIconData) {
               record.icon = dateImage
            }
            changeChildData?.name = record.name
            changeChildData?.icon = record.icon
        }
    }
    
    @objc func imageViewTapped(_ sender: UITapGestureRecognizer) {
                    self.present(imagePicker, animated: true,completion: nil)
    }
    
}

extension ChangeChildDataVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let pickerImage = info[.originalImage] as? UIImage {
            // 10%に圧縮した画像
            let resizedImage = pickerImage.changeResizeImage(withPercentage: 0.1)!
            // imageViewに挿入
            changeChildImage.image = resizedImage
        }
        dismiss(animated: true, completion: nil)
    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }

}

extension ChangeChildDataVC {
    override func dismiss(animated flag: Bool, completion: (() -> Void)? = nil) {
        super.dismiss(animated: flag, completion: completion)
        guard let presentationController = presentationController else {
            return
        }
        presentationController.delegate?.presentationControllerDidDismiss?(presentationController)
    }
}

extension UIImage {
    // percentage:圧縮率
    func changeResizeImage(withPercentage percentage: CGFloat) -> UIImage? {
        // 圧縮後のサイズ情報
        let canvas = CGSize(width: size.width * percentage, height: size.height * percentage)
        // 圧縮画像を返す
        return UIGraphicsImageRenderer(size: canvas, format: imageRendererFormat).image {
            _ in draw(in: CGRect(origin: .zero, size: canvas))
        }
    }
}

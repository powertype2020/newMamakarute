//
//  ChangeChildDataVC.swift
//  newmamakarute
//
//  Created by 武久　直幹 on 2022/08/16.
//

import Foundation
import UIKit
import RealmSwift


class ChangeChildDataVC: UIViewController, UIAdaptivePresentationControllerDelegate {
    
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
        
        print(changeChildData)
        
        changeChildName.text = changeChildData?.name
        changeChildImage.image = changeIcon
        imagePicker.delegate   = self
        imagePicker.sourceType = .photoLibrary
        changeChildImage.isUserInteractionEnabled = true
        changeChildImage.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(imageViewTapped(_:))))
        
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
    
}

extension ChangeChildDataVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let pickerImage = info[.originalImage] as? UIImage {
            // 10%に圧縮した画像
            let resizedImage = pickerImage.resizeImage(withPercentage: 0.1)!
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

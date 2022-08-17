//
//  ChangeChildDataVC.swift
//  newmamakarute
//
//  Created by 武久　直幹 on 2022/08/16.
//

import Foundation
import UIKit

class ChangeChildDataVC: UIViewController {
    
    var changeChildData: ChildProfile?
    
    var changeIcon: UIImage!
    
    @IBOutlet weak var changeChildName: UITextField!
    
    @IBOutlet weak var changeChildImage: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        changeData()
        
        print(changeChildData)
        
        changeChildName.text = changeChildData?.name
        changeChildImage.image = changeIcon
        
    }
    
    func changeData() {
        if (changeChildData?.icon) != nil {
            let dataIcon = UIImage(data: (changeChildData?.icon)!)
            changeIcon = dataIcon
        } else {
            print("画像がありません")
        }
        
    }
    
}

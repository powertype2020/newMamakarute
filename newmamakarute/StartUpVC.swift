//
//  StartUpVC.swift
//  newmamakarute
//
//  Created by 武久　直幹 on 2022/08/24.
//

import Foundation
import UIKit

class StartUpVC: UIViewController {
    
    
    @IBOutlet weak var startImage: UIImageView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        self.perform(#selector(startApp), with: nil, afterDelay: 3.0)
    }
    
    @objc func startApp() {
        performSegue(withIdentifier: "start", sender: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.perform(#selector(startApp), with: nil, afterDelay: 3.0)
        
    }
    
    
}

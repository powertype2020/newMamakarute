//
//  Next3HelpVC.swift
//  newmamakarute
//
//  Created by 武久　直幹 on 2022/08/27.
//

import Foundation
import UIKit

class Next3HelpVC: UIViewController {
    
    @IBOutlet weak var help3View: UIView!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    // メニュー外をタップした場合に非表示にする
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        for touch in touches {
            if touch.view?.tag == 1 {
                UIView.animate( withDuration: 0.2, delay: 0, options: .curveEaseIn, animations: {
                    self.help3View.layer.position.x = -self.help3View.frame.width
                }, completion: { bool in self.dismiss(animated: false, completion: nil)

                }
                )
            }
        }
    }
    
    
}

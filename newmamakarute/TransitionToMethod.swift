//
//  TransitionToMethod.swift
//  newmamakarute
//
//  Created by 武久　直幹 on 2022/08/05.
//

import Foundation
import UIKit
class TransitionTM: UIViewController {
    
    func transitionToSignUpView() {
    let storyboard = UIStoryboard(name: "SignUpVC", bundle: nil)
    guard let signUpViewController = storyboard.instantiateInitialViewController() as? SignUpVC else { return }
    present(signUpViewController, animated: true)
    }
    
    func transitionToEditorView(with record: DailyCondition? = nil) {
        let storyboard = UIStoryboard(name: "EditorVC", bundle: nil)
        guard let editorViewcontroller = storyboard.instantiateInitialViewController() as? EditorVC else { return }
        if let record = record {
            editorViewcontroller.record = record
        }
        editorViewcontroller.delegate
        present(editorViewcontroller, animated: true)
    }

    
    
}

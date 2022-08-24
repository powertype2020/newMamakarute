//
//  MainTabBarVC.swift
//  newmamakarute
//
//  Created by 武久　直幹 on 2022/08/03.
//

import Foundation
import UIKit


 class MainTabBarVC: UITabBarController, UITabBarControllerDelegate {
     
    
     
     override func viewDidLoad() {
         super.viewDidLoad()
         self.delegate = self
     }
     
     override func didReceiveMemoryWarning() {
             super.didReceiveMemoryWarning()
         }
     
     override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
             switch item.tag {
             case 1:
               print("タップされました")
             default:
               print("bar")
             }
         }
     
     
     func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
             if viewController is TabBarDelegate {
                 let v = viewController as! TabBarDelegate
                 v.didSelectTab(tabBarController: self)
             }
         }
     
 }

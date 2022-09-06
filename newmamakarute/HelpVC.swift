//
//  HelpVC.swift
//  newmamakarute
//
//  Created by 武久　直幹 on 2022/08/27.
//

import Foundation
import UIKit

class HelpVC: UIViewController {
    
    
    @IBOutlet weak var helpTable: UITableView!
    
    var helpList = ["はじめに","子供の登録","子供の選択・編集","身長や体重、体調の記録","アプリのコンセプト"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        helpTable.dataSource = self
        helpTable.delegate = self
        
    }
    
    
    
    @IBAction func backButton(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    
    
}

extension HelpVC: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        helpList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        let helps = helpList[indexPath.row]
        cell.textLabel?.text = helps
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let helpNumber = helpList[indexPath.row]
        print(helpNumber)
        switch helpNumber {
        case "はじめに":
            performSegue(withIdentifier: "next", sender: nil)
        case "子供の登録":
            performSegue(withIdentifier: "next2", sender: nil)
        case "子供の選択・編集":
            performSegue(withIdentifier: "next3", sender: nil)
        case "身長や体重、体調の記録":
            performSegue(withIdentifier: "next4", sender: nil)
        case "アプリのコンセプト":
            performSegue(withIdentifier: "next5", sender: nil)
        default:
            dismiss(animated: true, completion: nil)
        }
        helpTable.deselectRow(at: indexPath, animated: true)
    }
}

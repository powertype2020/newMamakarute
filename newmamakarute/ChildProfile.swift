//
//  ChildProfile.swift
//  newmamakarute
//
//  Created by 武久　直幹 on 2022/08/03.
//

import Foundation
import RealmSwift

class ChildProfile: Object {
    override static func primaryKey() -> String? {
        return "id"
    }
    @objc dynamic var id: String = NSUUID().uuidString
    @objc dynamic var name = ""
    @objc dynamic var icon: Data?
    let dailyCondition = List<DailyCondition>()
}


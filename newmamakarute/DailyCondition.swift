//
//  DailyCondition.swift
//  newmamakarute
//
//  Created by 武久　直幹 on 2022/08/03.
//

import Foundation
import RealmSwift

 class DailyCondition: Object {
     override static func primaryKey() -> String? {
         return "id"
     }

     @objc dynamic var id = "00"
     @objc dynamic var date: Date = Date()
     @objc dynamic var height: Double = 0
     @objc dynamic var weight: Double = 0
     @objc dynamic var temperature: Double = 0
     @objc dynamic var memo: String?
     @objc dynamic var dateImage: Data?
 }

class DailyCondition2: Object {
    override static func primaryKey() -> String? {
        return "id"
    }

    @objc dynamic var id = "01"
    @objc dynamic var date: Date = Date()
    @objc dynamic var height: Double = 0
    @objc dynamic var weight: Double = 0
    @objc dynamic var temperature: Double = 0
    @objc dynamic var memo: String?
    @objc dynamic var dateImage: Data?
}

class DailyCondition3: Object {
    override static func primaryKey() -> String? {
        return "id"
    }

    @objc dynamic var id = "02"
    @objc dynamic var date: Date = Date()
    @objc dynamic var height: Double = 0
    @objc dynamic var weight: Double = 0
    @objc dynamic var temperature: Double = 0
    @objc dynamic var memo: String?
    @objc dynamic var dateImage: Data?
}

class DailyCondition4: Object {
    override static func primaryKey() -> String? {
        return "id"
    }

    @objc dynamic var id = "03"
    @objc dynamic var date: Date = Date()
    @objc dynamic var height: Double = 0
    @objc dynamic var weight: Double = 0
    @objc dynamic var temperature: Double = 0
    @objc dynamic var memo: String?
    @objc dynamic var dateImage: Data?
}

class DailyCondition5: Object {
    override static func primaryKey() -> String? {
        return "id"
    }

    @objc dynamic var id = "04"
    @objc dynamic var date: Date = Date()
    @objc dynamic var height: Double = 0
    @objc dynamic var weight: Double = 0
    @objc dynamic var temperature: Double = 0
    @objc dynamic var memo: String?
    @objc dynamic var dateImage: Data?
}

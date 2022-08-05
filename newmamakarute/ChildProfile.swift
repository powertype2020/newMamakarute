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
     @objc dynamic var id = "0"
     @objc dynamic var name = ""
     @objc dynamic var icon: Data?
     @objc dynamic var date: Date = Date()
     @objc dynamic var height: Double = 0
     @objc dynamic var weight: Double = 0
     @objc dynamic var temperature: Double = 0
     @objc dynamic var memo: String?
     @objc dynamic var dateImage: Data?
 }
class ChildProfile2: Object {
    override static func primaryKey() -> String? {
        return "id"
    }
    @objc dynamic var id = "1"
    @objc dynamic var name = ""
    @objc dynamic var icon: Data?
    @objc dynamic var date: Date = Date()
    @objc dynamic var height: Double = 0
    @objc dynamic var weight: Double = 0
    @objc dynamic var temperature: Double = 0
    @objc dynamic var memo: String?
    @objc dynamic var dateImage: Data?
}
class ChildProfile3: Object {
    override static func primaryKey() -> String? {
        return "id"
    }
    @objc dynamic var id = "2"
    @objc dynamic var name = ""
    @objc dynamic var icon: Data?
    @objc dynamic var date: Date = Date()
    @objc dynamic var height: Double = 0
    @objc dynamic var weight: Double = 0
    @objc dynamic var temperature: Double = 0
    @objc dynamic var memo: String?
    @objc dynamic var dateImage: Data?
}
class ChildProfile4: Object {
    override static func primaryKey() -> String? {
        return "id"
    }
    @objc dynamic var id = "3"
    @objc dynamic var name = ""
    @objc dynamic var icon: Data?
    @objc dynamic var date: Date = Date()
    @objc dynamic var height: Double = 0
    @objc dynamic var weight: Double = 0
    @objc dynamic var temperature: Double = 0
    @objc dynamic var memo: String?
    @objc dynamic var dateImage: Data?
}
class ChildProfile5: Object {
    override static func primaryKey() -> String? {
        return "id"
    }
    @objc dynamic var id = "4"
    @objc dynamic var name = ""
    @objc dynamic var icon: Data?
    @objc dynamic var date: Date = Date()
    @objc dynamic var height: Double = 0
    @objc dynamic var weight: Double = 0
    @objc dynamic var temperature: Double = 0
    @objc dynamic var memo: String?
    @objc dynamic var dateImage: Data?
}

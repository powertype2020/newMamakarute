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
 }
class ChildProfile2: Object {
    override static func primaryKey() -> String? {
        return "id"
    }
    @objc dynamic var id = "1"
    @objc dynamic var name = ""
    @objc dynamic var icon: Data?
    @objc dynamic var date: Date = Date()
}
class ChildProfile3: Object {
    override static func primaryKey() -> String? {
        return "id"
    }
    @objc dynamic var id = "2"
    @objc dynamic var name = ""
    @objc dynamic var icon: Data?
    @objc dynamic var date: Date = Date()
}
class ChildProfile4: Object {
    override static func primaryKey() -> String? {
        return "id"
    }
    @objc dynamic var id = "3"
    @objc dynamic var name = ""
    @objc dynamic var icon: Data?
    @objc dynamic var date: Date = Date()
}
class ChildProfile5: Object {
    override static func primaryKey() -> String? {
        return "id"
    }
    @objc dynamic var id = "4"
    @objc dynamic var name = ""
    @objc dynamic var icon: Data?
    @objc dynamic var date: Date = Date()
}

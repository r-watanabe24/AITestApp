//
//  UserProfile.swift
//  AITestApp
//
//  Created by L_0045_r.watanabe on 2025/03/25.
//


import Foundation
import RealmSwift

class UserProfile: Object {
    class var refreshObject: UserProfile? {
        let realm = try! Realm()
        realm.refresh()
        return realm.object(ofType: UserProfile.self, forPrimaryKey: "user")
    }

    override static func primaryKey() -> String? {
        return "id"
    }

    @objc dynamic var id: String = "user"
    @objc dynamic var userName: String = ""
    @objc dynamic var birthday: String = ""
    @objc dynamic var profileImageUrl: String? = nil
    @objc dynamic var isDarkMode: Bool = false


    func save(with values: [String: Any?]) {
        let realm = try! Realm()
        try! realm.write {
            for (key, value) in values {
                if self.responds(to: Selector(key)) {
                    self.setValue(value, forKey: key)
                }
            }
        }
    }

    func reset() {
        let realm = try! Realm()
        try! realm.write {
            self.userName = ""
            self.birthday = ""
            self.profileImageUrl = nil
            self.isDarkMode = false
        }
    }

    // 削除
    func delete() {
        let realm = try! Realm()
        try! realm.write {
            realm.delete(self)
        }
    }
}

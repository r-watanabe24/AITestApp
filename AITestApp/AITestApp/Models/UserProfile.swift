//
//  UserProfile.swift
//  AITestApp
//
//  Created by L_0045_r.watanabe on 2025/03/25.
//


import Foundation
import RealmSwift

class UserProfile: Object {
    private static let sharedRealm = try! Realm()

    class var shared: UserProfile {
        if let existing = sharedRealm.object(ofType: UserProfile.self, forPrimaryKey: "user") {
            return existing
        } else {
            let profile = UserProfile()
            try! sharedRealm.write {
                sharedRealm.add(profile)
            }
            return profile
        }
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
        guard let realm = self.realm else { return }
        try? realm.write {
            for (key, value) in values {
                if self.responds(to: Selector(key)) {
                    self.setValue(value, forKey: key)
                }
            }
        }
    }

    func reset() {
        guard let realm = self.realm else { return }
        try? realm.write {
            self.userName = ""
            self.birthday = ""
            self.profileImageUrl = nil
            self.isDarkMode = false
        }
    }

    func delete() {
        guard let realm = self.realm else { return }
        try? realm.write {
            realm.delete(self)
        }
    }
}

//
//  ItemData.swift
//  SimplePharaseCollection
//
//  Created by 井本智博 on 2024/03/19.
//

import Foundation
import RealmSwift

class ItemData: Object {
    @objc dynamic var primaryKeyId = UUID().uuidString
    @objc dynamic var sentence: String = ""
    @objc dynamic var memo: String = ""
    @objc dynamic var tag: String = ""
    @objc dynamic var isChecked = false

    override static func primaryKey() -> String? {
        return "primaryKeyId"
    }
}

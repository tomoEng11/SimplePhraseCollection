//
//  ItemData.swift
//  SimplePharaseCollection
//
//  Created by 井本智博 on 2024/03/19.
//

import Foundation
import RealmSwift

final class ItemData: Object {
    @objc dynamic var id: String
    @objc dynamic var sentence: String = ""
    @objc dynamic var memo: String = ""
    @objc dynamic var tag: String = ""
    @objc dynamic var isChecked = false

    override init() {
        self.id = UUID().uuidString
    }
}

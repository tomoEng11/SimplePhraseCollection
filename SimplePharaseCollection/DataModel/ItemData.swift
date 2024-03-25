//
//  ItemData.swift
//  SimplePharaseCollection
//
//  Created by 井本智博 on 2024/03/19.
//

import Foundation
import RealmSwift

final class ItemData: Object {
    @Persisted var id: String
    @Persisted var sentence: String = ""
    @Persisted var memo: String = ""
    @Persisted var tag: String = ""
    @Persisted var isChecked = false

    override init() {
        self.id = UUID().uuidString
    }
}

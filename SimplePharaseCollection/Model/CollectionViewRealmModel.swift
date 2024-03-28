//
//  CollectionViewRealmModel.swift
//  SimplePharaseCollection
//
//  Created by 井本智博 on 2024/03/24.
//

import Foundation
import RealmSwift

struct CollectionViewRealmModel {

    private let realm = try! Realm()

    func itemCount() -> Int {
        return realm.objects(ItemData.self).count
    }

    //Read
    func readItems() -> Results<ItemData> {
        return realm.objects(ItemData.self)
    }

    func readFilteredItems(filter: String) -> Results<ItemData> {
        let filteredItems = realm.objects(ItemData.self).filter("sentence contains '\(filter.lowercased())' OR sentence contains '\(filter.uppercased())'")
        return filteredItems
    }

    //Update
    func reverseCheckmark(for selectedItem: ItemData) throws {
        guard let currentItem = realm.objects(ItemData.self).filter("id == %@", selectedItem.id).first else { return }

        try realm.write {
            currentItem.isChecked.toggle()
            realm.add(currentItem)
        }
    }

    func removeAllCheckmark() throws {
        let items = realm.objects(ItemData.self)
        try realm.write {
            for item in items {
                if let currentItem = realm.objects(ItemData.self).filter("id == %@", item.id).first {
                    currentItem.isChecked = false
                }
            }
        }
    }

    //Delete
    func deleteItems() throws {
        let items = realm.objects(ItemData.self).filter("isChecked == true")
        try realm.write {
            for item in items {
                realm.delete(item)
            }
        }
    }
}

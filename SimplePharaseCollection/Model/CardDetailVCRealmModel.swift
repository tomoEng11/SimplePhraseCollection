//
//  CardDetailVCRealmModel.swift
//  SimplePharaseCollection
//
//  Created by 井本智博 on 2024/03/24.
//

import Foundation
import RealmSwift

struct CardDetailVCRealmModel {

    private let realm = try! Realm()

    //Update
    func saveItem(previousItem: ItemData, sentence: String, memo: String, tag: String) throws {
        if let newItem = realm.objects(ItemData.self).filter("id == %@", previousItem.id).first {
            try realm.write {
                newItem.sentence = sentence
                newItem.memo = memo
                newItem.tag = tag
                realm.add(newItem)
            }
        }
    }

    //Delete
    func deleteItem(previousItem: ItemData) throws {

        if let currentItem = realm.objects(ItemData.self).filter("id == %@", previousItem.id).first {
            try realm.write {
                realm.delete(currentItem)
            }
        }
    }
}

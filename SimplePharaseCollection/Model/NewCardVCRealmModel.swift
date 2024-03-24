//
//  NewCardVCRealmModel.swift
//  SimplePharaseCollection
//
//  Created by 井本智博 on 2024/03/24.
//

import Foundation
import RealmSwift

struct NewCardVCRealmModel {

    private let realm = try! Realm()
    
    //Create
    func createData(sentence: String, memo: String, tag: String) throws {
        let newItem = ItemData()
        newItem.sentence = sentence
        newItem.memo = memo
        newItem.tag = tag

        try realm.write {
            realm.add(newItem)
        }
    }
}

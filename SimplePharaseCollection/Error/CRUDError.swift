//
//  CRUDError.swift
//  SimplePharaseCollection
//
//  Created by 井本智博 on 2024/03/24.
//

import Foundation

enum CRUDError: Error {
    case create
    case read
    case update
    case delete
    case unknown

    var description: String {
        switch self {
        case .create: return "新しいカードが作成できませんでした。"
        case .read: return "データの読み込みができませんでした。"
        case .update: return "データの更新ができませんでした。"
        case .delete: return "データの削除ができませんでした。"
        case .unknown: return "予期せぬエラーが発生しました。"
        }
    }
}

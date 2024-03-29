//
//  UIVIew.swift
//  SimplePharaseCollection
//
//  Created by 井本智博 on 2024/03/29.
//

import UIKit

extension UIView {
    func set(constraints: [NSLayoutConstraint]) {
          self.translatesAutoresizingMaskIntoConstraints = false
          NSLayoutConstraint.activate(constraints)
    }
}

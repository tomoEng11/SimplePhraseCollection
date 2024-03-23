//
//  CustomLabelTextView.swift
//  SimplePharaseCollection
//
//  Created by 井本智博 on 2024/03/20.
//

import UIKit

final class CustomLabelTextView: UITextView {

    init(fontSize: CGFloat, backgroundColor: UIColor) {
        super.init(frame: .zero, textContainer: nil)
        self.backgroundColor = backgroundColor
        self.font = UIFont.systemFont(ofSize: fontSize, weight: .bold)
        configure()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func configure() {
        layer.masksToBounds = true
        layer.cornerRadius = 10
        textColor = .white
        textAlignment = .center
        translatesAutoresizingMaskIntoConstraints = false
        isScrollEnabled = false
        adjustsFontForContentSizeCategory = true
        textContainerInset = UIEdgeInsets(top: 5, left: 0, bottom: 0, right: 0)
    }
}

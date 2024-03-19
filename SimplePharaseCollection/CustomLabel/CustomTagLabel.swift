//
//  CustomTagLabel.swift
//  SimplePharaseCollection
//
//  Created by 井本智博 on 2024/03/19.
//

import UIKit

final class CustomTagLabel: UILabel {

    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    init(backgroundColor: UIColor, fontSize: CGFloat) {
        super.init(frame: .zero)
        self.backgroundColor = backgroundColor
        self.font = UIFont.systemFont(ofSize: fontSize, weight: .bold)
        configure()
    }

    private func configure() {
        layer.masksToBounds = true
        layer.cornerRadius = 10
        textColor = .white
        textAlignment = .center
        numberOfLines = 1
        translatesAutoresizingMaskIntoConstraints = false
    }
}

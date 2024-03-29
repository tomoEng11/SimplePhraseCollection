//
//  PlaceholderTextView.swift
//  SimplePharaseCollection
//
//  Created by 井本智博 on 2024/03/28.
//


import UIKit

class PlaceholderTextView: UITextView {

    var placeholderLabel = UILabel()

    @IBInspectable var placeholder: String? {
        didSet {
            placeholderLabel.text = placeholder
            placeholderLabel.sizeToFit()
        }
    }

    override var text: String! {
        didSet {
            textChanged()
        }
    }

    convenience init(placeholder: String) {
        self.init()
        self.placeholder = placeholder
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        addSubview(placeholderLabel)
        placeholderLabel.textColor = .secondaryLabel
        placeholderLabel.font = font
        placeholderLabel.numberOfLines = 0
        placeholderLabel.text = placeholder
        let horizontalPadding = textContainer.lineFragmentPadding
        placeholderLabel.set(constraints: [
            placeholderLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: textContainerInset.left + horizontalPadding),
            placeholderLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -(textContainerInset.right + horizontalPadding)),
            placeholderLabel.topAnchor.constraint(equalTo: topAnchor, constant: textContainerInset.top),
            placeholderLabel.bottomAnchor.constraint(lessThanOrEqualTo: bottomAnchor, constant: -textContainerInset.bottom),
            placeholderLabel.widthAnchor.constraint(equalTo: widthAnchor)
        ])

        NotificationCenter.default.addObserver(self, selector: #selector(textChanged), name: UITextView.textDidChangeNotification, object: nil)
    }

    @objc func textChanged() {
        placeholderLabel.alpha = text.isEmpty ? 1.0 : 0.0
    }
}


//
//  CardCollectionViewCell.swift
//  SimplePharaseCollection
//
//  Created by 井本智博 on 2024/03/19.
//

import UIKit

class CardCollectionViewCell: UICollectionViewCell {

    private let sentenceLabel = UILabel()
    private let tagLabel = CustomTagLabel(backgroundColor: .systemOrange, fontSize: 12)
    static let reuseID = "CardCollectionViewCell"
    let checkmarkImageView = UIImageView()

    override init(frame: CGRect) {
        super.init(frame: frame)
        configureTagLabel()
        configureSentenceLabel()
        configureCheckmarkImageView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func set(with item: DataModel) {
        self.sentenceLabel.text = item.sentence
        self.backgroundColor = .systemBackground
        self.layer.masksToBounds = true
        self.layer.borderWidth = 2
        self.layer.borderColor = UIColor.lightGray.cgColor
        self.layer.cornerRadius = 10
        self.checkmarkImageView.isHidden = !item.isChecked
    }

    private func configureTagLabel() {
        contentView.addSubview(tagLabel)

        tagLabel.text = "Follwers32-32"

        NSLayoutConstraint.activate([
            tagLabel.topAnchor.constraint(equalTo: topAnchor, constant: 8),
            tagLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8),
            tagLabel.heightAnchor.constraint(equalToConstant: 30),
            tagLabel.widthAnchor.constraint(equalToConstant: 100)
        ])
    }

    private func configureSentenceLabel() {
        contentView.addSubview(sentenceLabel)

        sentenceLabel.clipsToBounds = true
        sentenceLabel.layer.cornerRadius = 10
        sentenceLabel.numberOfLines = 10
        sentenceLabel.textAlignment = .left
        sentenceLabel.font = .systemFont(ofSize: 12, weight: .regular)
        sentenceLabel.backgroundColor = .secondarySystemBackground
        sentenceLabel.translatesAutoresizingMaskIntoConstraints = false
        sentenceLabel.lineBreakMode = .byTruncatingTail

        NSLayoutConstraint.activate([
            sentenceLabel.topAnchor.constraint(equalTo: tagLabel.bottomAnchor, constant: 8),
            sentenceLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -12),
            sentenceLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 12),
            sentenceLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -12),
        ])
    }

    private func configureCheckmarkImageView() {
        checkmarkImageView.translatesAutoresizingMaskIntoConstraints = false
        checkmarkImageView.image = UIImage(systemName: "checkmark") // チェックマークの画像
        checkmarkImageView.isHidden = true

        contentView.addSubview(checkmarkImageView)
        NSLayoutConstraint.activate([
            checkmarkImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            checkmarkImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10)
        ])
    }

    func reverseIsSelected(item: DataModel) {
        checkmarkImageView.isHidden = !item.isChecked
    }
}



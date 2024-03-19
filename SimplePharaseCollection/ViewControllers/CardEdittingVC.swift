//
//  CardEdittingVC.swift
//  SimplePharaseCollection
//
//  Created by 井本智博 on 2024/03/19.
//

import UIKit
import RealmSwift

class CardEdittingVC: UIViewController {

    private let tagLabel = CustomTagLabel(backgroundColor: .systemOrange, fontSize: 12)
    private let sentenceTextView = UITextView()
    private let memoTextView = UITextView()
    private let stackView = UIStackView()
    private let cardView = UIView()
    private let doneButton = UIButton()
    let realm = try! Realm()

    override func viewDidLoad() {
        super.viewDidLoad()
        configureViewController()
        configureTapGesture()
        configureTagLabel()
        configureSentenceTextView()
        configureMemoTextView()
        configureStackView()
        configureCardView()
        configureButton()
    }

    private func configureCardView() {
        view.addSubview(cardView)
        cardView.backgroundColor = .systemBackground
        cardView.layer.cornerRadius = 24
        cardView.layer.borderWidth = 4
        cardView.layer.borderColor = UIColor.systemGray.cgColor

        cardView.layer.masksToBounds = true
        cardView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            cardView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor,  constant: 16),
            cardView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            cardView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
            cardView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16)
        ])
    }

    private func configureStackView() {
        cardView.addSubview(stackView)
        stackView.axis = .vertical
        stackView.spacing = 8
        stackView.alignment = .center
        stackView.distribution = .equalSpacing
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.layer.masksToBounds = true
        stackView.layer.cornerRadius = 20

        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: tagLabel.bottomAnchor, constant: 24),
            stackView.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 24),
            stackView.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -24),
            stackView.bottomAnchor.constraint(equalTo: cardView.bottomAnchor, constant: -24)
        ])
    }

    private func configureTagLabel() {
        cardView.addSubview(tagLabel)
        tagLabel.text = "Followers21-21"

        NSLayoutConstraint.activate([
            tagLabel.topAnchor.constraint(equalTo: cardView.topAnchor, constant: 32),
            tagLabel.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 24),
            tagLabel.heightAnchor.constraint(equalToConstant: 24),
            tagLabel.widthAnchor.constraint(equalToConstant: 100)
        ])
    }

    private func configureSentenceTextView() {
        stackView.addArrangedSubview(sentenceTextView)
        sentenceTextView.delegate = self
        sentenceTextView.font = UIFont.systemFont(ofSize: 20)
        sentenceTextView.textColor = .white
        sentenceTextView.layer.cornerRadius = 10
        sentenceTextView.textAlignment = .left
        sentenceTextView.translatesAutoresizingMaskIntoConstraints = false
        sentenceTextView.backgroundColor = .secondarySystemBackground

        NSLayoutConstraint.activate([
            sentenceTextView.leadingAnchor.constraint(equalTo: stackView.leadingAnchor),
            sentenceTextView.trailingAnchor.constraint(equalTo: stackView.trailingAnchor),
            sentenceTextView.heightAnchor.constraint(equalToConstant: 210)
        ])
    }

    func configureMemoTextView() {
        stackView.addArrangedSubview(memoTextView)
        memoTextView.delegate = self
        memoTextView.font = UIFont.systemFont(ofSize: 20)
        memoTextView.textColor = .white
        memoTextView.layer.cornerRadius = 10
        memoTextView.textAlignment = .left
        memoTextView.translatesAutoresizingMaskIntoConstraints = false
        memoTextView.backgroundColor = .secondarySystemBackground

        NSLayoutConstraint.activate([
            memoTextView.topAnchor.constraint(equalTo: sentenceTextView.bottomAnchor, constant: 24),
            memoTextView.leadingAnchor.constraint(equalTo: stackView.leadingAnchor),
            memoTextView.trailingAnchor.constraint(equalTo: stackView.trailingAnchor),
            memoTextView.heightAnchor.constraint(equalTo: sentenceTextView.heightAnchor)
        ])
    }

    func configureButton() {
        cardView.addSubview(doneButton)
        doneButton.backgroundColor = .secondarySystemBackground
        doneButton.layer.borderColor = UIColor.tintColor.cgColor
        doneButton.layer.borderWidth = 2
        doneButton.setImage(UIImage(systemName: "pencil"), for: .normal)
        doneButton.layer.masksToBounds = true
        doneButton.layer.cornerRadius = 24
        doneButton.translatesAutoresizingMaskIntoConstraints = false
        doneButton.addTarget(self, action: #selector(doneButtonPressed), for: .touchUpInside)

        NSLayoutConstraint.activate([
            doneButton.heightAnchor.constraint(equalToConstant: 50),
            doneButton.widthAnchor.constraint(equalToConstant: 50),
            doneButton.centerYAnchor.constraint(equalTo: tagLabel.centerYAnchor),
            doneButton.trailingAnchor.constraint(equalTo: stackView.trailingAnchor)
        ])
    }


    func configureViewController() {
        view.backgroundColor = .systemBackground
        self.title = "Register"

        let addButton = UIBarButtonItem(title: "Add", style: .plain, target: self, action: #selector(addButtonPressed))
        navigationItem.rightBarButtonItem = addButton
    }

    @objc private func addButtonPressed() {
        print("Add Button Pressed")

        guard sentenceTextView.text != nil && sentenceTextView.text != "" else {
            presentAlertOnMainThread(title: "何か入力してください", message: "", buttonTitle: "OK")
            return
        }

        let item = DataModel()
        item.sentence = sentenceTextView.text
        item.memo = memoTextView.text

        try! realm.write {
            realm.add(item)
        }
        presentAlertOnMainThread(title: "カードが追加されました", message: "", buttonTitle: "OK")

        sentenceTextView.text = ""
        memoTextView.text = ""
    }

    func configureTapGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard(with:)))
        view.addGestureRecognizer(tapGesture)
    }

    @objc private func dismissKeyboard(with gesture: UITapGestureRecognizer) {
        print("Other Areas Tapped!")
        sentenceTextView.resignFirstResponder()
        memoTextView.resignFirstResponder()
    }

    @objc private func doneButtonPressed(with gesture: UITapGestureRecognizer) {
        print("Done Button Pressed")

        guard sentenceTextView.text != nil && sentenceTextView.text != "" else {
            presentAlertOnMainThread(title: "何か入力してください", message: "", buttonTitle: "OK")
            return
        }

        let item = DataModel()
        item.sentence = sentenceTextView.text
        item.memo = memoTextView.text

        try! realm.write {
            realm.add(item)
        }
        presentAlertOnMainThread(title: "カードが追加されました", message: "", buttonTitle: "OK")

        sentenceTextView.text = ""
        memoTextView.text = ""
    }
}

extension CardEdittingVC: UITextViewDelegate {

    func textViewDidChange(_ textView: UITextView) {
    }
}

#Preview {
    let vc = CardEdittingVC()
    return vc
}

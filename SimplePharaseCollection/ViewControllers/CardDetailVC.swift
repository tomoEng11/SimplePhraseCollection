//
//  CardDetailVC.swift
//  SimplePharaseCollection
//
//  Created by 井本智博 on 2024/03/19.
//

import UIKit
import RealmSwift

final class CardDetailVC: UIViewController {

    private let tagLabel = CustomLabelTextView(fontSize: 12, backgroundColor: .systemOrange)
    let sentenceTextView = UITextView()
    let memoTextView = UITextView()
    private let stackView = UIStackView()
    private let cardView = UIView()
    let realm = try! Realm()
    var previousItem: DataModel?

    override func viewDidLoad() {
        super.viewDidLoad()
        configureTagLabel()
        configureSentenceTextView()
        configureMemoTextView()
        configureStackView()
        configureCardView()
        configureViewController()
        addToolBarToKeyboard()
    }

    private func configureCardView() {
        view.addSubview(cardView)
        cardView.backgroundColor = .systemBackground
        cardView.layer.borderColor = UIColor.lightGray.cgColor
        cardView.layer.borderWidth = 2
        cardView.layer.masksToBounds = true
        cardView.layer.cornerRadius = 24
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
            stackView.topAnchor.constraint(equalTo: tagLabel.bottomAnchor, constant: 34),
            stackView.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 24),
            stackView.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -24),
            stackView.bottomAnchor.constraint(equalTo: cardView.bottomAnchor, constant: -34)
        ])
    }

    private func configureTagLabel() {
        cardView.addSubview(tagLabel)
        tagLabel.text = "Phrase"
        tagLabel.isEditable = false

        NSLayoutConstraint.activate([
            tagLabel.topAnchor.constraint(equalTo: cardView.topAnchor, constant: 32),
            tagLabel.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 24),
            tagLabel.heightAnchor.constraint(equalToConstant: 24),
            tagLabel.widthAnchor.constraint(equalToConstant: 100)
        ])
    }

    private func configureSentenceTextView() {
        stackView.addArrangedSubview(sentenceTextView)
        sentenceTextView.isEditable = false
        sentenceTextView.font = UIFont.systemFont(ofSize: 20)
        sentenceTextView.layer.cornerRadius = 10
        sentenceTextView.textAlignment = .left
        sentenceTextView.translatesAutoresizingMaskIntoConstraints = false
        sentenceTextView.backgroundColor = .secondarySystemBackground
        sentenceTextView.delegate = self

        NSLayoutConstraint.activate([
            sentenceTextView.leadingAnchor.constraint(equalTo: stackView.leadingAnchor),
            sentenceTextView.trailingAnchor.constraint(equalTo: stackView.trailingAnchor),
            sentenceTextView.heightAnchor.constraint(equalToConstant: 210)
        ])
    }

    private func configureMemoTextView() {
        stackView.addArrangedSubview(memoTextView)
        print("Before memoTextView.isEditable: \(memoTextView.isEditable)")
        memoTextView.isEditable = false
        print("After memoTextView.isEditable: \(memoTextView.isEditable)")
        memoTextView.font = UIFont.systemFont(ofSize: 20)
        memoTextView.layer.cornerRadius = 10
        memoTextView.textAlignment = .left
        memoTextView.translatesAutoresizingMaskIntoConstraints = false
        memoTextView.backgroundColor = .secondarySystemBackground
        memoTextView.delegate = self

        NSLayoutConstraint.activate([
            memoTextView.topAnchor.constraint(equalTo: sentenceTextView.bottomAnchor, constant: 24),
            memoTextView.leadingAnchor.constraint(equalTo: stackView.leadingAnchor),
            memoTextView.trailingAnchor.constraint(equalTo: stackView.trailingAnchor),
            memoTextView.bottomAnchor.constraint(equalTo: stackView.bottomAnchor, constant: 24)
        ])
    }

    private func configureViewController() {
        view.backgroundColor = .systemBackground
        let naviEditButton = UIBarButtonItem(title: "Edit", style: .plain, target: self , action: #selector(naviEditButtonPressed))
        navigationItem.rightBarButtonItem = naviEditButton
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard(with:)))
        view.addGestureRecognizer(tapGesture)

        let tapGestureForNavi = UITapGestureRecognizer(target: self, action: #selector(navBarTapped))
                navigationController?.navigationBar.addGestureRecognizer(tapGestureForNavi)
    }

    @objc private func dismissKeyboard(with gesture: UITapGestureRecognizer) {
        print("Other Areas Tapped!")
        sentenceTextView.resignFirstResponder()
        memoTextView.resignFirstResponder()
        tagLabel.resignFirstResponder()
    }

    @objc private func naviEditButtonPressed() {
        memoTextView.isEditable.toggle()
        sentenceTextView.isEditable.toggle()
        tagLabel.isEditable.toggle()

        if sentenceTextView.isEditable {
            sentenceTextView.becomeFirstResponder()

            if let currentItem = realm.objects(DataModel.self).filter("sentence == %@", sentenceTextView.text!).first {
                previousItem = currentItem
            }
            print("編集中")
            let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self , action: #selector(naviEditButtonPressed))
            navigationItem.rightBarButtonItem = cancelButton
        } else {
            print("閲覧のみ")
            let editButton = UIBarButtonItem(title: "Edit", style: .plain, target: self , action: #selector(naviEditButtonPressed))
            navigationItem.rightBarButtonItem = editButton
        }
    }

    private func addToolBarToKeyboard() {

        let toolBar = UIToolbar()
        toolBar.sizeToFit()
        toolBar.backgroundColor = .systemBackground

        let spacer = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: self, action: nil)
        let deleteButton = UIBarButtonItem(title: "delete", style: .plain, target: self, action: #selector(deleteButtonTapped))
        let saveButton = UIBarButtonItem(title: "Save", style: .plain, target: self, action: #selector(saveButtonTapped))

        toolBar.items = [ spacer, deleteButton, spacer, saveButton, spacer]
        sentenceTextView.inputAccessoryView = toolBar
        memoTextView.inputAccessoryView = toolBar
        tagLabel.inputAccessoryView = toolBar
    }

    @objc private func saveButtonTapped() {
        print("save tapped")
        memoTextView.isEditable.toggle()
        sentenceTextView.isEditable.toggle()
        tagLabel.isEditable.toggle()

        if let newItem = realm.objects(DataModel.self).filter("sentence == %@", previousItem?.sentence).first {
            do {
                try realm.write {
                    newItem.sentence = sentenceTextView.text
                    newItem.memo = memoTextView.text
                    newItem.tag = tagLabel.text
                    realm.add(newItem)
                }
            } catch {
                print("error")
            }
        }
        presentAlertOnMainThread(title: "カードが保存されました", message: "", buttonTitle: "OK")

        self.navigationController?.popViewController(animated: true)
    }

    @objc private func deleteButtonTapped() {
        print("delete tapped")
        if let currentItem = realm.objects(DataModel.self).filter("sentence == %@", sentenceTextView.text!).first {
            do {
                try realm.write {
                    realm.delete(currentItem)
                }
            } catch {
                print("deleteできませんでした")
            }
            presentAlertOnMainThread(title: "削除が完了しました", message: "", buttonTitle: "OK")
            self.navigationController?.popViewController(animated: true)
        }
    }

    @objc private func navBarTapped() {
        sentenceTextView.resignFirstResponder()
        memoTextView.resignFirstResponder()
        tagLabel.resignFirstResponder()
    }
}

extension CardDetailVC: UITextViewDelegate {
    
}

#Preview {
    let vc = CardDetailVC()
    return vc
}
